//
//  CountlyCommon+Extension.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/10.
//  Copyright © 2019 appscomm. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CountlyCommon : NSObject

@end

@interface CountlyCommon ()

@property (nonatomic) BOOL enableAppleWatch;

- (NSTimeInterval)uniqueTimestamp;
- (NSInteger)hourOfDay;
- (NSInteger)dayOfWeek;
- (NSInteger)timeZone;

+ (instancetype)sharedInstance;
- (void)startBackgroundTask;

@end

NS_ASSUME_NONNULL_END
