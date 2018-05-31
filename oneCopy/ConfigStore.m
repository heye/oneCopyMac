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

+(NSString*) loadKeyOne {
    return [self loadValue:@"key"];
}

+(void) storeLabelOne:(NSString*)key {
    [self storeValue:key withKey:@"label"];
}

+(NSString*) loadLabelOne {
    return [self loadValue:@"label"];
}


@end
