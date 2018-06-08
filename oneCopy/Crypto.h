//
//  Crypto.h
//  oneCopy
//
//  Created by Heye Everts on 07/06/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface Crypto : NSObject
+ (NSData *) decryptData: (NSDictionary*) input andKey: (NSString*) key;
+ (NSDictionary *) encryptData: (NSData*) input andKey: (NSString*) key;

+ (NSString *) decryptString: (NSString*) input andKey: (NSString*) key;
+ (NSString *) encryptString: (NSString*) input andKey: (NSString*) key;

+ (NSString *) serializeDict: (NSDictionary*) dict;
+ (NSDictionary *) deserializeDict: (NSString*) str;

+ (void) test;

@end
