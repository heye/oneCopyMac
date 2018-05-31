//
//  SettingsWindow.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "SettingsWindow.h"
#import "SettingsViewController.h"

@interface SettingsWindow ()

@property (strong) SettingsViewController* viewController;

@end

@implementation SettingsWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    //_viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    _viewController = [[SettingsViewController alloc] init];
    
    [self setContentViewController: _viewController];
    
    
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
