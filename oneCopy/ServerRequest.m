//
//  ServerRequest.m
//  oneCopy
//
//  Created by Heye Everts on 31/05/2018.
//  Copyright © 2018 Heye Everts. All rights reserved.
//

#import "ServerRequest.h"
#import "Notifications.h"
#import "Clipboard.h"

@implementation ServerRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _localError = false;
        _serverError = false;
        _isPull = false;
        _isPush = false;
        _replyDoc = [NSDictionary alloc];
        _isStarted = false;
    }
    return self;
}

-(void) makeRequestWithJSON:(NSString*)json toServer: (NSString*) server{
    NSLog(@"request:%@", json);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:server]];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //Apply the data to the body
    [urlRequest setHTTPBody:jsonData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}



- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    //NSLog(@"didCompleteWithError");

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)[task response];
    if(httpResponse.statusCode != 200) {
        _serverError = true;
        NSLog(@"status != 200");
    }
    
    if(_serverError){
        //TODO: notification
        [Notifications make:@"cannot reach the server"];
        return;
    }
    
    if(_localError){
        [Notifications make:@"cannot reach the server"];
        //TODO: notification
        return;
    }
    
    NSLog(@"Server reply: %@", _replyDoc);
    
    NSString *apiErr = _replyDoc[@"err"];
    if(apiErr){
        [Notifications make:apiErr];
        return;
    }
    
    if (_isPull) {
        [self handlePullReply];
        return;
    }
    
    if (_isPush){
        [self handlePushReply];
        return;
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{

    //NSLog(@"didReceiveData");
    
    NSError *parseError = nil;
    _replyDoc =[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    
    if(parseError){
        
    }
}


-(void) handlePullReply{
    NSLog(@"handlePullReply");
    
    NSString *clipboardValue = _replyDoc[@"value"];
    if(!clipboardValue)
        return;
    
    
    NSLog(@"pull clipboard value: %@",clipboardValue);
    
    [Clipboard setString:clipboardValue];
    [Notifications make:@"pull success"];
}

-(void) handlePushReply{
    NSLog(@"handlePushReply");

    [Notifications make:@"push success"];
}


-(void) pullKey:(NSString*)key fromServer: (NSString*) server{
    if(_isStarted)
        return;
    _isStarted = true;
    
    //build json request
    NSString *postJson =[NSString stringWithFormat:@"{\"type\":\"get_key\",\"key\":\"%@\"}",key];
    
    _isPull = true;
    
    //start request
    [self makeRequestWithJSON:postJson toServer:server];
}

-(void) pushKey:(NSString*)key andValue: (NSString*) value toServer: (NSString*) server{
    if(_isStarted)
        return;
    _isStarted = true;
    
    //build json request
    NSString *postJson =[NSString stringWithFormat:@"{\"type\":\"set_key\",\"key\":\"%@\",\"value\":\"%@\"}",key,value];
    
    _isPush = true;
    
    //start request
    [self makeRequestWithJSON:postJson toServer:server];
}


@end

