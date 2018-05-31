//
//  ServerRequest.h
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRequest : NSObject <NSURLSessionDelegate>

-(void) makeRequestWithJSON:(NSString*)json toServer: (NSString*) server;
-(void) pullKey:(NSString*)key fromServer: (NSString*) server;
-(void) pushKey:(NSString*)key andValue: (NSString*) value toServer: (NSString*) server;

//called after finishing a pull type request
-(void) handlePullReply;
-(void) handlePushReply;

@property (strong) NSDictionary* replyDoc;

@property BOOL localError;
@property BOOL serverError;

@property BOOL isPull;
@property BOOL isPush;
@property BOOL isStarted;

@end
