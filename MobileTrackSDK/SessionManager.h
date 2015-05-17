//
//  SessionManager.h
//  MobileTrackSDK
//
//  Created by 张蓓 on 15/5/17.
//  Copyright (c) 2015年 mobiletrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject {
    NSString *sessionId;
    NSString *appKey;
    NSString *deviceId;
    NSString *deviceName;
    NSString *appVersion;
    NSString *deviceModel;
    NSString *OSVersion;
    NSString *SDKVersion;
    NSDate *startTime;
    NSDate *endTime;
}

@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *deviceName;
@property (nonatomic, retain) NSString *appVersion;
@property (nonatomic, retain) NSString *deviceModel;
@property (nonatomic, retain) NSString *OSVersion;
@property (nonatomic, retain) NSString *SDKVersion;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;

+ (id)sharedManager;

- (void) save;

@end
