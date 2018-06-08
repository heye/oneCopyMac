//
//  ConfigStore.h
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigStore : NSObject

+(void) storeKeyOne: (NSString*)key;
+(NSString*) loadKeyOne;

+(void) storeLabelOne: (NSString*)key;
+(NSString*) loadLabelOne;

+(void) storeEncKeyOne: (NSString*)key;
+(NSString*) loadEncKeyOne;

+(void) storeServerAddr: (NSString*)key;
+(NSString*) loadServerAddr;


+(void) storeValue: (NSString*)value withKey: (NSString*) key;
+(NSString*) loadValue: (NSString*)key;

@end
