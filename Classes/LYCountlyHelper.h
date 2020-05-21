//
//  LYCountlyHelper.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/9.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYCountlyCustomConfig.h"
#import "LYCountlyUIControlAction.h"

@protocol LYCountlyEventDistributionProtocol;

@interface LYCountlyHelper : NSObject

//@property (strong, nonatomic, class) LYCountlyCustomConfig *customConfig;

+ (void)startWithConfig:(LYCountlyCustomConfig *)config delegate:(id <LYCountlyEventDistributionProtocol>)delegate;

+ (void)userLoggedIn:(NSString *)userID;

+ (void)userLoggedOut;

#pragma mark - Events
+ (void)recordEvent:(NSString *)key;

+ (void)recordEvent:(NSString *)key count:(NSUInteger)count;

+ (void)recordEvent:(NSString *)key sum:(double)sum;

+ (void)recordEvent:(NSString *)key duration:(NSTimeInterval)duration;

+ (void)recordEvent:(NSString *)key count:(NSUInteger)count sum:(double)sum;

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation;

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count;
+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count sum:(double)sum;

+ (void)recordEvent:(NSString *)key segmentation:(NSDictionary *)segmentation count:(NSUInteger)count sum:(double)sum duration:(NSTimeInterval)duration;


@end

