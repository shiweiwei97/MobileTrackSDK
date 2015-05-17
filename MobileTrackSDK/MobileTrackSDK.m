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
