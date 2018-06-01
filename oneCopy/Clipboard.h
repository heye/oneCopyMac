//
//  Clipboard.h
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clipboard : NSObject

+(void) setString:(NSString*)value;
+(void) setStringB64:(NSString*)valueB64;
+(NSString*) getString;
+(NSString*) getStringB64;

+(BOOL) isFile;
+(NSData*) getFile;
+(void) setFileB64:(NSString*)valueB64 fileName: (NSString*) fileName;

+ (NSURL*)applicationDataDirectory;
+(void) createDir:(NSString*)dir;
@end
