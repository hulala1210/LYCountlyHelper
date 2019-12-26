//
//  LYCountlyHelper.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/9.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "LYCountlyHelper.h"
#import "Countly.h"
#import "LYCountlyHooker.h"
#import "LYCountlyEventDistributor.h"

@interface LYCountlyHelper ()

@end


@implementation LYCountlyHelper

+ (void)startWithConfig:(LYCountlyCustomConfig *)config delegate:(nonnull id<LYCountlyEventDistributionProtocol>)delegate {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LYCountlyCustomConfig.currentConfig = config;

        CountlyConfig *countlyConfig = [[CountlyConfig alloc] init];
        countlyConfig.appKey = config.appKey;
        countlyConfig.host = config.host;

        countlyConfig.customHeaderFieldName = @"Content-Type";
        countlyConfig.customHeaderFieldValue = @"application/json";

        countlyConfig.updateSessionPeriod = config.updateSessionPeriod;
        countlyConfig.eventSendThreshold = config.eventSendThreshold;

        countlyConfig.storedRequestsLimit = config.storedRequestsLimit;

        countlyConfig.alwaysUsePOST = YES;

        // 是否在begin Session方法中上报IDFA
        countlyConfig.enableAttribution = NO;

        [Countly.sharedInstance setCustomHeaderFieldValue:@"application/json"];
        [Countly.sharedInstance startWithConfig:countlyConfig];
        [LYCountlyHooker hook];

        [LYCountlyEventDistributor sharedInstance].delegate = delegate;
    });
}

+ (void)userLoggedIn:(NSString *)userID {
    [LYCountlyCustomConfig currentConfig].userId = userID;
    [[Countly sharedInstance] userLoggedIn:userID];
}

+ (void)userLoggedOut {
    [LYCountlyCustomConfig currentConfig].userId = nil;
    [[Countly sharedInstance] userLoggedOut];
}

#pragma mark - Events
+ (void)recordEvent:(NSString *)key
{
    [[Countly sharedInstance] recordEvent:key];
}

+ (void)recordEvent:(NSString *)key count:(NSUInteger)count
{
    [[Countly sharedInstance] recordEvent:key count:count];
}

+ (void)recordEvent:(NSString *)key sum:(double)sum
{
    [[Countly sharedInstance] recordEvent:key sum:sum];
}

+ (void)recordEvent:(NSString *)key duration:(NSTimeInterval)duration
{
    [[Countly sharedInstance] recordEvent:key duration:duration];
}

+ (void)recordEvent:(NSString *)key count:(NSUInteger)count sum:(double)sum
{
    [[Countly sharedInstance] recordEvent:key count:count sum:sum];
}

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation
{
    [[Countly sharedInstance] recordEvent:key segmentation:segmentation];
}

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count
{
    [[Countly sharedInstance] recordEvent:key segmentation:segmentation count:count];
}

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count sum:(double)sum
{
    [[Countly sharedInstance] recordEvent:key segmentation:segmentation count:count sum:sum];
}

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count sum:(double)sum duration:(NSTimeInterval)duration
{
    [[Countly sharedInstance] recordEvent:key segmentation:segmentation count:count sum:sum duration:duration];
}

@end
