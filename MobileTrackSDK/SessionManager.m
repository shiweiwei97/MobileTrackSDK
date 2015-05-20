//
//  SessionManager.m
//  MobileTrackSDK
//
//  Created by 张蓓 on 15/5/17.
//  Copyright (c) 2015年 mobiletrack. All rights reserved.
//

#import "SessionManager.h"
#import <UIKit/UIKit.h>
#import "MobileTrackSDK.h"

@implementation SessionManager

@synthesize sessionId;
@synthesize appKey;
@synthesize deviceId;
@synthesize deviceName;
@synthesize appVersion;
@synthesize deviceModel;
@synthesize OSVersion;
@synthesize SDKVersion;
@synthesize startTime;
@synthesize endTime;
@synthesize pageViews;
@synthesize events;

#pragma mark Singleton Methods

static SessionManager *sharedSessionManager = nil;

+ (id)sharedManager {
    @synchronized(self) {
        if (sharedSessionManager == nil)
            sharedSessionManager = [[self alloc] init];
    }
    return sharedSessionManager;
}

- (id)init {
    if (self = [super init]) {
        sessionId = [[NSUUID UUID] UUIDString];
        // appKey
        deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        deviceName = [[UIDevice currentDevice] name];
        // appVersion
        deviceModel = [[UIDevice currentDevice] model];
        OSVersion = [NSString stringWithFormat:@"%f", [[[UIDevice currentDevice] systemVersion] floatValue]];
        SDKVersion = MobileTrackSDKVersion;
        startTime = [NSDate date];
        // endTime
        pageViews = [NSMutableArray array];
        events = [NSMutableArray array];
    }
    return self;
}

- (void) restartSession {
    @synchronized(self) {
        if (sharedSessionManager != nil) {
            sessionId = [[NSUUID UUID] UUIDString];
            startTime = [NSDate date];
            pageViews = [NSMutableArray array];
            events = [NSMutableArray array];
        }
    }
}

#pragma mark JSON Methods

- (NSDictionary *)toJSONObj {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sessionId, @"sessionId",
                          appKey, @"appKey",
                          deviceId, @"deviceId",
                          deviceName, @"deviceName",
                          appVersion, @"appVersion",
                          deviceModel, @"deviceModel",
                          OSVersion, @"OSVersion",
                          SDKVersion, @"SDKVersion",
                          [NSNumber numberWithLong:[startTime timeIntervalSince1970] * 1000], @"startTime",
                          [NSNumber numberWithLong:[endTime timeIntervalSince1970] * 1000], @"endTime",
                          pageViews, @"pageViews",
                          events, @"events",
                          nil];
    return dict;
}

- (void)save {
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:[self toJSONObj]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (json != nil && error == nil) {
        NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonString);

        // save file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName = [NSString stringWithFormat:@"%@/%@%@.json", documentsDirectory, SesssionFilePrefix, [self sessionId]];
        [jsonString writeToFile:fileName
                     atomically:YES
                       encoding:NSStringEncodingConversionAllowLossy
                          error:&error];
    }
}

@end
