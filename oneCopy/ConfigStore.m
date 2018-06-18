//
//  ConfigStore.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "ConfigStore.h"

@implementation ConfigStore


+(void) storeValue: (NSString*)value withKey: (NSString*) key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
}

+(NSString*) loadValue: (NSString*)key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *loadedKey = [userDefaults stringForKey:key];
    
    if(!loadedKey)
        return @"";
    
    return loadedKey;
}

+(void) storeKeyOne:(NSString*)key {
    [self storeValue:key withKey:@"key"];
}

+(void) storeKeyTwo:(NSString*)key {
    [self storeValue:key withKey:@"key2"];
}

+(NSString*) loadKeyOne {
    return [self loadValue:@"key"];
}

+(NSString*) loadKeyTwo {
    return [self loadValue:@"key2"];
}

+(void) storeLabelOne:(NSString*)key {
    [self storeValue:key withKey:@"label"];
}

+(NSString*) loadLabelOne {
    return [self loadValue:@"label"];
}

+(void) storeEncKeyOne:(NSString*)key {
    [self storeValue:key withKey:@"encKeyOne"];
}

+(void) storeEncKeyTwo:(NSString*)key {
    [self storeValue:key withKey:@"encKey2"];
}

+(NSString*) loadEncKeyOne {
    return [self loadValue:@"encKeyOne"];
}

+(NSString*) loadEncKeyTwo {
    return [self loadValue:@"encKey2"];
}

+(NSString*) loadServerAddr {
    NSString* serverAddr = [self loadValue:@"server"];
    
    if([serverAddr isEqualToString:@""]){
        return @"https://azenix.io";
    }
    
    return serverAddr;
}

+(NSString*) loadServerAddrTwo {
    NSString* serverAddr = [self loadValue:@"server2"];
    return serverAddr;
}

+(void) storeServerAddr:(NSString *)key {
    [self storeValue:key withKey:@"server"];
}

+(void) storeServerAddrTwo:(NSString *)key {
    [self storeValue:key withKey:@"server2"];
}


@end
