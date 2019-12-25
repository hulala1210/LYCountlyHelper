//
//  LYCountlyCustomConfig.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/18.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LYCountlyCustomConfig : NSObject

@property (strong, nonatomic, class) LYCountlyCustomConfig *currentConfig;

@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSString *appKey;
@property (nonatomic, copy) NSString* host;

/**
* Update session period is used for updating sessions and sending queued events to Countly Server periodically.
* @discussion If not set, it will be 60 seconds for @c iOS, @c tvOS & @c macOS, and 20 seconds for @c watchOS by default.
*/
@property (nonatomic) NSTimeInterval updateSessionPeriod;

/**
 * Event send threshold is used for sending queued events to Countly Server when number of recorded events reaches to it, without waiting for next update session defined by @c updateSessionPeriod.
 * @discussion If not set, it will be 10 for @c iOS, @c tvOS & @c macOS, and 3 for @c watchOS by default.
 */
@property (nonatomic) NSUInteger eventSendThreshold;

/**
 * Stored requests limit is used for limiting the number of request to be stored on the device, in case Countly Server is not reachable.
 * @discussion In case Countly Server is down or unreachable for a very long time, queued request may reach excessive numbers, and this may cause problems with requests being sent to Countly Server and being stored on the device. To prevent this, SDK will only store requests up to @c storedRequestsLimit.
 * @discussion If number of stored requests reaches @c storedRequestsLimit, SDK will start to drop oldest request while appending the newest one.
 * @discussion If not set, it will be 1000 by default.
 */
@property (nonatomic) NSUInteger storedRequestsLimit;


@end

