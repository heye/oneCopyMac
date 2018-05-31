//
//  Clipboard.h
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clipboard : NSObject

+(void) setString:(NSString*)text;
+(NSString*) getString;

@end
