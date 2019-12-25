//
//  LYCountlyCustomConfig.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/18.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "LYCountlyCustomConfig.h"

@implementation LYCountlyCustomConfig

static LYCountlyCustomConfig *staticCustomConfig;

+ (LYCountlyCustomConfig *)currentConfig {
    return staticCustomConfig;
}

+ (void)setCurrentConfig:(LYCountlyCustomConfig *)currentConfig {
    staticCustomConfig = currentConfig;
}

@end
