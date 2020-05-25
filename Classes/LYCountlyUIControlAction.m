//
//  LYCountlyUIControlAction.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/20.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "LYCountlyUIControlAction.h"
#import "LYCountlyEventDistributor.h"

@implementation LYCountlyUIControlAction

- (void)receiveActionWithSender:(id)sender {
    [[[LYCountlyEventDistributor sharedInstance] delegate] receiveEventsWithControlAction:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LYCountlyUIControlAction targetClassName = %@, actionName = %@, events = %@",self.targetClassName, self.actionName, @(self.events)];
}

@end
