//
//  Clipboard.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "Clipboard.h"
#import <AppKit/AppKit.h>

@implementation Clipboard

+(void) setString:(NSString*)text{
    NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    [myPasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
    [myPasteboard setString:text forType:NSPasteboardTypeString];
}

+(NSString*) getString{
    NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    return [myPasteboard  stringForType:NSPasteboardTypeString];
}

@end
