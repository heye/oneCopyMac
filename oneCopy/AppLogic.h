//
//  AppLogic.h
//  oneCopy
//
//  Created by Heye Everts on 12/06/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLogic : NSObject

+(void) pushKey: (NSString*) apiKey;
+(void) pullKey: (NSString*) apiKey;

+(void) showSettings;
+(void) quitApp;

@end
