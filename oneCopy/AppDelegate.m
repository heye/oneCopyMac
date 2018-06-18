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
#import "Menu.h"

@interface AppDelegate ()
@property (strong) NSStatusItem *statusItem;

@property (strong) NSImage* iconImageDefault;
@property (strong) NSImage* iconImageIdle;
@property (strong) NSImage* iconImageUp;
@property (strong) NSImage* iconImageUpDown;
@property (strong) NSImage* iconImageDown;
@property (strong) NSImage* iconImageErr;
@property (strong) Menu* menu;

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
        
    //icon
    _iconImageDefault =[NSImage imageNamed:@"tray_icon"];
    _iconImageDefault.size = NSMakeSize(18.0, 18.0);
    [_iconImageDefault setTemplate:YES];
    
    //status icon
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    _statusItem.image = _iconImageDefault;
    
    _menu = [[Menu alloc] init];

    _statusItem.menu = [_menu getMenu];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    // nothing todo
}


- (IBAction)pullAction:(id)sender {
}

- (IBAction)pushAction:(id)sender {
}

- (IBAction)settingsAction:(id)sender {
}

- (IBAction)quitAction:(id)sender {
}


@end
