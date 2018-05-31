//
//  AppDelegate.m
//  oneCopy
//
//  Created by Heye Everts on 27/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsWindow.h"

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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //TODO: use this to store config
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //[userDefaults setValue:@"test" forKey:@"key"];
    //NSString *loadedKey = [userDefaults stringForKey:@"key"];
    //NSLog(@"%@", loadedKey);
    
    
    _settingsWindow = [[SettingsWindow alloc] initWithWindowNibName:@"SettingsWindow"];
    
    NSLog ( @"applicationDidFinishLaunching");
    NSLog(@"%@", [[NSBundle mainBundle] resourceURL]);
    
    _iconImageDefault =[NSImage imageNamed:@"tray_icon"];
    _iconImageDefault.size = NSMakeSize(18.0, 18.0);
    
    [_iconImageDefault setTemplate:YES];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    _statusItem.image = _iconImageDefault;
    
    
    
    _menu = [NSMenu alloc];
    
    //[_menu setAutoenablesItems:YES];
    
    //[_menu addItemWithTitle:@"open cloudplan folder" action:@selector(openFolderAction:) keyEquivalent:@""];
    
    [_menu addItemWithTitle:@"push" action:@selector(pushAction:) keyEquivalent:@""];
    [_menu addItemWithTitle:@"pull" action:@selector(pullAction:) keyEquivalent:@""];
    [_menu addItemWithTitle:@"settings" action:@selector(settingsAction:) keyEquivalent:@""];
    
    _statusItem.menu = _menu;

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)pullAction:(id)sender {
    //TODO
    NSLog(@"pullAction");
    

    
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://azenix.io"]];
    
    NSString *key = @"test-key";
    NSString *postJson =[NSString stringWithFormat:@"{\"type\":\"get_key\",\"key\":\"%@\"}",key];
    
    NSLog(@"request:%@", postJson);
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [postJson dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            
            NSString *clipboardValue = responseDictionary[@"value"];
            NSLog(@"pull clipboard value: %@",clipboardValue);
            NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
            [myPasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
            [myPasteboard setString:clipboardValue forType:NSPasteboardTypeString];
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
    
}

- (IBAction)pushAction:(id)sender {
    //TODO
    //NSLog(@"pushAction");
    
    NSPasteboard*  myPasteboard  = [NSPasteboard generalPasteboard];
    NSString* clipboardValue = [myPasteboard  stringForType:NSPasteboardTypeString];

    //NSLog(@"%@", myString);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://azenix.io"]];
    
    NSString *key = @"test-key";
    NSString *postJson =[NSString stringWithFormat:@"{\"type\":\"set_key\",\"key\":\"%@\",\"value\":\"%@\"}",key, clipboardValue];
    
    NSLog(@"request:%@", postJson);
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [postJson dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];

    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
        }
        else
        {
            NSLog(@"Error");     
        }
    }];
    [dataTask resume];
}



- (IBAction)settingsAction:(id)sender {
    NSLog(@"settingsAction");
    
    [_settingsWindow showWindow:self];

}


@end
