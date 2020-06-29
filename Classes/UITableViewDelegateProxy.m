//
//  UITableViewDelegateProxy.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/20.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "UITableViewDelegateProxy.h"
#import "LYCountlyEventDistributor.h"

@interface UITableViewDelegateProxy ()

{
    __weak NSObject <UITableViewDelegate> *_delegate;
}

@end

@implementation UITableViewDelegateProxy

+ (instancetype)proxyWithObject:(id<UITableViewDelegate>)object {
    UITableViewDelegateProxy *proxy = [UITableViewDelegateProxy alloc];
    proxy->_delegate = object;
    return proxy;
}

//  拦截此 delegate 方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    UIViewController *viewController = nil;
    UIResponder *responder = tableView;
    
    while (responder) {
        responder = responder.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)responder;
            break;
        } else if ([responder isKindOfClass:[UIWindow class]]) {
            break;
        }
    }
    
    if ([[LYCountlyEventDistributor sharedInstance].delegate respondsToSelector:@selector(tableView:didSelectRowWithViewController:tableViewDelegate:index:)]) {
        [[LYCountlyEventDistributor sharedInstance].delegate tableView:tableView didSelectRowWithViewController:viewController tableViewDelegate:_delegate index:indexPath];
    }
    
}


- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    BOOL conforms = [super conformsToProtocol:aProtocol];
    return conforms;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL hasResponds = [_delegate respondsToSelector:aSelector];
    return hasResponds;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *methodSignature = nil;
    
    // 如果delegate被释放了，也就是delegate为nil，也要允许delegate继续执行方法
    if (_delegate == nil) {
        methodSignature = [NSObject instanceMethodSignatureForSelector:@selector(class)];
    }
    else {
        methodSignature = [_delegate methodSignatureForSelector:sel];
    }
    
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = [invocation selector];
    if ([_delegate respondsToSelector:sel]) {
        [invocation invokeWithTarget:_delegate];
    }

}


@end
