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
        _isFilePush = false;
        _replyDoc = [NSDictionary alloc];
        _isStarted = false;
        _pushedFileName = @"";
        _serverAddr = @"";
        _apiKey = @"";
    }
    return self;
}


-(void) makeRequestWithJSON:(NSString*)json toServer: (NSString*) server{
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    [self makeRequestWithDATA:jsonData toURL:server];
    
    /*NSLog(@"request:%@", json);
    
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
    
    [dataTask resume];*/
}


-(void) makeRequestWithDATA:(NSData*)data toURL: (NSString*) address{
    NSLog(@"request to:%@", address);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:address]];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data];
    
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
    
    NSString *valueB64 = _replyDoc[@"value"];
    if(!valueB64)
        return;
    
    
    NSLog(@"pull clipboard value: %@",valueB64);
    
    [Clipboard setStringB64:valueB64];
    [Notifications make:@"pull success"];
}

-(void) handlePushReply{
    NSLog(@"handlePushReply");

    //on file push - copy link to clipboard
    if(_isFilePush){
        //build file link
        NSString *fileLink =[NSString stringWithFormat:@"%@/file/%@/%@",_serverAddr,_apiKey,_pushedFileName];
        
        //write file link to clipboard
        [Clipboard setString:fileLink];
        
        [Notifications make:@"file push success - copied link"];
    }
    else{
        [Notifications make:@"push success"];
    }
}


-(void) pullKey:(NSString*)key fromServer: (NSString*) server{
    if(_isStarted)
        return;
    _isStarted = true;
    
    //build json request
    NSString *postJson =[NSString stringWithFormat:@"{\"type\":\"get_key\",\"key\":\"%@\"}",key];
    
    _isPull = true;
    _serverAddr = server;
    _apiKey = key;
    
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
    _serverAddr = server;
    _apiKey = key;
    
    //start request
    [self makeRequestWithJSON:postJson toServer:server];
}


-(void) pushFileData:(NSData*) data toServer: (NSString*)server withKey: (NSString*) apikey andName: (NSString*) fileName{

    if(_isStarted)
        return;
    _isStarted = true;
    
    //build json request
    NSString *urlWithKey =[NSString stringWithFormat:@"%@/file/%@",server,apikey];
    
    _isPush = true;
    _isFilePush = true;
    _pushedFileName = fileName;
    _serverAddr = server;
    _apiKey = apikey;
    
    //start request
    [self makeRequestWithDATA:data toURL:urlWithKey];
}

@end

