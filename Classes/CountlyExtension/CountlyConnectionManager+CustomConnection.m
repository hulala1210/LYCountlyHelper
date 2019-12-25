//
//  CountlyConnectionManager+CustomConnection.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/9.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "CountlyConnectionManager+CustomConnection.h"
#import "CountlyExtensions.h"
#import "CountlyDeviceInfo+CustomInfo.h"
#import "YYKit.h"
#import "LYCountlyHelper.h"

static NSString const *kCustomCountlyQSKeyAppKey = @"appKey";
static NSString const *kCustomCountlyQSKeyAppName = @"appName";
static NSString const *kCustomCountlyQSKeyPhoneId = @"phoneId";
static NSString const *kCustomCountlyQSKeyDeviceId = @"deviceId";
static NSString const *kCustomCountlyQSKeyDeviceType = @"deviceType";

static NSString const *kCustomCountlyQSKeySessionBegin = @"beginSession";
static NSString const *kCustomCountlyQSKeySessionUpdate = @"updateSession";
static NSString const *kCustomCountlyQSKeySessionEnd = @"endSession";

static NSString const *kCustomCountlyQSKeyMetrics = @"metrics";
static NSString const *kCustomCountlyQSKeySessionDuration = @"sessionDuration";
static NSString const *kCustomCountlyQSKeyEvents = @"eventList";
static NSString const *kCustomCountlyQSKeyParamsList = @"paramsList";

static NSString const *kCustomCountlyQSKeySDKName = @"sdkName";
static NSString const *kCustomCountlyQSKeySDKVersion = @"sdkVersion";

static NSString const *kCustomCountlyQSKeyUserId = @"userId";
static NSString const *kCustomCountlyQSKeySeq = @"seq";

//static NSString const *kCustomCountlyQSKeySessionDuration = @"sessionDuration";


@interface CountlyConnectionManager ()
{
    NSTimeInterval unsentSessionLength;
    NSTimeInterval lastSessionStartTime;
    BOOL isCrashing;
}

@property (nonatomic) NSString* appKey;
@property (nonatomic) NSString* host;
@property (nonatomic) NSURLSessionTask* connection;
@property (nonatomic) NSArray* pinnedCertificates;
@property (nonatomic) NSString* customHeaderFieldName;
@property (nonatomic) NSString* customHeaderFieldValue;
@property (nonatomic) NSString* secretSalt;
@property (nonatomic) BOOL alwaysUsePOST;
@property (nonatomic) NSURLSessionConfiguration* URLSessionConfiguration;


- (NSString *)appendChecksum:(NSString *)queryString;
- (NSData *)pictureUploadDataForRequest:(NSString *)requestString;
- (NSURLSession *)URLSession;
- (BOOL)isRequestSuccessful:(NSURLResponse *)response;

- (NSInteger)sessionLengthInSeconds;

@end


@implementation CountlyConnectionManager (CustomConnection)

static void * customConfigKey = "customConfigKey";

#pragma mark - private
- (NSString *) generateSeq
{
//    NSTimeInterval millsecond = [[NSDate date] timeIntervalSince1970];
//    return [NSString stringWithFormat:@"%.0f",millsecond * 1000];
    
    //获取毫秒时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    //获取随机生成的id
    NSString *uuid = [NSUUID UUID].UUIDString;
    
    NSString *seq = [[NSString alloc] initWithFormat:@"%@_%@",timeSp,uuid];
    
    return seq;
}


- (void)proceedOnQueue
{
    COUNTLY_LOG(@"Proceeding on queue...");

    if (self.connection)
    {
        COUNTLY_LOG(@"Proceeding on queue is aborted: Already has a request in process!");
        return;
    }

    if (isCrashing)
    {
        COUNTLY_LOG(@"Proceeding on queue is aborted: Application is crashing!");
        return;
    }

    if (self.customHeaderFieldName && !self.customHeaderFieldValue)
    {
        COUNTLY_LOG(@"Proceeding on queue is aborted: customHeaderFieldName specified on config, but customHeaderFieldValue not set yet!");
        return;
    }

    NSString* firstItemInQueue = [CountlyPersistency.sharedInstance firstItemInQueue];
    if (!firstItemInQueue)
    {
        COUNTLY_LOG(@"Queue is empty. All requests are processed.");
        return;
    }

    NSString* temporaryDeviceIDQueryString = [NSString stringWithFormat:@"&%@=%@", kCountlyQSKeyDeviceID, CLYTemporaryDeviceID];
    if ([firstItemInQueue containsString:temporaryDeviceIDQueryString])
    {
        COUNTLY_LOG(@"Proceeding on queue is aborted: Device ID in request is CLYTemporaryDeviceID!");
        return;
    }

    [CountlyCommon.sharedInstance startBackgroundTask];

    NSString* queryString = firstItemInQueue;

    NSDictionary <NSString *, NSString *> *parameters = [self restoreParamsQueryString:queryString];
   
    if (parameters == nil) {
        [CountlyPersistency.sharedInstance removeFromQueue:firstItemInQueue];
        return;
    }
    
    NSData *jsonData = nil;
    if ([NSJSONSerialization isValidJSONObject:parameters]) { 
        
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    
    NSString* serverInputEndpoint = self.host;
    NSString* fullRequestURL = [serverInputEndpoint stringByAppendingFormat:@"?%@", queryString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullRequestURL]];
    [request setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];

//    NSData* pictureUploadData = [self pictureUploadDataForRequest:queryString];
//    if (pictureUploadData)
//    {
//        NSString *contentType = [@"multipart/form-data; boundary=" stringByAppendingString:kCountlyUploadBoundary];
//        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//        request.HTTPMethod = @"POST";
//        request.HTTPBody = pictureUploadData;
//    }
//    else if (queryString.length > kCountlyGETRequestMaxLength || self.alwaysUsePOST)
    if (queryString.length > kCountlyGETRequestMaxLength || self.alwaysUsePOST)
    {
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverInputEndpoint]];
        request.HTTPMethod = @"POST";
        request.HTTPBody = jsonData;
    }

    if (self.customHeaderFieldName && self.customHeaderFieldValue)
        [request setValue:self.customHeaderFieldValue forHTTPHeaderField:self.customHeaderFieldName];

    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    self.connection = [[self URLSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error)
    {
        self.connection = nil;

        if (!error)
        {
            if ([self isRequestSuccessful:response])
            {
                COUNTLY_LOG(@"Request <%p> successfully completed.", request);

                [CountlyPersistency.sharedInstance removeFromQueue:firstItemInQueue];

                [CountlyPersistency.sharedInstance saveToFile];

                [self proceedOnQueue];
            }
            else
            {
                COUNTLY_LOG(@"Request <%p> failed!\nServer reply: %@", request, [data cly_stringUTF8]);
            }
        }
        else
        {
            COUNTLY_LOG(@"Request <%p> failed!\nError: %@", request, error);
#if TARGET_OS_WATCH
            [CountlyPersistency.sharedInstance saveToFile];
#endif
        }
    }];

    [self.connection resume];

    COUNTLY_LOG(@"Request <%p> started:\n[%@] %@ \n%@", (id)request, request.HTTPMethod, request.URL.absoluteString, request.HTTPBody ? ([request.HTTPBody cly_stringUTF8] ?: @"Picture uploading...") : @"");
}

- (NSString *)queryEssentials
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *essential = [NSString stringWithFormat:@"%@=%@&%@=%@&%@=%lld&%@=%d&%@=%d&%@=%d&%@=%@&%@=%@&%@=%@&%@=%@",
                                        kCustomCountlyQSKeyAppKey, self.appKey.cly_URLEscaped,
                                        kCustomCountlyQSKeyDeviceId, CountlyDeviceInfo.sharedInstance.deviceID.cly_URLEscaped,
                                        kCountlyQSKeyTimestamp, (long long)(CountlyCommon.sharedInstance.uniqueTimestamp * 1000),
                                        kCountlyQSKeyTimeHourOfDay, (int)CountlyCommon.sharedInstance.hourOfDay,
                                        kCountlyQSKeyTimeDayOfWeek, (int)CountlyCommon.sharedInstance.dayOfWeek,
                                        kCountlyQSKeyTimeZone, (int)CountlyCommon.sharedInstance.timeZone,
                                        kCustomCountlyQSKeySDKVersion, kCountlySDKVersion,
                                        kCustomCountlyQSKeySDKName, kCountlySDKName,
                                        kCustomCountlyQSKeyAppName, [LYCountlyHelper customConfig].appName,
                                        kCustomCountlyQSKeyPhoneId, idfv];
    
    if ([LYCountlyHelper.customConfig.userId length]) {
        essential = [essential stringByAppendingFormat:@"&%@=%@",kCustomCountlyQSKeyUserId, LYCountlyHelper.customConfig.userId];
    }
    
    essential = [essential stringByAppendingFormat:@"&%@=%@",kCustomCountlyQSKeySeq, [self generateSeq]];
    
    return essential;
}

#pragma mark ---

- (void)beginSession
{
    if (!CountlyConsentManager.sharedInstance.consentForSessions)
        return;

    lastSessionStartTime = NSDate.date.timeIntervalSince1970;
    unsentSessionLength = 0.0;

    NSDictionary *metricsDetail = [CountlyDeviceInfo metrics];

    NSMutableDictionary *essentials = [[NSMutableDictionary alloc] initWithDictionary:[self restoreEssentialsWithEssentialsString:[self queryEssentials]]];
    
    NSDictionary *sessionContent = @{kCustomCountlyQSKeySessionBegin : @"1", kCountlyQSKeyTimestamp : @((long long)(CountlyCommon.sharedInstance.uniqueTimestamp * 1000))};

    NSDictionary *metrics = @{ kCountlyQSKeyMetrics : metricsDetail};
    
    NSDictionary *paramsListDict = @{kCustomCountlyQSKeySessionBegin:sessionContent};
    NSMutableDictionary *beginSessionDict = [[NSMutableDictionary alloc] init];
    [beginSessionDict addEntriesFromDictionary:essentials];
    [beginSessionDict addEntriesFromDictionary:metrics];
    [beginSessionDict addEntriesFromDictionary:paramsListDict];
    
    NSString *queryString = [beginSessionDict cly_JSONify];
    
    [CountlyPersistency.sharedInstance addToQueue:queryString];

    [self proceedOnQueue];
}

- (void)updateSession
{
    if (!CountlyConsentManager.sharedInstance.consentForSessions)
        return;

    NSMutableDictionary *essentials = [[NSMutableDictionary alloc] initWithDictionary:[self restoreEssentialsWithEssentialsString:[self queryEssentials]]];
    NSDictionary *sessionContent = @{kCustomCountlyQSKeySessionUpdate : @"1", kCustomCountlyQSKeySessionDuration : @((int)[self sessionLengthInSeconds]), kCountlyQSKeyTimestamp : @((long long)(CountlyCommon.sharedInstance.uniqueTimestamp * 1000))};
    
    NSDictionary *metricsDetail = [CountlyDeviceInfo metrics];
    NSDictionary *metrics = @{kCountlyQSKeyMetrics : metricsDetail};

    NSDictionary *paramsListDict = @{kCustomCountlyQSKeySessionUpdate:sessionContent};
    NSMutableDictionary *updateSessionDict = [[NSMutableDictionary alloc] init];
    [updateSessionDict addEntriesFromDictionary:essentials];
    [updateSessionDict addEntriesFromDictionary:paramsListDict];
    [updateSessionDict addEntriesFromDictionary:metrics];

    NSString *queryString = [updateSessionDict cly_JSONify];

    [CountlyPersistency.sharedInstance addToQueue:queryString];

    [self proceedOnQueue];
}

- (void)endSession
{
    if (!CountlyConsentManager.sharedInstance.consentForSessions)
        return;

    NSMutableDictionary *essentials = [[NSMutableDictionary alloc] initWithDictionary:[self restoreEssentialsWithEssentialsString:[self queryEssentials]]];
    NSDictionary *sessionContent = @{kCustomCountlyQSKeySessionEnd : @"1", kCustomCountlyQSKeySessionDuration : @((int)[self sessionLengthInSeconds]), kCountlyQSKeyTimestamp : @((long long)(CountlyCommon.sharedInstance.uniqueTimestamp * 1000))};
    NSDictionary *paramsListDict = @{kCustomCountlyQSKeySessionUpdate:sessionContent};
    
    NSDictionary *metricsDetail = [CountlyDeviceInfo metrics];
    NSDictionary *metrics = @{ kCountlyQSKeyMetrics : metricsDetail};
    
    NSMutableDictionary *endSessionDict = [[NSMutableDictionary alloc] init];
    [endSessionDict addEntriesFromDictionary:essentials];
    [endSessionDict addEntriesFromDictionary:paramsListDict];
    [endSessionDict addEntriesFromDictionary:metrics];

    NSString *queryString = [endSessionDict cly_JSONify];
    
    [CountlyPersistency.sharedInstance addToQueue:queryString];

    [self proceedOnQueue];
}

#pragma mark ---

- (void)sendEvents
{
    NSArray* events = [CountlyPersistency.sharedInstance dictionaryRepresentationRecordedEvents];

    if (!events)
        return;

    NSDictionary *essentials = [[NSDictionary alloc] initWithDictionary:[self restoreEssentialsWithEssentialsString:[self queryEssentials]]];
    
    NSDictionary *paramsListDict = @{kCustomCountlyQSKeyEvents:events};
    
    NSMutableDictionary *sendEventDict = [[NSMutableDictionary alloc] init];
    [sendEventDict addEntriesFromDictionary:essentials];
    [sendEventDict addEntriesFromDictionary:paramsListDict];
    
    NSString* queryString = [sendEventDict cly_JSONify];

    [CountlyPersistency.sharedInstance addToQueue:queryString];

    [self proceedOnQueue];
}


#pragma mark - Util
- (NSDictionary <NSString *, NSString *>*)restoreEssentialsWithEssentialsString:(NSString *)essentialsString {
    NSArray <NSString *>*essentials = [essentialsString componentsSeparatedByString:@"&"];
    NSMutableDictionary <NSString *, NSString *>*dictionary = [[NSMutableDictionary alloc] initWithCapacity:essentials.count];
    [essentials enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <NSString *>* keyAndValue = [obj componentsSeparatedByString:@"="];
        if (keyAndValue.count > 1) {
            [dictionary setObject:[keyAndValue.lastObject stringByRemovingPercentEncoding] forKey:[keyAndValue.firstObject stringByRemovingPercentEncoding]];
        }
    }];
    
    return dictionary;
}

- (NSDictionary <NSString *, NSString *>*)restoreParamsQueryString:(NSString *)queryString {
    NSString *paramsJson = [queryString stringByRemovingPercentEncoding];
    if (paramsJson == nil) {
        return nil;
    }

    NSData *paramsJsonData = [paramsJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:paramsJsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dictionary;
}

@end
