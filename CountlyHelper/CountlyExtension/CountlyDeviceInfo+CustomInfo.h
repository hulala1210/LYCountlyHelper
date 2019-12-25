//
//  CountlyDeviceInfo+CustomInfo.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/10.
//  Copyright © 2019 appscomm. All rights reserved.
//

@interface CountlyDeviceInfo : NSObject

@end


@interface CountlyDeviceInfo (CustomInfo)

+ (NSDictionary *)metrics;

@end


@interface CountlyDeviceInfo ()

+ (instancetype)sharedInstance;
@property (nonatomic) NSString *deviceID;


@end
