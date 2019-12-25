//
//  CountlyConsentManager+Extension.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/10.
//  Copyright © 2019 appscomm. All rights reserved.
//

@interface CountlyConsentManager : NSObject

@end

NS_ASSUME_NONNULL_BEGIN

@interface CountlyConsentManager ()

@property (nonatomic, readonly) BOOL consentForAppleWatch;
@property (nonatomic, readonly) BOOL consentForSessions;
@property (nonatomic, readonly) BOOL consentForLocation;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
