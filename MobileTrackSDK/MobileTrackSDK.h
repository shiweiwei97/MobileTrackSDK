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
#define MobileTrackAPIServer @"http://mobiletrack.herokuapp.com/api/collector"
#define SesssionFilePrefix @"session-"
#define DefaultEventKey @"DefaultEventKey"

/**
 *  SDK main class
 *  <h2>Integration guide</h2>
    <h3>Config AppDelegate.m</h3>
    <code><pre>
 // AppDelegate.m
 #import "MobileTrackSDK/MobileTrackSDK.h"
 
 #define APP_KEY @"5555dcee67e58e9646000a25"
 
 @implementation AppDelegate
 
 - (void)mobileTrack {
   [MobileTrackSDK setAppVersion:XcodeAppVersion];
   [MobileTrackSDK startWithAppkey:APP_KEY];
 }
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [self mobileTrack];
   return YES;
 }
 </pre></code>
 
 <h3>Log page views</h3>
 <code><pre>
 // ViewController.m
 #import "MobileTrackSDK/MobileTrackSDK.h"
 
 - (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   [MobileTrackSDK beginLogPageView:@"detailPage"];
 }
 
 - (void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated]
   [MobileTrackSDK endLogPageView:@"detailPage"];
 }
 </pre></code>
 
 <h3>Log events</h3>
 <code><pre>
 - (IBAction)startEvent:(id)sender {
   [MobileTrackSDK beginEvent:@"testEvent"];
 }
 
 - (IBAction)endEvent:(id)sender {
   [MobileTrackSDK endEvent:@"testEvent"];
 }
 </pre></code>
 */
@interface MobileTrackSDK : NSObject

#pragma mark basics

/**
*  set application version
*
*  @param appVersion appVersion application version
*/
+ (void)setAppVersion:(NSString *)appVersion;

/**
 *  start session tracking
 *
 *  @param appKey appKey application key
 */
+ (void)startWithAppkey:(NSString *)appKey;

/**
 *  log page view
 *
 *  @param pageName pageName page name
 *  @param seconds  seconds page view duration in seconds
 */
+ (void)logPageView:(NSString *)pageName seconds:(int)seconds;

/**
 *  begin log page view
 *
 *  @param pageName pageName page name
 */
+ (void)beginLogPageView:(NSString *)pageName;

/**
 *  end log page view
 *
 *  @param pageName pageName page name
 */
+ (void)endLogPageView:(NSString *)pageName;

#pragma mark event logs

/**
 *  log event with event ID
 *
 *  @param eventId eventId event ID
 */
+ (void)event:(NSString *)eventId;

/**
 *  log event with event ID and label
 *
 *  @param eventId eventId event ID
 *  @param label   label label
 */
+ (void)event:(NSString *)eventId label:(NSString *)label;

/**
 *  log event with event ID and attributes
 *
 *  @param eventId    eventId event ID
 *  @param attributes attributes dictionary of attributes
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

/**
 *  log event
 *
 *  @param eventId    eventID event ID
 *  @param attributes attributes dictionary of attributes
 *  @param number     counter counter of event
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number;

/**
 *  begin log event with event ID
 *
 *  @param eventId eventId event ID
 */
+ (void)beginEvent:(NSString *)eventId;

/**
 *  end log event with event ID
 *
 *  @param eventId eventId event ID
 */
+ (void)endEvent:(NSString *)eventId;

/**
 *  begin log event with event ID and label
 *
 *  @param eventId eventId event ID
 *  @param label   label label
 */
+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;

/**
 *  end log event with event ID and label
 *
 *  @param eventId eventId event ID
 *  @param label   label label
 */
+ (void)endEvent:(NSString *)eventId label:(NSString *)label;

/**
 *  begin log event with event ID, key and attributes
 *
 *  @param eventId    eventId event ID
 *  @param keyName    keyName primary key name
 *  @param attributes attributes dictionary of attributes
 */
+ (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes;

/**
 *  end log event with event ID and key
 *
 *  @param eventId eventId event ID
 *  @param keyName keyName primary key name
 */
+ (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName;

/**
 *  log event with event ID and duration
 *
 *  @param eventId     eventId event ID
 *  @param millisecond millisecond event duration in milliseconds
 */
+ (void)event:(NSString *)eventId durations:(int)millisecond;

/**
 *  log event with event ID, label and duration
 *
 *  @param eventId     eventId event ID
 *  @param label       label label
 *  @param millisecond millisecond event duration in milliseconds
 */
+ (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond;

/**
 *  log event with event ID, attributes and duration
 *
 *  @param eventId     eventId event ID
 *  @param attributes  attributes dictionary of attributes
 *  @param millisecond millisecond event duration in milliseconds
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond;

@end
