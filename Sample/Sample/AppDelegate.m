//
//  AppDelegate.m
//  Sample
//
//  Created by Kevin Chen on 2019/12/26.
//  Copyright © 2019 AppScomm. All rights reserved.
//

#import "AppDelegate.h"
#import "LYCountlyHelper.h"
#import "DataCollector.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    LYCountlyCustomConfig *config = [[LYCountlyCustomConfig alloc] init];
    config.appKey = @"e3293452c1306ed1808b5d7e0148bf88";
    config.host = @"https://testnew.appscomm.cn/countly/api/v1/contents";
    config.appName = @"3plus-helio";
    
    config.updateSessionPeriod = 300;
    config.eventSendThreshold = 3;
    
    config.storedRequestsLimit = 5000;

    [LYCountlyHelper startWithConfig:config delegate:[DataCollector sharedInstance]];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
