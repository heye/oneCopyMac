//
//  Menu.m
//  oneCopy
//
//  Created by Heye Everts on 12/06/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "Menu.h"
#import "AppLogic.h"
#import "ConfigStore.h"
#import "AppLogic.h"

@interface Menu ()

@property (strong) NSMenu* menu;
@property (strong) NSImage* iconImageDefault;
@property (strong) NSMenuItem* pushMenuItem;
@property (strong) NSMenuItem* pullMainItem;
@property (strong) NSMenuItem* settingsMenuItem;
@property (strong) NSMenuItem* quitMenuItem;

@property (strong) NSMutableArray* changingMenuItems;



@property (strong) NSMenuItem* subItem;
@property (strong) NSMenu* subMenu;
@property (strong) NSMenuItem* subPush;
@property (strong) NSMenuItem* subPull;
@property (strong) NSMenuItem* uploadingInfo;

@end



@implementation Menu


-(Menu*) init{
    self = [super init];
    
    //init tray icon
    
    
    //init tray menu
    _menu = [NSMenu alloc];
    _changingMenuItems = [[NSMutableArray alloc] init];
    
    //TODO: enable list of last pushed files
    /*NSMenuItem *pullItem = [[NSMenuItem alloc] initWithTitle:@"pull xyz" action:@selector(buttonAction:) keyEquivalent:@""];
    [pullItem setTarget:self];

    [_changingMenuItems addObject:pullItem];*/
    
    
    _uploadingInfo = [[NSMenuItem alloc] initWithTitle:@"uploading..." action:@selector(buttonAction:) keyEquivalent:@""];
    [_uploadingInfo setEnabled:false];
    [_uploadingInfo setHidden:true];
    
    _pushMenuItem = [[NSMenuItem alloc] initWithTitle:@"#main push" action:@selector(buttonAction:) keyEquivalent:@""];
    
    _pullMainItem = [[NSMenuItem alloc] initWithTitle:@"#main pull" action:@selector(buttonAction:) keyEquivalent:@""];
    
    _settingsMenuItem = [[NSMenuItem alloc] initWithTitle:@"settings" action:@selector(buttonAction:) keyEquivalent:@""];
    _quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"quit" action:@selector(buttonAction:) keyEquivalent:@""];
    
    _subMenu = [[NSMenu alloc] init];
    _subItem = [[NSMenuItem alloc] initWithTitle:@"#shared" action:NULL keyEquivalent:@""];
    [_subItem setSubmenu:_subMenu];
    _subPull = [[NSMenuItem alloc] initWithTitle:@"pull" action:@selector(buttonAction:) keyEquivalent:@""];
    _subPush = [[NSMenuItem alloc] initWithTitle:@"push" action:@selector(buttonAction:) keyEquivalent:@""];
    
    [_subMenu addItem:_subPush];
    [_subMenu addItem:_subPull];
    
    //[_pushMenuItemOne setImage:_iconImageDefault];
    //[_pushMenuItemOne setOnStateImage:_iconImageDefault];
    //[_pushMenuItemOne setOffStateImage:_iconImageDefault];
    
    [_pushMenuItem setTarget:self];
    [_pullMainItem setTarget:self];
    [_settingsMenuItem setTarget:self];
    [_quitMenuItem setTarget:self];
    
    
    
    [_menu addItem:_uploadingInfo];
    [_menu addItem:_pushMenuItem];
    [_menu addItem:_pullMainItem];
    [_menu addItem:_subItem];
    [_menu addItem:[NSMenuItem separatorItem]];
    //TODO: enable list of last pushed files
    /*[_menu addItem: pullItem];
    [_menu addItem:[NSMenuItem separatorItem]];*/
    [_menu addItem:_settingsMenuItem];
    [_menu addItem:_quitMenuItem];
    
    
    return self;
}

-(NSMenu*) getMenu {
    return _menu;
}

- (void) setUploading{
    NSLog(@"setUploading");
    [_uploadingInfo setHidden:false];
}
- (void) unsetUploading{
    NSLog(@"unsetUploading");
    [_uploadingInfo setHidden:true];
}


- (IBAction)buttonAction:(id)sender{
    
    if(sender == _pushMenuItem){
        NSLog(@"push main");
        [AppLogic pushKey:[ConfigStore loadKeyOne]];
        return;
    }
    if(sender == _settingsMenuItem){
        NSLog(@"settings");
        [AppLogic showSettings];
        return;
    }
    if(sender == _quitMenuItem){
        NSLog(@"quit");
        [AppLogic quitApp];
        return;
    }
    if(sender == _pullMainItem){
        NSLog(@"pull main");
        [AppLogic pullKey:[ConfigStore loadKeyOne]];
        return;
    }
    
    //TODO: enable list of last pushed files
    for (int i = 0; i < [_changingMenuItems count]; i++) {
        /*NSMenuItem* menuItem = [_changingMenuItems objectAtIndex: i];
        
        if(sender == menuItem){
            [AppLogic pullKey:[ConfigStore loadKeyOne]];
        }*/
    }
}

@end
