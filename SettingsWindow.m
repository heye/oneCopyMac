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

@end

@implementation SettingsWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    //_viewController = [[SettingsViewController alloc] init];
    //[self setContentViewController: _viewController];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    // Do view setup here.
    NSString *loadedKey = [ConfigStore loadKeyOne];
    [_keyOneInput setStringValue:loadedKey];
    
    NSString *loadedServer = [ConfigStore loadServerAddr];
    [_serverInput setStringValue:loadedServer];
    
    
    //NSLog(@"scale: %f", [[self window] backingScaleFactor]);
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)buttonAction:(id)sender {
    NSLog(@"buttonAction");
    
    [ConfigStore storeKeyOne:_keyOneInput.stringValue];
    [ConfigStore storeServerAddr:_serverInput.stringValue];
    [ConfigStore storeEncKeyOne:_encKeyInput.stringValue];
    
    [self.window close];
}



@end
