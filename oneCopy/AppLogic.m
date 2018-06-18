//
//  AppLogic.m
//  oneCopy
//
//  Created by Heye Everts on 12/06/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "AppLogic.h"
#import "Clipboard.h"
#import "Crypto.h"
#import "ConfigStore.h"
#import "ServerRequest.h"
#import "SettingsWindow.h"
#import <Cocoa/Cocoa.h>


@interface AppLogic ()
@end

@implementation AppLogic

+(void) pushKey: (NSString*) apiKey {
    NSString* clipboadValueB64 = [Clipboard getStringB64];
    NSString* serverAddr = [ConfigStore loadServerAddr];
    
    
    //test if we have to encrypt
    NSString *encKey = [ConfigStore loadEncKeyOne];
    if([encKey length] > 0){
        NSLog(@"used encryption for text");
        clipboadValueB64 = [Crypto encryptString:clipboadValueB64 andKey:encKey];
    }
    
    if([Clipboard isFile]){
        ServerRequest *sReq = [ServerRequest alloc];
        [sReq noNotify]; //no notification for setting the file name
        [sReq pushKey:apiKey andValue:clipboadValueB64 toServer:serverAddr];
        
        ServerRequest *fileRequest = [ServerRequest alloc];
        NSString* clipboadValue = [Clipboard getString];
        NSData *fileData = [Clipboard getFile];
        [fileRequest pushFileData:fileData toServer:serverAddr withKey:apiKey andName:clipboadValue];
    }
    else{
        ServerRequest *sReq = [ServerRequest alloc];
        [sReq pushKey:apiKey andValue:clipboadValueB64 toServer:serverAddr];
    }

}

+(void) pullKey: (NSString*) apiKey {
    NSString* serverAddr = [ConfigStore loadServerAddr];
    
    ServerRequest *sReq = [ServerRequest alloc];
    [sReq pullKey:apiKey fromServer:serverAddr];
}

+(void) showSettings {
    static SettingsWindow* settingsWindow;


    if(!settingsWindow){
        settingsWindow = [[SettingsWindow alloc] initWithWindowNibName:@"SettingsWindow"];
    }
    
    [settingsWindow showWindow:self];
    
    [NSApp activateIgnoringOtherApps:YES];
}

+(void) quitApp {
    [NSApp terminate:self];
}


@end
