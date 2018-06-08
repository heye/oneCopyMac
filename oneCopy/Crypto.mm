//
//  Crypto.m
//  oneCopy
//
//  Created by Heye Everts on 07/06/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "Crypto.h"
#include <memory>

@implementation Crypto


+ (NSData *) decryptData: (NSDictionary*) input andKey: (NSString*) key{
    NSLog(@"DECRYPT");
    NSLog(@"%@", key);
    NSLog(@"%@", input);
    
    NSString *ivB64 = input[@"iv"];
    NSString *dataB64 = input[@"data"];
    
    if(!ivB64 || !dataB64){
        NSLog(@"decryptData: iv or data missing");
        return nil;
    }
    
    // string -> data
    NSData *ciphertext = [[NSData alloc]
                       initWithBase64EncodedString:dataB64 options:0];
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keys[kCCKeySizeAES256 + 1];
    [key getCString:keys maxLength:sizeof(keys) encoding:NSUTF8StringEncoding];
    
    // Perform PKCS7Padding on the key.
    unsigned long bytes_to_pad = sizeof(keys) - [key length];
    if (bytes_to_pad > 0) {
        char byte = bytes_to_pad;
        for (unsigned long i = sizeof(keys) - bytes_to_pad; i < sizeof(keys); i++)
            keys[i] = byte;
    }
    NSUInteger ciphertextLen = [ciphertext length];
    
    NSLog(@"to decrypt ciphertext len: %lu", (unsigned long)ciphertextLen);
    
    std::unique_ptr<char[]> ciphertextBuff(new char[[ciphertext length]]);
    
    [ciphertext getBytes:ciphertextBuff.get() length:[ciphertext length]];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = ciphertextLen + kCCBlockSizeAES128;
    std::unique_ptr<char[]> plaintextBuff(new char[bufferSize]);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keys, kCCKeySizeAES256,
                                     [ivB64 UTF8String],
                                     ciphertextBuff.get(), ciphertextLen,
                                     plaintextBuff.get(), bufferSize,
                                     &numBytesDecrypted);
    if (status == kCCSuccess)
    {
        NSLog(@"decrypted bytes: %lu", numBytesDecrypted);
        
        //the returned NSData takes ownership of buffer and will free it on dealloc
        return [NSData dataWithBytes:plaintextBuff.get() length:numBytesDecrypted];
    }

    //failure -> nil
    return nil;
}

+ (NSDictionary *) encryptData: (NSData*) input andKey: (NSString*) key{
    NSLog(@"ENCRYPT");
    
    NSMutableDictionary *outDict = [[NSMutableDictionary alloc] init];

    NSString *ivB64 = @"randomiv";
    
    // string -> data
    NSData *ciphertext = [[NSData alloc] init];
    
    
    
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keys[kCCKeySizeAES256 + 1];
    [key getCString:keys maxLength:sizeof(keys) encoding:NSUTF8StringEncoding];
    
    // Perform PKCS7Padding on the key.
    unsigned long bytes_to_pad = sizeof(keys) - [key length];
    if (bytes_to_pad > 0) {
        char byte = bytes_to_pad;
        for (unsigned long i = sizeof(keys) - bytes_to_pad; i < sizeof(keys); i++)
            keys[i] = byte;
    }
    
    
    NSUInteger plaintextLen = [input length];
    
    NSLog(@"to encrypt plaintext len: %lu", (unsigned long)plaintextLen);
    
    std::unique_ptr<char[]> plaintextBuff(new char[plaintextLen]);
    
    [input getBytes:plaintextBuff.get() length:plaintextLen];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = plaintextLen + kCCBlockSizeAES128;
    std::unique_ptr<char[]> ciphertextBuff(new char[bufferSize]);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                     kCCOptionPKCS7Padding,
                                     keys, kCCKeySizeAES256,
                                     [ivB64 UTF8String],
                                     plaintextBuff.get(), plaintextLen,
                                     ciphertextBuff.get(), bufferSize,
                                     &numBytesEncrypted);
    if (status == kCCSuccess)
    {
        NSLog(@"encrypted bytes: %lu", numBytesEncrypted);
        //the returned NSData takes ownership of buffer and will free it on dealloc
        NSData *ciphertext = [NSData dataWithBytes:ciphertextBuff.get() length:numBytesEncrypted];
        
        
        NSString *ciphertextStr = [ciphertext base64EncodedStringWithOptions:0];
        
        
        [outDict setObject:ivB64 forKey:@"iv"];
        [outDict setValue:ciphertextStr forKey:@"data"];
        return outDict;

    }
    
    //failure -> empty dict
    return outDict;
}



+ (NSString *) decryptString: (NSString*) input andKey: (NSString*) key{
    NSDictionary *dict =[Crypto deserializeDict:input];
    NSLog(@"to decrypt: %@", dict);
    
    NSData *plaintextData = [Crypto decryptData:dict andKey:key];
    
    return [[NSString alloc]
                           initWithData:plaintextData encoding:NSUTF8StringEncoding];
}

+ (NSString *) encryptString: (NSString*) input andKey: (NSString*) key{
    NSData *toEncrypt = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *encrypted = [Crypto encryptData:toEncrypt andKey:key];
    NSLog(@"encrypted: %@", encrypted);
    return [Crypto serializeDict:encrypted];
}

+ (NSString *) serializeDict: (NSDictionary*) dict {
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&err];
    return [jsonData base64EncodedStringWithOptions:0];
}

+ (NSDictionary *) deserializeDict: (NSString*) str {
    NSError * err;
    
    
    NSData *data = [[NSData alloc]
                    initWithBase64EncodedString:str options:0];
    
    
    
    //NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * response;
    if(data!=nil){
        response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    }
    return response;
}



+ (void) test{
    NSString *key = @"mykey";
    NSString *toTest = @"test";
    
    
    NSLog(@"DATATEST");
    
    NSData *toTestData = [toTest dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *encryptedData = [Crypto encryptData:toTestData andKey:key];
    NSData *decryptedData = [Crypto decryptData:encryptedData andKey:key];
    
    NSString *decrytedDataStr = [[NSString alloc]
                           initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"data encrytped: %@", encryptedData);
    NSLog(@"data decrypted: %@", decrytedDataStr);
    
    
    NSLog(@"STRINGTEST");
    NSString *encrypted = [Crypto encryptString:toTest andKey:key];
    NSString *decrypted = [Crypto decryptString:encrypted andKey:key];
    
    
    NSLog(@"string encrypted: %@", encrypted);
    NSLog(@"string decrypted: %@", decrypted);
    
}



@end
