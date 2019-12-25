//
//  LYCountlyEventDistributor.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/24.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "LYCountlyEventDistributor.h"

@interface LYCountlyEventDistributor ()

@end

@implementation LYCountlyEventDistributor

+ (instancetype)sharedInstance {
    static LYCountlyEventDistributor *distributor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        distributor = [[LYCountlyEventDistributor alloc] init];
    });
    
    return distributor;
}

@end
