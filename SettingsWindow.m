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
    
    [NSApp activateIgnoringOtherApps:YES];
    
    // Do view setup here.
    NSString *loadedKey = [ConfigStore loadKeyOne];
    [_keyOneInput setStringValue:loadedKey];
    
    NSString *loadedServer = [ConfigStore loadServerAddr];
    [_serverInput setStringValue:loadedServer];
    
    NSString *encKey = [ConfigStore loadEncKeyOne];
    if([encKey length] > 0){
        [_encKeyInput setStringValue:@"***"];
    }
}

- (IBAction)buttonAction:(id)sender {
    NSLog(@"buttonAction");
    
    [ConfigStore storeKeyOne:_keyOneInput.stringValue];
    [ConfigStore storeServerAddr:_serverInput.stringValue];
    [ConfigStore storeEncKeyOne:_encKeyInput.stringValue];
    
    [self.window close];
}

- (IBAction)buttonActionShow:(id)sender {
    NSLog(@"buttonActionShow");
    
    NSString *encKey = [ConfigStore loadEncKeyOne];
    [_encKeyInput setStringValue:encKey];
}



@end
