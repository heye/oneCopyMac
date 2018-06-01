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
        _isFilePull = false;
        _isPush = false;
        _isFilePush = false;
        _replyDoc = [NSDictionary alloc];
        _isStarted = false;
        _fileName = @"";
        _serverAddr = @"";
        _apiKey = @"";
        _noNotify = false;
        _fileData = [[NSMutableData alloc] initWithLength:0];
    }
    return self;
}


-(void) makeRequestWithJSON:(NSString*)json toServer: (NSString*) server{
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    [self makeRequestWithDATA:jsonData toURL:server];
}


-(void) makeRequestWithDATA:(NSData*)data toURL: (NSString*) address{
    NSLog(@"request to:%@", address);
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:address]];
    
    //create the Method "GET" or "POST"
    if(_isFilePull){
        [urlRequest setHTTPMethod:@"GET"];
    }
    else {
        [urlRequest setHTTPMethod:@"POST"];
        //Apply the data to the body
        [urlRequest setHTTPBody:data];
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    NSLog(@"didCompleteWithError");

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
    
    if(!_isFilePull){
        NSLog(@"Server reply: %@", _replyDoc);
    
        NSString *apiErr = _replyDoc[@"err"];
        if(apiErr){
            [Notifications make:apiErr];
            return;
        }
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

    NSLog(@"didReceiveData");
    
    if(!_isFilePull){
        NSError *parseError = nil;
        _replyDoc =[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    }
    else{
        [_fileData appendData:data];
        NSLog(@"added file data new size: %lu", [_fileData length]);
    }
}


-(void) handlePullReply{
    NSLog(@"handlePullReply");
    
    //set clipboard value is this is not a file pull
    if(!_isFilePull){
        NSString *valueB64 = _replyDoc[@"value"];
        if(!valueB64)
            return;
        
        NSLog(@"pulled clipboard value: %@",valueB64);
        
        [Clipboard setStringB64:valueB64];
        
        //if this is a file name we also have to pull the file
        if([_replyDoc[@"is_file"] boolValue]){
            NSLog(@"this is a file - will pull the file");
            
            //get the file name we just wrote to the clipboard
            _fileName = [Clipboard getString];
            
            ServerRequest *sReq = [[ServerRequest alloc] init];
            [sReq pullFileWithKey:_apiKey andName:_fileName fromServer:_serverAddr];
 
        }
    }
    
    if(_isFilePull){
        NSLog(@"setting file with size %lu to clipboard", (unsigned long)[_fileData length]);
        
        //take file data and set clipboard
        //NSData *data = [NSData m]
        
        
        [Clipboard setFileData:_fileData  fileName:_fileName];
        
        NSString *notificationString =[NSString stringWithFormat:@"pulled file %@",_fileName];
        [Notifications make:notificationString];
    }
}

-(void) handlePushReply{
    NSLog(@"handlePushReply");

    //on file push - copy link to clipboard
    if(_isFilePush){
        //build file link
        NSString *fileLink =[NSString stringWithFormat:@"%@/file/%@/%@",_serverAddr,_apiKey,_fileName];
        
        //write file link to clipboard
        [Clipboard setString:fileLink];
        
        [Notifications make:@"file push success - copied link"];
    }
    else{
        if(!_noNotify){
            [Notifications make:@"push success"];
        }
    }
}

-(void) noNotification{
    _noNotify = true;
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


-(void) pullFileWithKey:(NSString*)key andName: (NSString*) name fromServer: (NSString*) server{
    //start pull
    _isPull = true;
    _isFilePull = true;
    _apiKey  = key;
    _serverAddr = server;
    _fileName = name;
    
    NSString *fileLink =[NSString stringWithFormat:@"%@/file/%@/%@",_serverAddr,_apiKey,_fileName];

    [self makeRequestWithDATA:nil toURL:fileLink];
}


-(void) pushFileData:(NSData*) data toServer: (NSString*)server withKey: (NSString*) apikey andName: (NSString*) fileName{

    if(_isStarted)
        return;
    _isStarted = true;
    
    //build json request
    NSString *urlWithKey =[NSString stringWithFormat:@"%@/file/%@",server,apikey];
    
    _isPush = true;
    _isFilePush = true;
    _fileName = fileName;
    _serverAddr = server;
    _apiKey = apikey;
    
    //start request
    [self makeRequestWithDATA:data toURL:urlWithKey];
}

@end

