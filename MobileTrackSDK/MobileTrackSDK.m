//
//  MobileTrackSDK.m
//  MobileTrackSDK
//
//  Created by 张蓓 on 15/5/17.
//  Copyright (c) 2015年 mobiletrack. All rights reserved.
//

#import "MobileTrackSDK.h"
#import "SessionManager.h"
#import <UIKit/UIKit.h>

@implementation MobileTrackSDK

+ (void)handleEnteredBackground:(NSNotification *) notification {
    NSLog(@"handleEnteredBackground called");
    
    SessionManager *sessionManager = [SessionManager sharedManager];
    sessionManager.endTime = [NSDate date];
    
    [sessionManager save];
    [self tryAsyncUpload];
}

+ (void)handleEnteredForegroud:(NSNotification *) notification {
    NSLog(@"handleEnteredForegroud called");
    SessionManager *sessionManager = [SessionManager sharedManager];
    [sessionManager restartSession];
    [self tryAsyncUpload];
}

#pragma mark basics

+ (void)setAppVersion:(NSString *)appVersion {
    SessionManager *sessionManager = [SessionManager sharedManager];
    sessionManager.appVersion = appVersion;
}

+ (void)startWithAppkey:(NSString *)appKey {
    SessionManager *sessionManager = [SessionManager sharedManager];
    sessionManager.appKey = appKey;
    
    // detect app entering backgroud
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground:)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];

    // detect app entering foreground
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredForegroud:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object: nil];
    
    // try upload previous session data
    [self tryAsyncUpload];
}

+ (void)tryAsyncUpload {
    // try upload previous session data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // start upload
        [self uploadSessionData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"upload complete");
        });
    });
}

+ (void)uploadSessionData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory
                                                                                  error:nil];
    
    for (NSString *path in filePathsArray) {
        
        if (![path hasPrefix:SesssionFilePrefix]) continue;
        
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
        
        // read file content
        NSString* content = [NSString stringWithContentsOfFile:fullPath
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        // NSLog(@"file content: %@", content);
        
        // call data collector
        NSURL *url = [NSURL URLWithString:[MobileTrackAPIServer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *bodyStr = [NSString stringWithFormat:@"%@", content];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *bodyData = [NSData dataWithBytes:[bodyStr UTF8String]
                                     length:[bodyStr length]];
        [request setHTTPBody:bodyData];
        
        NSURLResponse* response;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        NSString *responseString = [[NSString alloc] initWithData:responseData
                                                         encoding:NSUTF8StringEncoding];
        
        NSLog(@"response: %@", responseString);
        
        // remove file
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:fullPath
                                                                  error:&error];
        if (removed) {
            NSLog(@"file %@ removed successfully", fullPath);
        }
    }
}

+ (void)logPageView:(NSString *)pageName seconds:(int)seconds {
    
}

+ (void)beginLogPageView:(NSString *)pageName {
    
}

+ (void)endLogPageView:(NSString *)pageName {
    
}

#pragma mark event logs

+ (void)event:(NSString *)eventId {
    
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number {
    
}

+ (void)beginEvent:(NSString *)eventId {
    
}

+ (void)endEvent:(NSString *)eventId {
    
}

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label {
    
}

+ (void)endEvent:(NSString *)eventId label:(NSString *)label {
    
}

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes {
    
}

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName {
    
}

+ (void)event:(NSString *)eventId durations:(int)millisecond {
    
}

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond {
    
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond {
    
}

@end
