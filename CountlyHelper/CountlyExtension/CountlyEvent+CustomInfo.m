//
//  CountlyEvent+CustomInfo.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/24.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "CountlyEvent+CustomInfo.h"

static NSString* const kCustomCountlyEventKeyKey           = @"key";
static NSString* const kCustomCountlyEventKeySegmentation  = @"remarks";
//NSString* const kCountlyEventKeyCount         = @"count";
//NSString* const kCountlyEventKeySum           = @"sum";
static NSString* const kCustomCountlyEventKeyTimestamp     = @"timestamp";
//NSString* const kCountlyEventKeyHourOfDay     = @"hour";
//NSString* const kCountlyEventKeyDayOfWeek     = @"dow";
static NSString* const kCustomCountlyEventKeyDuration      = @"duration";

@interface CountlyEvent ()

@property (nonatomic, copy) NSString* key;
@property (nonatomic, copy) NSDictionary* segmentation;
@property (nonatomic) NSUInteger count;
@property (nonatomic) double sum;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) NSUInteger hourOfDay;
@property (nonatomic) NSUInteger dayOfWeek;
@property (nonatomic) NSTimeInterval duration;

@end

@implementation CountlyEvent (CustomInfo)

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary* eventData = NSMutableDictionary.dictionary;
    eventData[kCustomCountlyEventKeyKey] = self.key;
    if (self.segmentation)
    {
        eventData[kCustomCountlyEventKeySegmentation] = self.segmentation;
    }
//    eventData[kCountlyEventKeyCount] = @(self.count);
//    eventData[kCountlyEventKeySum] = @(self.sum);
    eventData[kCustomCountlyEventKeyTimestamp] = @((long long)(self.timestamp * 1000));
//    eventData[kCountlyEventKeyHourOfDay] = @(self.hourOfDay);
//    eventData[kCountlyEventKeyDayOfWeek] = @(self.dayOfWeek);
    eventData[kCustomCountlyEventKeyDuration] = @(self.duration);
    return eventData;
}

@end
