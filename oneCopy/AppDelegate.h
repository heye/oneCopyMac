//
//  AppDelegate.h
//  oneCopy
//
//  Created by Heye Everts on 27/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Menu.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>

- (IBAction)pullAction:(id)sender;
- (IBAction)pushAction:(id)sender;
- (IBAction)settingsAction:(id)sender;
- (IBAction)quitAction:(id)sender;

- (Menu*) getMenu;

@end

