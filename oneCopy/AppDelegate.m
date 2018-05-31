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

@end

@implementation AppDelegate


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
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
    [_menu addItemWithTitle:@"push" action:@selector(pushAction:) keyEquivalent:@""];
    [_menu addItemWithTitle:@"pull" action:@selector(pullAction:) keyEquivalent:@""];
    [_menu addItem:[NSMenuItem separatorItem]];
    [_menu addItemWithTitle:@"settings" action:@selector(settingsAction:) keyEquivalent:@""];
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
    
    ServerRequest *sReq = [ServerRequest alloc];
    [sReq pushKey:apiKey andValue:clipboadValueB64 toServer:serverAddr];
}

- (IBAction)settingsAction:(id)sender {
    
    [_settingsWindow showWindow:self];
    
    [NSApp activateIgnoringOtherApps:YES];
}


@end
