//
//  UITableViewDelegateProxy.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/20.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewDelegateProxy : NSProxy <UITableViewDelegate>
+ (instancetype)proxyWithObject:(id <UITableViewDelegate>)object;

@end

NS_ASSUME_NONNULL_END
