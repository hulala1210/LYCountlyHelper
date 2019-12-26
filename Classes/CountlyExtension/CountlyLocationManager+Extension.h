//
//  CountlyLocationManager+Extension.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/11.
//  Copyright © 2019 appscomm. All rights reserved.
//

@interface CountlyLocationManager : NSObject

@end

NS_ASSUME_NONNULL_BEGIN

@interface CountlyLocationManager ()

@property (nonatomic) BOOL isLocationInfoDisabled;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
