//
//  Clipboard.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "Clipboard.h"
#import "Notifications.h"
#import <AppKit/AppKit.h>

@implementation Clipboard

+(void) setStringB64:(NSString*)valueB64{
    
    // string -> data
    NSData *dataB64 = [[NSData alloc]
                       initWithBase64EncodedString:valueB64 options:0];
    
    // data -> decode -> string
    NSString *value = [[NSString alloc]
                       initWithData:dataB64 encoding:NSUTF8StringEncoding];
    
    NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    [myPasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
    [myPasteboard setString:value forType:NSPasteboardTypeString];
}

+(NSString*) getStringB64{
    NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    NSString* value = [myPasteboard  stringForType:NSPasteboardTypeString];
    
    // Get NSString from NSData object in Base64
    NSData *nsdata = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [nsdata base64EncodedStringWithOptions:0];
}


+(BOOL) isFile{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [NSArray arrayWithObject:[NSURL class]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithBool:YES] forKey:NSPasteboardURLReadingFileURLsOnlyKey];
    
    NSArray *fileURLs =
    [pasteboard readObjectsForClasses:classes options:options];
    
    
    return [fileURLs count] > 0;
}


+(NSString*) getFileB64{
    //NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    //NSString* value = [myPasteboard  stringForType:NSPasteboardTypeString];
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [NSArray arrayWithObject:[NSURL class]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithBool:YES] forKey:NSPasteboardURLReadingFileURLsOnlyKey];
    
    NSArray *fileURLs =
    [pasteboard readObjectsForClasses:classes options:options];
    
    if([fileURLs count] > 1){
        [Notifications make:@"only one file at a time, please"];
    }
    
    if([fileURLs count] == 0){
        NSLog(@"no copied file found");
        return @"";
    }
    
    NSURL* filePath = [fileURLs firstObject];
    NSLog(@"%@", filePath);
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath: filePath.path error:nil] fileSize];
    
    NSLog(@"%llu", fileSize);

    if(fileSize > 1000000){
        [Notifications make:@"file must be < 1MB"];
        return @"";
    }

    
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForReadingFromURL: filePath error:nil];
    NSData *fileData = [fileHandle readDataToEndOfFile];
    NSString *fileDataB64 = [fileData base64EncodedStringWithOptions:0];
    
    return fileDataB64;
}

+ (NSURL*)applicationDataDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* appSupportDir = nil;
    NSURL* appDirectory = nil;
    
    if ([possibleURLs count] >= 1) {
        // Use the first directory (if multiple are returned)
        appSupportDir = [possibleURLs objectAtIndex:0];
    }
    
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    if (appSupportDir) {
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    return appDirectory;
}

+(void) setFileB64:(NSString*)valueB64 fileName: (NSString*) fileName{
    //content
    NSString *content = valueB64;
    NSData *data = [[NSData alloc]
                    initWithBase64EncodedString:content options:0];
    
    //get path for a temp dir & the file
    NSURL* appDir = [Clipboard applicationDataDirectory];
    NSURL* fileURL = [appDir URLByAppendingPathComponent:fileName];
    
    //clear app dir and recreate it
    [[NSFileManager defaultManager] removeItemAtURL:appDir error:nil];
    [Clipboard createDir:appDir.path];
    
    
    NSLog(@"%@", fileURL);
    
    //write file to temp dir
    [[NSFileManager defaultManager] createFileAtPath:fileURL.path contents:data attributes:nil];

    
    //write file to the pasteboard
    NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    [myPasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
    [myPasteboard clearContents];
    
    NSArray *objectsToCopy = [[NSArray alloc] initWithObjects:fileURL, nil];
    [myPasteboard writeObjects:objectsToCopy];
    [myPasteboard setString:fileName forType:NSPasteboardTypeString];

}

+(void) createDir:(NSString*)directory{
    BOOL isDir = true;
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:directory isDirectory:&isDir])
        if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Error: Create folder failed %@", directory);
}

@end
