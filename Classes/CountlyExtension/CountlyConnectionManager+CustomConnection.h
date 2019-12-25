//
//  CountlyConnectionManager+CustomConnection.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/9.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "LYCountlyCustomConfig.h"

@interface CountlyConnectionManager: NSObject

@end

@interface CountlyConnectionManager()

+ (instancetype)sharedInstance;

@end

@interface CountlyConnectionManager (CustomConnection)

@end

