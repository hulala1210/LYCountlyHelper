//
//  LYCountlyUIControlAction.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/20.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCountlyUIControlAction : NSObject

@property (copy, nonatomic) NSString *targetClassName;
@property (unsafe_unretained, nonatomic) Class targetClass;

@property (copy, nonatomic) NSString *actionName;
@property (unsafe_unretained, nonatomic) SEL action;

@property (weak, nonatomic) UIControl *sender;

@property (unsafe_unretained, nonatomic) UIControlEvents events;

- (void)receiveActionWithSender:(id)sender;

@end

