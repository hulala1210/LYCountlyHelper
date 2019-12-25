//
//  CountlyExtensions.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/10.
//  Copyright © 2019 appscomm. All rights reserved.
//


#import "CountlyCommon+Extension.h"
#import "CountlyConsentManager+Extension.h"
#import "CountlyPersistency+CustomInfo.h"
#import "CountlyLocationManager+Extension.h"
#import "CountlyEvent+CustomInfo.h"

#ifndef CountlyExtensions_h
#define CountlyExtensions_h


#endif /* CountlyExtensions_h */

#define COUNTLY_LOG(fmt, ...) CountlyInternalLog(fmt, ##__VA_ARGS__)

void CountlyInternalLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

FOUNDATION_EXPORT NSString* const kCountlyQSKeyDeviceID;
FOUNDATION_EXPORT NSString* const kCountlyInputEndpoint;
FOUNDATION_EXPORT NSString* const kCountlyUploadBoundary;
FOUNDATION_EXPORT const NSInteger kCountlyGETRequestMaxLength;
FOUNDATION_EXPORT NSString* const CLYTemporaryDeviceID;

FOUNDATION_EXPORT NSString* const kCountlyQSKeyAppKey;
FOUNDATION_EXPORT NSString* const kCountlyQSKeyTimestamp;
FOUNDATION_EXPORT NSString* const kCountlyQSKeyTimeHourOfDay;
FOUNDATION_EXPORT NSString* const kCountlyQSKeyTimeDayOfWeek;
FOUNDATION_EXPORT NSString* const kCountlyQSKeyTimeZone;
FOUNDATION_EXPORT NSString* const kCountlyQSKeySDKVersion;
FOUNDATION_EXPORT NSString* const kCountlySDKVersion;
FOUNDATION_EXPORT NSString* const kCountlyQSKeySDKName;
FOUNDATION_EXPORT NSString* const kCountlySDKName;

FOUNDATION_EXPORT NSString* const kCountlyQSKeyMetrics;
FOUNDATION_EXPORT NSString* const kCountlyQSKeyLocation;


@interface NSArray (Countly)
- (NSString *)cly_JSONify;
@end

@interface NSDictionary (Countly)
- (NSString *)cly_JSONify;
@end

@interface NSString (Countly)
- (NSString *)cly_URLEscaped;
- (NSString *)cly_SHA256;
- (NSData *)cly_dataUTF8;
@end

@interface NSData (Countly)
- (NSString *)cly_stringUTF8;
@end
