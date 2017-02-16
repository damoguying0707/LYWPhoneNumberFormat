//
//  UXStringUtils.h
//  YouxinClient
//
//  Created by vincent.li on 16/2/18.
//  Copyright © 2016年 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UXStringUtils : NSObject

/**
 *  将＋号换成00
 *
 *  @param phone 带＋号的电话号码 ＋181231345464
 *
 *  @return 返回00开头的电话号码
 */
+ (NSString *)dealCountryCodeAddCharacterToDoubleZeroWithPhone:(NSString *)phone;

/**
 *  处理电话号码，去除多余的字符,'-' '(' ')' '等，不去掉＋＊等符号
 */
+ (NSString *)dealWithEmptyOrLinkFlagWithPhoneNumber:(NSString *)strPhoneNumber;

/**
 *  处理电话号码，去除多余的字符,'-' '(' ')' '+86'等，得到纯粹的，干净的号码,国际号+号会换成00
 *  +号表示00
 *  处理普通号码展示逻辑尽量保留＋号：dealWithPhoneNumberAndReserveAddCharacter:
 */
+ (NSString *)dealWithPhoneNumber:(NSString *)strPhoneNumber;

/**
 *  处理电话号码，去除多余的字符,'-' '(' ')' '+86'等，得到纯粹的，干净的号码,国际号+号会保留
 *
 *  国际号的＋号不去掉
 *
 */
+ (NSString *)dealWithPhoneNumberAndReserveAddCharacter:(NSString *)strPhoneNumber;


/**
 *  判断是否手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)strPhoneNum;

/**
 *  判断是否是国际号码
 */
+ (BOOL)isInternationalNumber:(NSString *)strPhoneNum;

/**
 *  判断字符串是否包含汉字
 */
+ (BOOL)isContainChinese:(NSString*)string;

/**
 *  判断是否是数字跟字母
 */
+ (BOOL)isContainNumOrZimu:(NSInteger)string;

/**
 *  字节码转换为十六进制字符串
 */
+ (char*)byteToHex:(const unsigned char *) vByte length:(const int)vLen;

/**
 *  十六进制字符串转换为字节码(注意要大写字母)
 */
+ (unsigned char*)hexToByte:(const char *) szHex;

/**
 *  字符串是否是纯数字
 */
+ (BOOL)isNSStringPureInt:(NSString *)string;

/**
 *  字符串是否是纯数字
 */
+ (BOOL)isPureNumandCharacters:(NSString *)text;

/**
 *  字符串是否纯字母
 */
+ (BOOL)isPureLetterCharacters:(NSString *)text;

/**
 *  获取字符串中的最后一个emoji表情
 */
+ (NSString *)stringContainsEmoji:(NSString *)string;

/**
 *  计算字符串的字符数
 */
+ (NSInteger)calStringCharCount:(NSString *)str;

/**
 *  输出限制的字符串
 */
+ (NSString *)outputString:(NSString *)source limited:(NSInteger)max;

/**
 *  获取特殊字符的NSRange,定制为[...]space,且必须为NSString的首写
 */
+ (NSRange)searchSignitureTextResprensentaion:(NSString *)text;

/**
 *  不知道在做什么，后续会去掉
 */
+ (NSString *)spaceStringAccordingDesiredWidth:(CGFloat)width withTextFont:(UIFont *)font;

/**
 *  通过URL得到图片名称
 */
+ (NSString *)getPicNameByUrlFullPath:(NSString *)strUrl;

/**
 * 从字符串中提取出数字
 */
+ (NSString *)extractNumberFromString:(NSString *)sourceString;

/**
 * @brief 中国大陆的手机号格式化
 *
 * 比如:13543440304 -> 135 4344 0304
 *
 * @param mobileNumber 大陆的11位手机号码字符串
 * @return 返回格式化的手机号码字符串
 */
+ (NSString *)formatChinaMainlandMobileNumber:(NSString *)mobileNumber;

/**
 * @brief 中国大陆的手机号格式化
 *
 * 比如:13543440304 -> 135-4344-0304
 *
 * @param mobileNumber 大陆的11位手机号码字符串
 * @return 返回格式化的手机号码字符串
 */
+ (NSString *)formatChinaMainlandMobileNumberHasLine:(NSString *)mobileNumber;

/**
 * @brief 去除字符串前后空格与换行,如果源字符串为nil，则返回nil
 *
 * @param sourceString 源字符串
 *
 * @return 源字符串为nil，则返回nil，如果源字符串不为nil则返回去除字符串前后空格与换行后的字符串
 */
+ (NSString *)trimString:(NSString *)sourceString;

/**
 * @brief 去除字符串前后空格与换行,如果源字符串为nil，则返回空字符串
 *
 * @param sourceString 源字符串
 *
 * @return 源字符串为nil，则返回空字符串，如果源字符串不为nil则返回去除字符串前后空格与换行后的字符串
 */
+ (NSString *)trimStringReturnEmptyStringIfNil:(NSString *)sourceString;

/**
 *  移除字符串中的HTML标签
 *
 *  @param 带html标签的源字符串
 *  @return 返回过滤掉html标签后的字符串
 */
+ (NSString *)removeHTMLTag:(NSString *)sourceString;

/**
 *  判断字符串是否为空
 *
 *  @param string 需要判断的字符串
 *
 *  by sandy
 */
+ (BOOL) isBlankString:(NSString *)string;


/**
 *  给带区号的11位和12位号码添加分隔线 075512345678 -> 0755-12345678
 *  
 *  @param phone 075512345678 或 01012345678
 *
 *  @return 0755-12345678 或 010-12345678
 */
+ (NSString *)seperateCityCodeWithPhoneNumber:(NSString *)phone;

@end
