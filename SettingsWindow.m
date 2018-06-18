//
//  SettingsWindow.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "SettingsWindow.h"
#import "ConfigStore.h"

@interface SettingsWindow ()

@property (nonatomic, retain) IBOutlet NSTextField* keyOneInput;
@property (nonatomic, retain) IBOutlet NSTextField* serverInput;
@property (nonatomic, retain) IBOutlet NSTextField* encKeyInput;
@property (weak) IBOutlet NSTabView *tabButtons;

@property bool showingPrimary;
@property bool showingKey;

@end

@implementation SettingsWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    // Do view setup here.
    [self showPrimary];
    
    _showingKey = false;
    
    [_tabButtons setDelegate:self];
    
    //TODO: set label names?
    /*for (int i = 0; i < [[_tabButtons tabViewItems] count]; i++) {
        
        NSTabViewItem *oneItem = [[_tabButtons tabViewItems] objectAtIndex:i];
        
        [oneItem setLabel:@"label"];
    }*/
}

- (void) showPrimary{
    _showingPrimary = true;
    
    NSString *loadedKey = [ConfigStore loadKeyOne];
    [_keyOneInput setStringValue:loadedKey];
    
    NSString *loadedServer = [ConfigStore loadServerAddr];
    [_serverInput setStringValue:loadedServer];
    
    NSString *encKey = [ConfigStore loadEncKeyOne];
    if([encKey length] > 0){
        [_encKeyInput setStringValue:@"***"];
    }
}

- (void) showSecondary{
    _showingPrimary = false;
    
    NSString *loadedKey = [ConfigStore loadKeyTwo];
    [_keyOneInput setStringValue:loadedKey];
    
    NSString *loadedServer = [ConfigStore loadServerAddrTwo];
    [_serverInput setStringValue:loadedServer];
    
    NSString *encKey = [ConfigStore loadEncKeyTwo];
    if([encKey length] > 0){
        [_encKeyInput setStringValue:@"***"];
    }
}

- (void)tabView:(NSTabView *)tabView
didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
    
    NSLog(@"clicked:%@", [tabViewItem label]);
    
    
    if([[tabViewItem label] isEqualToString:@"Main Server"]){
        [self showPrimary];
    }
    
    if([[tabViewItem label] isEqualToString:@"Shared Server"]){
        [self showSecondary];
    }
    
}

- (IBAction)buttonAction:(id)sender {
    NSLog(@"buttonAction");
    
    if (_showingPrimary){
        [ConfigStore storeKeyOne:_keyOneInput.stringValue];
        [ConfigStore storeServerAddr:_serverInput.stringValue];
        [ConfigStore storeEncKeyOne:_encKeyInput.stringValue];
    }
    else{
        [ConfigStore storeKeyTwo:_keyOneInput.stringValue];
        [ConfigStore storeServerAddrTwo:_serverInput.stringValue];
        [ConfigStore storeEncKeyTwo:_encKeyInput.stringValue];
    }
    
    //[self.window close];
}

- (IBAction)buttonActionShow:(id)sender {
    NSLog(@"buttonActionShow");
    
    if(!_showingKey){
        NSString *encKey = [ConfigStore loadEncKeyOne];
        [_encKeyInput setStringValue:encKey];
    
        _showingKey = true;
    }
    else{
        [_encKeyInput setStringValue:@"***"];
        
        _showingKey = false;
    }
}


- (IBAction)firstTab:(id)sender {
    NSLog(@"firstTab");
}



@end
