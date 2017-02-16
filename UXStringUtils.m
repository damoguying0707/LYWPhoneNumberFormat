//
//  UXStringUtils.m
//  YouxinClient
//
//  Created by vincent.li on 16/2/18.
//  Copyright © 2016年 UXIN CO. All rights reserved.
//

#import "UXStringUtils.h"
#import "PhoneNumberAttribution.h"

@implementation UXStringUtils

+ (NSString *)dealCountryCodeAddCharacterToDoubleZeroWithPhone:(NSString *)phone {
    NSString *result = phone;
    if(phone.length > 0){
        NSString *firstCharcter = [phone substringToIndex:1];
        if([firstCharcter isEqualToString:@"+"]){
            result = [NSString stringWithFormat:@"00%@",[phone substringFromIndex:1]];
        }
    }
    return result;
}

+ (NSString *)dealWithEmptyOrLinkFlagWithPhoneNumber:(NSString *)strPhoneNumber
{
    if (strPhoneNumber == nil) {
        return @"";
    }
    
    NSString *strReault = [strPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 去掉'-'vincent.li
    strReault = [strReault stringByReplacingOccurrencesOfString:@"-" withString:@""];
    // 去掉'('和')'
    strReault = [strReault stringByReplacingOccurrencesOfString:@"(" withString:@""];
    strReault = [strReault stringByReplacingOccurrencesOfString:@")" withString:@""];
    return strReault;
}


+ (NSString *)dealWithPhoneNumber:(NSString *)strPhoneNumber {
    
    if (strPhoneNumber == nil) {
        return @"";
    }
    
    NSString *strReault = [UXStringUtils dealWithEmptyOrLinkFlagWithPhoneNumber:strPhoneNumber];
    strReault = [UXStringUtils dealCountryCodeAddCharacterToDoubleZeroWithPhone:strReault];

    // 判断帐号是中国的，则要去掉+86，0086，17951等前缀
    //国际号肯定是00或＋开头，有这些的肯定是国内号
//    if ([UXUserInfoManager isAccountCHN]) {
    
        // 去掉'+86'
        strReault = [strReault stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        
        BOOL bPreFix = NO;
        
        // 去掉号码前面加的"0086"
        bPreFix = [strReault hasPrefix:@"0086"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
        
        // 去掉号码前面加的“12593”
        bPreFix = [strReault hasPrefix:@"12593"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        
        // 去掉号码前面加的“17951”
        bPreFix = [strReault hasPrefix:@"17951"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        
        // 去掉号码前面加的“17911”
        bPreFix = [strReault hasPrefix:@"17911"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        bPreFix = [strReault hasPrefix:@"17909"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
//    }
    
    if ([strReault length] < 1) {
        return @"";
    } else {
        // 1.(38).013-8000  // 0xC2 0xA0 // NO-BREAK SPACE
        // 31 C2 A0 28 33 38 30 29 C2 A0 30 31 33 2D 38 30 30 30
        // 31 C2 A0    33 38 30    C2 A0 30 31 33    38 30 30 30
        
        // ;&nbsp
        
        // http://www.utf8-chartable.de/unicode-utf8-table.pl?names=-&utf8=0x
        // http://stackoverflow.com/questions/15835849/why-are-these-unicode-characters-not-printed-although-i-set-my-environment-to-ut
        //
        // You won't see much even if your terminal is configured to work with UTF-8 because
        // the characters you are 'displaying' are:
        // 0xC2 0x82 = U+0082
        // 0xC2 0x81 = U+0081
        // 0xC2 0x80 = U+0080
        //
        // These are control-characters from the C1 set. I have a data file which documents:
        //
        // # C1 Controls (0x80 - 0x9F) are from ISO/IEC 6429:1992
        // # It does not define names for 80, 81, or 99.
        // 80 U+0080
        // 81 U+0081
        // 82 U+0082 BPH BREAK PERMITTED HERE
        //
        // So you don't see anything because you aren't displaying any graphic characters.
        // If you change your 0x82 to 0xA2, for example (and 0x81 to 0xA1, and 0x80 to 0xA0),
        // then you'll be more likely to get some visible output:
        //
        //    0xC2 0xA2 = U+00A2
        //    0xC2 0xA1 = U+00A1
        //    0xC2 0xA0 = U+00A0
        //
        //    A0 U+00A0 NO-BREAK SPACE
        //    A1 U+00A1 INVERTED EXCLAMATION MARK
        //    A2 U+00A2 CENT SIGN
        
        NSString *strNewResult = [[NSString alloc] init];
        for( int i = 0; i<[strReault length]; ++i ) {
            NSString* strTest = [[strReault substringFromIndex:i] substringToIndex:1];
            if( strTest &&
               (NSOrderedSame == [strTest compare:@"0"] ||
                NSOrderedSame == [strTest compare:@"1"] ||
                NSOrderedSame == [strTest compare:@"2"] ||
                NSOrderedSame == [strTest compare:@"3"] ||
                NSOrderedSame == [strTest compare:@"4"] ||
                NSOrderedSame == [strTest compare:@"5"] ||
                NSOrderedSame == [strTest compare:@"6"] ||
                NSOrderedSame == [strTest compare:@"7"] ||
                NSOrderedSame == [strTest compare:@"8"] ||
                NSOrderedSame == [strTest compare:@"9"] )) {
                strNewResult = [strNewResult stringByAppendingFormat:@"%@",strTest];
            } else {
                //const unsigned char* pTest = (const unsigned char*)[strTest UTF8String];
                //NSLog(@"DealWithPhoneNumber WHAT? %@", strTest);
            }
        }
        
        return strNewResult;
    }
}

+ (NSString *)dealWithPhoneNumberAndReserveAddCharacter:(NSString *)strPhoneNumber {
    
    if (strPhoneNumber == nil) {
        return @"";
    }
    
    NSString *strReault = [UXStringUtils dealWithEmptyOrLinkFlagWithPhoneNumber:strPhoneNumber];
    
    // 判断帐号是中国的，则要去掉+86，0086，17951等前缀
    //国际号肯定是00或＋开头，有这些的肯定是国内号
//    if ([UXUserInfoManager isAccountCHN]) {
    
        // 去掉'+86'
        strReault = [strReault stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        
        BOOL bPreFix = NO;
        
        // 去掉号码前面加的"0086"
        bPreFix = [strReault hasPrefix:@"0086"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
        }
        
        // 去掉号码前面加的“12593”
        bPreFix = [strReault hasPrefix:@"12593"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        
        // 去掉号码前面加的“17951”
        bPreFix = [strReault hasPrefix:@"17951"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        
        // 去掉号码前面加的“17911”
        bPreFix = [strReault hasPrefix:@"17911"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
        bPreFix = [strReault hasPrefix:@"17909"];
        if (bPreFix) {
            strReault = [strReault stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@""];
        }
//    }
    
    if ([strReault length] < 1) {
        return @"";
    } else {
        // 1.(38).013-8000  // 0xC2 0xA0 // NO-BREAK SPACE
        // 31 C2 A0 28 33 38 30 29 C2 A0 30 31 33 2D 38 30 30 30
        // 31 C2 A0    33 38 30    C2 A0 30 31 33    38 30 30 30
        
        // ;&nbsp
        
        // http://www.utf8-chartable.de/unicode-utf8-table.pl?names=-&utf8=0x
        // http://stackoverflow.com/questions/15835849/why-are-these-unicode-characters-not-printed-although-i-set-my-environment-to-ut
        //
        // You won't see much even if your terminal is configured to work with UTF-8 because
        // the characters you are 'displaying' are:
        // 0xC2 0x82 = U+0082
        // 0xC2 0x81 = U+0081
        // 0xC2 0x80 = U+0080
        //
        // These are control-characters from the C1 set. I have a data file which documents:
        //
        // # C1 Controls (0x80 - 0x9F) are from ISO/IEC 6429:1992
        // # It does not define names for 80, 81, or 99.
        // 80 U+0080
        // 81 U+0081
        // 82 U+0082 BPH BREAK PERMITTED HERE
        //
        // So you don't see anything because you aren't displaying any graphic characters.
        // If you change your 0x82 to 0xA2, for example (and 0x81 to 0xA1, and 0x80 to 0xA0),
        // then you'll be more likely to get some visible output:
        //
        //    0xC2 0xA2 = U+00A2
        //    0xC2 0xA1 = U+00A1
        //    0xC2 0xA0 = U+00A0
        //
        //    A0 U+00A0 NO-BREAK SPACE
        //    A1 U+00A1 INVERTED EXCLAMATION MARK
        //    A2 U+00A2 CENT SIGN
        
        NSString *strNewResult = [[NSString alloc] init];
        for( int i = 0; i<[strReault length]; ++i ) {
            NSString* strTest = [[strReault substringFromIndex:i] substringToIndex:1];
            if( strTest &&
               (NSOrderedSame == [strTest compare:@"0"] ||
                NSOrderedSame == [strTest compare:@"1"] ||
                NSOrderedSame == [strTest compare:@"2"] ||
                NSOrderedSame == [strTest compare:@"3"] ||
                NSOrderedSame == [strTest compare:@"4"] ||
                NSOrderedSame == [strTest compare:@"5"] ||
                NSOrderedSame == [strTest compare:@"6"] ||
                NSOrderedSame == [strTest compare:@"7"] ||
                NSOrderedSame == [strTest compare:@"8"] ||
                NSOrderedSame == [strTest compare:@"9"] ||
                (NSOrderedSame == [strTest compare:@"+"] && i == 0))) {
                   strNewResult = [strNewResult stringByAppendingFormat:@"%@",strTest];
               } else {
                   //const unsigned char* pTest = (const unsigned char*)[strTest UTF8String];
                   //NSLog(@"DealWithPhoneNumber WHAT? %@", strTest);
               }
        }
        
        return strNewResult;
    }

    
}

+ (BOOL)isMobileNumber:(NSString *)strPhoneNum {
    BOOL bMobieNumber = NO;
    
    if (nil != strPhoneNum) {
        strPhoneNum = [UXStringUtils dealWithPhoneNumber:strPhoneNum];
        if (11 == [strPhoneNum length] && '1' == [strPhoneNum characterAtIndex:0]) {
            bMobieNumber = YES;
        }
    }
    
    return bMobieNumber;
}

+ (BOOL)isInternationalNumber:(NSString *)strPhoneNum {
    
    BOOL bRet = NO;
    
    if (nil != strPhoneNum) {
        
        if ([strPhoneNum length] > 4) {
            
            if ([UXStringUtils isNSStringPureInt:strPhoneNum]) {
                
                NSString *strBeginTwo = [strPhoneNum substringToIndex:2];
                NSString *strBeginFour = [strPhoneNum substringToIndex:4];
                
                if ([strBeginTwo isEqualToString:@"00"] &&
                    ![strBeginFour isEqualToString:@"0086"]) {
                    
                    bRet = YES;
                }
            } else {
                
                NSString *strBeginOne   = [strPhoneNum substringToIndex:1];
                NSString *strBeginThree = [strPhoneNum substringToIndex:3];
                if ([strBeginOne isEqualToString:@"+"] &&
                    ![strBeginThree isEqualToString:@"+86"]) {
                    
                    bRet = YES;
                }
            }
        }
    }
    
    return bRet;
}

+ (BOOL)isContainChinese:(NSString *)string {
    
    for(int i = 0; i < [string length]; ++i) {
        
        unichar a = [string characterAtIndex:i];
        if(a >= 0x4e00 && a <= 0x9fff) {
            
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isContainNumOrZimu:(NSInteger)string {
    
    if (string>=0x30&&string<=0x39) {
        return YES;
    }
    if (string>=0x41&&string<=0x5a) {
        return YES;
    }
    if (string>=0x61&&string<=0x7a) {
        return YES;
    }
    
    return NO;
}

+ (char *)byteToHex:(const unsigned char*)vByte length:(const int)vLen {
    
    if(!vByte)
        return NULL;
    
    char* tmp = (char *)malloc(vLen * 2 + 1); // 一个字节两个十六进制码，最后多一个'\0'
    
    int tmp2;
    for (int i = 0; i < vLen; ++i) {
        tmp2 = (int)(vByte[i]) / 16;
        tmp[i * 2] = (char)(tmp2 + ((tmp2 > 9) ? 'A'-10 : '0'));
        tmp2 = (int)(vByte[i]) % 16;
        tmp[i * 2 + 1] = (char)(tmp2 + ((tmp2 > 9) ? 'A' -10 : '0'));
    }
    
    tmp[vLen * 2] = '\0';
    return tmp;
}

// 十六进制字符串转换为字节码(注意要大写字母)
// szHex    :   十六进制字符串
// 返回值，unsigned char*，返回转换后的字节码地址，空间新分配，需手动释放
+ (unsigned char *)hexToByte:(const char *)szHex {
    
    if(!szHex)
        return NULL;
    
    int iLen = (int)strlen(szHex);
    
    if (iLen <= 0 || 0 != iLen % 2)
        return NULL;
    
    unsigned char* pbBuf = (unsigned char *)malloc(iLen / 2);  // 数据缓冲区
    
    int tmp1,tmp2;
    for (int i = 0; i < iLen / 2; ++i) {
        tmp1 = (int)szHex[i * 2] - (((int)szHex[i * 2] >= 'A') ? 'A' - 10 : '0');
        
        if(tmp1 >= 16) {
            free(pbBuf);
            return NULL;
        }
        
        
        tmp2 = (int)szHex[i * 2 + 1] - (((int)szHex[i * 2 + 1] >= 'A') ? 'A' - 10 : '0');
        
        if(tmp2 >= 16) {
            free(pbBuf);
            return NULL;
        }
        
        
        pbBuf[i] = (tmp1 * 16 + tmp2);
    }
    
    return pbBuf;
}

+ (BOOL)isNSStringPureInt:(NSString *)string {
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isPureNumandCharacters:(NSString *)text {
    
    for(int i = 0; i < [text length]; ++i) {
        int a = [text characterAtIndex:i];
        if (a >= 0x30 && a <= 0x39){
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isPureLetterCharacters:(NSString *)text {
    
    for(int i = 0; i < [text length]; ++i) {
        int a = [text characterAtIndex:i];
        if ((a >= 0x41 && a <= 0x5a) || ((a >= 0x61 && a <= 0x7a))){
            continue;
        } else {
            return NO;
        }
    }
    return YES;
}


+ (NSString *)stringContainsEmoji:(NSString *)string {
    
    BOOL returnValue = NO;
    __block NSString  *lastEmojiIf;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                lastEmojiIf = substring;
                            }];
    
    const unichar hs = [lastEmojiIf characterAtIndex:0];
    returnValue = NO;
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (lastEmojiIf.length > 1) {
            const unichar ls = [lastEmojiIf characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (lastEmojiIf.length > 1) {
        const unichar ls = [lastEmojiIf characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    
    if (returnValue) {
        return lastEmojiIf;
    }
    
    return nil;
}

+ (NSInteger)calStringCharCount:(NSString *)str {
    
    NSInteger count = 0;
    
    for(int i = 0; i < [str length]; ++i) {
        
        unichar a = [str characterAtIndex:i];
        if(a >= 0x4e00 && a <= 0x9fff) {
            
            count += 4;//一个中文当4个字符
        } else {
            
            count += 1;//其余就是一个字符
        }
    }
    
    return count;
}

+ (NSInteger)calString:(NSString*)str maxLength:(NSInteger)max {
    
    NSInteger length = 0;
    NSInteger count = 0;
    for(length = 0; length < [str length]; ++length) {
        
        unichar a = [str characterAtIndex:length];
        
        if(a >= 0x4e00 && a <= 0x9fff) {
            count += 4;//一个中文当4个字符
        } else {
            count += 1;//其余就是一个字符
        }
        
        if (count > max) {
            
            break;
        } else if (count == max) {
            length++;
            break;
        }
    }
    
    return length;
}

+ (NSString*)outputString:(NSString*)source limited:(NSInteger)max {
    
    NSString* output;
    
    //按下return键
    NSInteger count = [UXStringUtils calStringCharCount:source];
    if (count > max) {
        NSRange range;
        range.location = 0;
        range.length = [UXStringUtils calString:source maxLength:max];
        NSLog(@"%@",[source substringWithRange:range]);
        output = [source substringWithRange:range];
    } else {
        output = source;
    }
    
    return output;
}

//返回{1000，0}，说明没找到
+ (NSRange)searchSignitureTextResprensentaion:(NSString *)text
{
    //此方法不是最优  有时间再找一下正则表达式的正确写法，次写法绝对有问题
    NSRange firstRange =  [text rangeOfString:@"]"];
    NSRange range = NSMakeRange(0,0);
    // locate images
    if (!text||text.length == 0)
    {
        return NSMakeRange(0, 0);
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[.*\\]\\s)"
                                                                           options:NSRegularExpressionAnchorsMatchLines
                                  
                                                                             error:nil];
    
    NSUInteger searchLength = MIN(firstRange.location + 2,text.length);
    
    NSArray* matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, searchLength)];
    
    if (matches.count > 0)
    {
        NSTextCheckingResult* result = [matches firstObject];
        NSRange tmpRange = [result range];
        if (tmpRange.location == 0)
        {
            range = tmpRange;
        }
        //  range = [regex rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, text.length)];
    }
    
    return range;
}

//投机方法
+ (NSString *)spaceStringAccordingDesiredWidth:(CGFloat)width withTextFont:(UIFont *)font {
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize textSize = [@" " boundingRectWithSize:CGSizeMake(1000, 50)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attribute
                                         context:nil].size;
    
    NSInteger numSpc = (NSInteger)width/textSize.width + 1;
    NSMutableString *rs = [[NSMutableString alloc] init];
    
    for (int i = 0; i < numSpc; i++)
    {
        [rs appendString:@" "];
    }
    
    return rs;
}

// http://www.a.com/test.jpg，返回test.jpg
// 没有则返回空
+ (NSString *)getPicNameByUrlFullPath:(NSString *)strUrl {
    
    if (strUrl == nil || [strUrl length] < 1) {
        return @"";
    }
    
    //http://www.a.com/test.jpg
    NSArray * arr = [strUrl componentsSeparatedByString:@"/"];
    if (arr && [arr count] > 0) {
        NSString * strName = [[NSString alloc ]  initWithString:[arr objectAtIndex:[arr count] - 1]];
        return strName;
    }
    return @"";
}

+ (NSString *)extractNumberFromString:(NSString *)sourceString {
    
    __autoreleasing NSMutableString *numberString = [[NSMutableString alloc] initWithString:@""];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:sourceString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        if (tempStr.length > 0) {
            [numberString appendString:tempStr];
        }
        tempStr = @"";
    }
    
    return numberString;
}

+ (NSString *)formatChinaMainlandMobileNumber:(NSString *)mobileNumber {
    return [self formatChinaMainlandMobileNumber:mobileNumber withSeparator:nil];
}

+ (NSString *)formatChinaMainlandMobileNumberHasLine:(NSString *)mobileNumber {
    return [self formatChinaMainlandMobileNumber:mobileNumber withSeparator:@"-"];
}

+ (NSString *)formatChinaMainlandMobileNumber:(NSString *)mobileNumber withSeparator:(NSString *)separator {

    if (!IS_VALID_NSSTRING(mobileNumber)){
        return mobileNumber;
    }
    NSString *newSeparator = separator;
    if (!IS_VALID_NSSTRING(separator)) {
        newSeparator = @" ";
    }

    BOOL isMobileNumber = [self isMobileNumber:mobileNumber];
    BOOL isInternationalNumber = [self isInternationalNumber:mobileNumber];

    NSString *formattedMobileNumber = mobileNumber;
    if (mobileNumber &&
        [mobileNumber isKindOfClass:[NSString class]] &&
        mobileNumber.length > 0
        && isMobileNumber
        ) {
        formattedMobileNumber = [UXStringUtils extractNumberFromString:mobileNumber];
        
        if (formattedMobileNumber.length == 11) {//11位的中国大陆手机号码

            formattedMobileNumber = [NSString stringWithFormat:@"%@%@%@%@%@",
                                     [formattedMobileNumber substringWithRange:NSMakeRange(0, 3)],
                                     newSeparator,
                                     [formattedMobileNumber substringWithRange:NSMakeRange(3, 4)],
                                     newSeparator,
                                     [formattedMobileNumber substringWithRange:NSMakeRange(7, 4)]];
        }
    } else if (!isInternationalNumber) {
        formattedMobileNumber = [self seperateCityCodeWithPhoneNumber:formattedMobileNumber];
    }

    return formattedMobileNumber;
}

+ (NSString *)trimString:(NSString *)sourceString {
    
    if (sourceString && [sourceString isKindOfClass:[NSString class]]) {
        return [sourceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return nil;
}

/**
 * @brief 去除字符串前后空格与换行,如果源字符串为nil，则返回空字符串
 *
 * @param sourceString 源字符串
 *
 * @return 源字符串为nil，则返回空字符串，如果源字符串不为nil则返回去除字符串前后空格与换行后的字符串
 */
+ (NSString *)trimStringReturnEmptyStringIfNil:(NSString *)sourceString {
    
    if (sourceString && [sourceString isKindOfClass:[NSString class]]) {
        return [sourceString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return @"";
}

/**
 *  移除字符串中的HTML标签
 *
 *  @param 带html标签的源字符串
 *  @return 返回过滤掉html标签后的字符串
 */
+ (NSString *)removeHTMLTag:(NSString *)sourceString {
    
    NSScanner * scanner = [NSScanner scannerWithString:sourceString];
    NSString * text = nil;
    while([scanner isAtEnd]==NO) {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        sourceString = [sourceString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    
    return sourceString;
}
/**
 *  判断字符串是否为空
 *
 *  @param string 需要判断的字符串
 *
 *  by sandy
 */
+ (BOOL) isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    if ([string isEqualToString:@"(null)"])
    {
        return YES;
    }
    return NO;
}

+ (NSString *)seperateCityCodeWithPhoneNumber:(NSString *)phone
{
    NSString *seperatePhone = phone;
    if(phone.length == 11 || phone.length == 12){
        NSString *firstCharacter = [phone substringWithRange:NSMakeRange(0, 1)];
        if([firstCharacter isEqualToString:@"0"] && ![phone hasPrefix:@"00"]){
            NSString *cityCode = [[PhoneNumberAttribution instance] getCityCode:phone];
            if(cityCode.length > 0){//匹配城市区号
                cityCode = [@"0" stringByAppendingString:cityCode];
                seperatePhone = [NSString stringWithFormat:@"%@-%@",cityCode,[phone substringFromIndex:cityCode.length]];
            }
        }
    }
    return seperatePhone;
}

@end
