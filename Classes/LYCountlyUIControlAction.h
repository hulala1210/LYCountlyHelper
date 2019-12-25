//
//  LYCountlyUIControlAction.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/20.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCountlyUIControlAction : NSObject

@property (copy, nonatomic) NSString *targetName;
@property (copy, nonatomic) NSString *action;
@property (unsafe_unretained, nonatomic) UIControlEvents events;

- (void)receiveActionWithSender:(id)sender;

@end

