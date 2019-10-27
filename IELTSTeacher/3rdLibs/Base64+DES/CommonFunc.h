



#import <Foundation/Foundation.h>


@interface CommonFunc : NSObject


#define DESKEY    @"92314892"

/**
 加密：先进行DES加密，然后再base64，返回NSString
 */
+ (NSString *)encode:(NSString *)text;

/**
 解密：先解base64，再解DES
 */
+ (NSString *)decode:(NSString *)text;


///**
// DES加密，秘钥已经指定
// */
//+ (NSString *)DESEncrypt:(NSString *)text;
//
///**
// DES解密，秘钥已经指定
// */
//+ (NSString *)DESDecrypt:(NSString *)text;

/*
    先进行DES加密
 */
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;


/**
 base64加密
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 base64解密
 */
+ (NSString *)textFromBase64String:(NSString *)base64;

@end
