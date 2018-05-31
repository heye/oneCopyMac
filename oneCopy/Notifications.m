//
//  Notifications.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "Notifications.h"

@implementation Notifications

+(void) make:(NSString*)text{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = text;
    notification.informativeText = text;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

}

@end
