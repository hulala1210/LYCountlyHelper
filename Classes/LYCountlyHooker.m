//
//  LYCountlyHooker.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/19.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "LYCountlyHooker.h"
#import <YYKit/YYKit.h>
#import "UITableViewDelegateProxy.h"
#import "UICollectionViewDelegateProxy.h"
#import "LYCountlyUIControlAction.h"
#import "LYCountlyEventDistributor.h"

static void *countlyProxyKey = "countlyProxyKey";

@interface UITableView (DelegateHook)

@end

@implementation UITableView (DelegateHook)

- (void)setCountlyProxy:(UITableViewDelegateProxy *)countlyProxy {
    [self setAssociateValue:countlyProxy withKey:countlyProxyKey];
}

- (UITableViewDelegateProxy *)countlyProxy {
    return [self getAssociatedValueForKey:countlyProxyKey];
}

- (void)countlyHook_setDelegate:(id<UITableViewDelegate>)delegate {
    UITableViewDelegateProxy *proxy = [UITableViewDelegateProxy proxyWithObject:delegate];
    [self countlyHook_setDelegate:proxy];
    self.countlyProxy = proxy;
}

@end

@interface UICollectionView (DelegateHook)

@end

@implementation UICollectionView (DelegateHook)

- (void)setCountlyProxy:(UICollectionViewDelegateProxy *)countlyProxy {
    [self setAssociateValue:countlyProxy withKey:countlyProxyKey];
}

- (UICollectionViewDelegateProxy *)countlyProxy {
    return [self getAssociatedValueForKey:countlyProxyKey];
}

- (void)countlyHook_setDelegate:(id<UICollectionViewDelegate>)delegate {
    UICollectionViewDelegateProxy *proxy = [UICollectionViewDelegateProxy proxyWithObject:delegate];
    [self countlyHook_setDelegate:proxy];
    self.countlyProxy = proxy;
    
}

@end

static void *countlyActionKey = "countlyActionKey";

@interface UIControl (ActionHook)

@property (strong, nonatomic) NSMutableSet <LYCountlyUIControlAction *>*countlyActionSet;

@end

@implementation UIControl (ActionHook)

- (LYCountlyUIControlAction *)createCountlyWithTarget:(id)target action:(SEL)action sender:(UIControl *)sender controlEvents:(UIControlEvents)events {
    LYCountlyUIControlAction *countlyAction = [[LYCountlyUIControlAction alloc] init];
    countlyAction.targetClassName = NSStringFromClass([target class]);
    countlyAction.targetClass = [target class];
    countlyAction.actionName = NSStringFromSelector(action);
    countlyAction.action = action;
    countlyAction.events = events;
    
    countlyAction.sender = sender;
    
    return countlyAction;
}

- (NSMutableSet <LYCountlyUIControlAction *>*)countlyActionSet {
    return (NSMutableSet <LYCountlyUIControlAction *> *)[self getAssociatedValueForKey:&countlyActionKey];
}

- (void)setCountlyActionSet:(NSMutableSet<LYCountlyUIControlAction *> *)countlyActionSet {
    [self setAssociateValue:countlyActionSet withKey:&countlyActionKey];
}

- (void)addCountlyAction:(LYCountlyUIControlAction *)action {
    
    if (!self.countlyActionSet) {
        self.countlyActionSet = [[NSMutableSet alloc] init];
    }
    
    if (![self.countlyActionSet containsObject:action]) {
        [self.countlyActionSet addObject:action];
    }
}

- (void)removeCountlyAction:(LYCountlyUIControlAction *)action {
    [self.countlyActionSet removeObject:action];
}

- (void)countlyHook_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events {
    
    LYCountlyUIControlAction *countlyAction = [self createCountlyWithTarget:target action:action sender:self controlEvents:events];
    [self addCountlyAction:countlyAction];
    
    [self countlyHook_addTarget:countlyAction action:@selector(receiveActionWithSender:) forControlEvents:events];
    [self countlyHook_addTarget:target action:action forControlEvents:events];
}

- (void)countlyHook_removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if (!self.countlyActionSet) {
        self.countlyActionSet = [[NSMutableSet alloc] init];
    }
    LYCountlyUIControlAction *countlyAction = [self createCountlyWithTarget:target action:action sender:self controlEvents:controlEvents];
    [self removeCountlyAction:countlyAction];

    [self countlyHook_removeTarget:countlyAction action:@selector(receiveActionWithSender:) forControlEvents:controlEvents];
    [self countlyHook_removeTarget:target action:@selector(action) forControlEvents:controlEvents];
}

@end

@interface UIViewController (PageHook)

@end

@implementation UIViewController (PageHook)

- (void)countlyHook_viewDidDisappear:(BOOL)animated {
    [[LYCountlyEventDistributor sharedInstance].delegate didLeaveViewController:self];
    [self countlyHook_viewDidDisappear:animated];
}

- (void)countlyHook_viewDidAppear:(BOOL)animated {
    [[LYCountlyEventDistributor sharedInstance].delegate didEnterViewController:self];
    [self countlyHook_viewDidAppear:animated];
}

@end

@implementation LYCountlyHooker

+ (void)hook {
    [UITableView swizzleInstanceMethod:@selector(setDelegate:) with:@selector(countlyHook_setDelegate:)];
    [UICollectionView swizzleInstanceMethod:@selector(setDelegate:) with:@selector(countlyHook_setDelegate:)];
    [UIControl swizzleInstanceMethod:@selector(addTarget:action:forControlEvents:) with:@selector(countlyHook_addTarget:action:forControlEvents:)];
    [UIControl swizzleInstanceMethod:@selector(removeTarget:action:forControlEvents:) with:@selector(countlyHook_removeTarget:action:forControlEvents:)];
    [UIViewController swizzleInstanceMethod:@selector(viewDidAppear:) with:@selector(countlyHook_viewDidAppear:)];
    [UIViewController swizzleInstanceMethod:@selector(viewDidDisappear:) with:@selector(countlyHook_viewDidDisappear:)];
}


@end
