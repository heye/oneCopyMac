//
//  SettingsViewController.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "SettingsViewController.h"
#import "ConfigStore.h"

@interface SettingsViewController ()
@property (nonatomic, retain) IBOutlet NSTextField* myTextField;
@end

@implementation SettingsViewController
@synthesize myTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do view setup here.
    NSString *loadedKey = [ConfigStore loadKeyOne];
    [myTextField setStringValue:loadedKey];
    
    NSLog(@"did load view controller");
}

- (IBAction)buttonAction:(id)sender {
    NSLog(@"buttonAction");
    
    [ConfigStore storeKeyOne:myTextField.stringValue];
}

- (IBAction)test:(id)sender {
}
@end
