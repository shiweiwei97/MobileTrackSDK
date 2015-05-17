//
//  MobileTrackSDK.h
//  MobileTrackSDK
//
//  Created by 张蓓 on 15/5/17.
//  Copyright (c) 2015年 mobiletrack. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define MobileTrackSDKVersion @"1.0.0"

@interface MobileTrackSDK : NSObject

#pragma mark basics

+ (void)setAppVersion:(NSString *)appVersion;

+ (void)startWithAppkey:(NSString *)appKey;

+ (void)logPageView:(NSString *)pageName seconds:(int)seconds;

+ (void)beginLogPageView:(NSString *)pageName;

+ (void)endLogPageView:(NSString *)pageName;

#pragma mark event logs

+ (void)event:(NSString *)eventId;

+ (void)event:(NSString *)eventId label:(NSString *)label;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number;

+ (void)beginEvent:(NSString *)eventId;

+ (void)endEvent:(NSString *)eventId;

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;

+ (void)endEvent:(NSString *)eventId label:(NSString *)label;

+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes;

+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName;

+ (void)event:(NSString *)eventId durations:(int)millisecond;

+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond;

@end
