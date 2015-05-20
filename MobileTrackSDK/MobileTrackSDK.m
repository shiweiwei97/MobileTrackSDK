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

@interface MobileTrackSDK()

+ (void)beginEvent:(NSString *)eventId
             label:(NSString *)label
        primarykey:(NSString *)keyName
        attributes:(NSDictionary *)attributes;

+ (void)endEvent:(NSString *)eventId
           label:(NSString *)label
      primarykey:(NSString *)keyName;

@end

@implementation MobileTrackSDK

#pragma mark notification handlers

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

#pragma mark page view

+ (void)logPageView:(NSString *)pageName seconds:(int)seconds {
    SessionManager *sessionManager = [SessionManager sharedManager];
    [sessionManager.pageViews addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         pageName, @"pageName",
                                         [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000 - seconds * 1000], @"startTime",
                                         [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000], @"endTime",
                                         nil]];
}

+ (void)beginLogPageView:(NSString *)pageName {
    SessionManager *sessionManager = [SessionManager sharedManager];
    [sessionManager.pageViews addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         pageName, @"pageName",
                                         [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000], @"startTime",
                                         nil]];
}

+ (void)endLogPageView:(NSString *)pageName {
    SessionManager *sessionManager = [SessionManager sharedManager];
    for (NSMutableDictionary *pageView in sessionManager.pageViews) {
        NSString *name = [pageView objectForKey:@"pageName"];
        if ([name isEqualToString:pageName]) {
            [pageView setValue:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000]
                        forKey:@"endTime"];
        }
    }
}

#pragma mark event logs

+ (void)event:(NSString *)eventId
        label:(NSString *)label
   attributes:(NSDictionary *)attributes
    durations:(int)millisecond
      counter:(int)number {
    
    SessionManager *sessionManager = [SessionManager sharedManager];
    [sessionManager.events addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      eventId, @"eventId",
                                      label, @"label",
                                      attributes, @"attributes",
                                      [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000 - millisecond], @"startTime",
                                      [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000], @"endTime",
                                      [NSNumber numberWithInt:number], @"count",
                                      DefaultEventKey, @"keyName",
                                      nil]];
}

+ (void)event:(NSString *)eventId {
    [self event:eventId label:eventId attributes:[NSDictionary dictionary] durations:0 counter:1];
}

+ (void)event:(NSString *)eventId label:(NSString *)label {
    [self event:eventId label:label attributes:[NSDictionary dictionary] durations:0 counter:1];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    [self event:eventId label:eventId attributes:attributes durations:0 counter:1];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number {
    [self event:eventId label:eventId attributes:attributes durations:0 counter:number];
}

+ (void)event:(NSString *)eventId durations:(int)millisecond {
    [self event:eventId label:eventId durations:millisecond];
}

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond {
    [self event:eventId label:label attributes:[NSDictionary dictionary] durations:millisecond];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond {
    [self event:eventId label:eventId attributes:attributes durations:millisecond];
}

+ (void)event:(NSString *)eventId label:(NSString *)label attributes:(NSDictionary *)attributes durations:(int)millisecond {
    [self event:eventId label:label attributes:attributes durations:millisecond counter:1];
}

#pragma mark begin/end event logs

+ (void)beginEvent:(NSString *)eventId
             label:(NSString *)label
        primarykey:(NSString *)keyName
        attributes:(NSDictionary *)attributes {
    
    SessionManager *sessionManager = [SessionManager sharedManager];
    [sessionManager.events addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      eventId, @"eventId",
                                      label, @"label",
                                      attributes, @"attributes",
                                      [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000], @"startTime",
                                      [NSNumber numberWithInt:1], @"count",
                                      keyName, @"keyName",
                                      nil]];
}

+ (void)endEvent:(NSString *)eventId
           label:(NSString *)label
      primarykey:(NSString *)keyName {
    
    SessionManager *sessionManager = [SessionManager sharedManager];
    for (NSMutableDictionary *evt in sessionManager.events) {
        // find the exact (eventId, label, keyName)
        if ([eventId isEqualToString:[evt valueForKey:@"eventId"]] &&
            [label isEqualToString:[evt valueForKey:@"label"]] &&
            [keyName isEqualToString:[evt valueForKey:@"keyName"]]) {
            [evt setValue:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970] * 1000]
                   forKey:@"endTime"];
        }
    }
}

+ (void)beginEvent:(NSString *)eventId {
    [self beginEvent:eventId label:eventId];
}

+ (void)endEvent:(NSString *)eventId {
    [self endEvent:eventId label:eventId];
}

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label {
    [self beginEvent:eventId label:label primarykey:DefaultEventKey attributes:[NSDictionary dictionary]];
}

+ (void)endEvent:(NSString *)eventId label:(NSString *)label {
    [self endEvent:eventId label:label primarykey:DefaultEventKey];
}

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes {
    [self beginEvent:eventId label:eventId primarykey:keyName attributes:attributes];
}

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName {
    [self endEvent:eventId label:eventId primarykey:keyName];
}

@end
