
//
//  DataCollector.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/25.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYCountlyEventDistributionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataCollector : NSObject <LYCountlyEventDistributionProtocol>

+ (instancetype)sharedInstance;


@end

NS_ASSUME_NONNULL_END
