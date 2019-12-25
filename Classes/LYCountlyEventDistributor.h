//
//  LYCountlyEventDistributor.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/24.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYCountlyEventDistributionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYCountlyEventDistributor : NSObject

@property (weak, nonatomic) id <LYCountlyEventDistributionProtocol> delegate;
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
