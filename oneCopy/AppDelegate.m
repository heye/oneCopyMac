//
//  AppDelegate.m
//  oneCopy
//
//  Created by Heye Everts on 27/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsWindow.h"
#import "Notifications.h"
#import "Clipboard.h"
#import "ServerRequest.h"
#import "ConfigStore.h"
#import "Crypto.h"

@interface AppDelegate ()
@property (strong) NSStatusItem *statusItem;

@property (strong) NSMenu* menu;

@property (strong) NSImage* iconImageDefault;
@property (strong) NSImage* iconImageIdle;
@property (strong) NSImage* iconImageUp;
@property (strong) NSImage* iconImageUpDown;
@property (strong) NSImage* iconImageDown;
@property (strong) NSImage* iconImageErr;
@property (strong) SettingsWindow* settingsWindow;

@property (strong) NSMenuItem* pushMenuItemOne;

@end

@implementation AppDelegate


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [Crypto test];
    
    
    //set self as notification center delegate
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    //init setting window
    _settingsWindow = [[SettingsWindow alloc] initWithWindowNibName:@"SettingsWindow"];
    
    //init tray icon
    _iconImageDefault =[NSImage imageNamed:@"tray_icon"];
    _iconImageDefault.size = NSMakeSize(18.0, 18.0);
    [_iconImageDefault setTemplate:YES];
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    _statusItem.image = _iconImageDefault;
    
    
    //init tray menu
    _menu = [NSMenu alloc];
    
    _pushMenuItemOne = [[NSMenuItem alloc] initWithTitle:@"push clipboard" action:@selector(pushAction:) keyEquivalent:@""];
    //[_pushMenuItemOne setImage:_iconImageDefault];
    //[_pushMenuItemOne setOnStateImage:_iconImageDefault];
    //[_pushMenuItemOne setOffStateImage:_iconImageDefault];
    
    [_menu addItem:_pushMenuItemOne];
    [_menu addItemWithTitle:@"pull clipboard" action:@selector(pullAction:) keyEquivalent:@""];
    [_menu addItem:[NSMenuItem separatorItem]];
    [_menu addItemWithTitle:@"settings" action:@selector(settingsAction:) keyEquivalent:@""];
    [_menu addItemWithTitle:@"quit" action:@selector(quitAction:) keyEquivalent:@""];
    _statusItem.menu = _menu;
    
    
    //NSLog(@"%@", [Clipboard getStringB64]);
    //[Clipboard getFileB64];
    //[Clipboard setFileB64:@"dGVzdGZk"fileName:@"testfile.txt"];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    // nothing todo
}


- (IBAction)pullAction:(id)sender {
    NSString* apiKey = [ConfigStore loadKeyOne];
    NSString* serverAddr = [ConfigStore loadServerAddr];
    
    ServerRequest *sReq = [ServerRequest alloc];
    [sReq pullKey:apiKey fromServer:serverAddr];
}

- (IBAction)pushAction:(id)sender {
    
    NSString* apiKey = [ConfigStore loadKeyOne];
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

- (IBAction)settingsAction:(id)sender {
    
    [_settingsWindow showWindow:self];
    
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)quitAction:(id)sender {
    [NSApp terminate:self];
}


@end
