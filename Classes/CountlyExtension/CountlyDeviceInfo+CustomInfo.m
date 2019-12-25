//
//  CountlyDeviceInfo+CustomInfo.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/10.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "CountlyDeviceInfo+CustomInfo.h"
#import "CountlyExtensions.h"

@interface CountlyDeviceInfo ()

+ (NSString *)device;
+ (NSString *)architecture;
+ (NSString *)osName;
+ (NSString *)osVersion;
+ (NSString *)carrier;
+ (NSString *)resolution;
+ (NSString *)density;
+ (NSString *)locale;
+ (NSString *)appVersion;
+ (NSString *)appBuild;
#if TARGET_OS_IOS
+ (NSInteger)hasWatch;
+ (NSInteger)installedWatchApp;
#endif

@end

//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyDevice;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyOS;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyOSVersion;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyAppVersion;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyCarrier;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyDensity;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyLocale;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyHasWatch;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyInstalledWatchApp;
//FOUNDATION_EXPORT NSString* const kCountlyMetricKeyResolution;

static NSString * const kCustomCountlyMetricKeyDevice = @"device";
static NSString * const kCustomCountlyMetricKeyOS = @"os";
static NSString * const kCustomCountlyMetricKeyOSVersion = @"osVersion";
static NSString * const kCustomCountlyMetricKeyAppVersion = @"appVersion";
static NSString * const kCustomCountlyMetricKeyCarrier = @"carrier";
static NSString * const kCustomCountlyMetricKeyDensity = @"density";
static NSString * const kCustomCountlyMetricKeyLocale = @"local";
static NSString * const kCustomCountlyMetricKeyHasWatch = @"hasWatch";
static NSString * const kCustomCountlyMetricKeyInstalledWatchApp = @"installedWatchApp";
static NSString * const kCustomCountlyMetricKeyResolution = @"resolution";

@implementation CountlyDeviceInfo (CustomInfo)


+ (NSDictionary *)metrics
{
    NSMutableDictionary* metricsDictionary = NSMutableDictionary.new;
    metricsDictionary[kCustomCountlyMetricKeyDevice] = CountlyDeviceInfo.device;
    metricsDictionary[kCustomCountlyMetricKeyOS] = CountlyDeviceInfo.osName;
    metricsDictionary[kCustomCountlyMetricKeyOSVersion] = CountlyDeviceInfo.osVersion;
    metricsDictionary[kCustomCountlyMetricKeyAppVersion] = CountlyDeviceInfo.appVersion;

    NSString *carrier = CountlyDeviceInfo.carrier;
    if (carrier)
        metricsDictionary[kCustomCountlyMetricKeyCarrier] = carrier;

    metricsDictionary[kCustomCountlyMetricKeyResolution] = CountlyDeviceInfo.resolution;
    metricsDictionary[kCustomCountlyMetricKeyDensity] = CountlyDeviceInfo.density;
    metricsDictionary[kCustomCountlyMetricKeyLocale] = CountlyDeviceInfo.locale;

#if TARGET_OS_IOS
    if (CountlyCommon.sharedInstance.enableAppleWatch)
    {
        if (CountlyConsentManager.sharedInstance.consentForAppleWatch)
        {
            metricsDictionary[kCustomCountlyMetricKeyHasWatch] = @(CountlyDeviceInfo.hasWatch);
            metricsDictionary[kCustomCountlyMetricKeyInstalledWatchApp] = @(CountlyDeviceInfo.installedWatchApp);
        }
    }
#endif

    return metricsDictionary.copy;
}


@end
