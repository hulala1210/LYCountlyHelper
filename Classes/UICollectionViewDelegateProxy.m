//
//  UICollectionViewDelegateProxy.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/20.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "UICollectionViewDelegateProxy.h"
#import "LYCountlyEventDistributor.h"

@interface UICollectionViewDelegateProxy ()

{
    __weak NSObject <UICollectionViewDelegate> * _delegate;
}

@end

@implementation UICollectionViewDelegateProxy

+ (instancetype)proxyWithObject:(id <UICollectionViewDelegate>)object {
    UICollectionViewDelegateProxy *proxy = [UICollectionViewDelegateProxy alloc];
    proxy->_delegate = object;
    return proxy;
}

//  拦截此 delegate 方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
    UIViewController *viewController = nil;
    UIResponder *responder = collectionView;
    
    while (responder) {
        responder = responder.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)responder;
            break;
        } else if ([responder isKindOfClass:[UIWindow class]]) {
            break;
        }
    }
    
    if ([[LYCountlyEventDistributor sharedInstance].delegate respondsToSelector:@selector(collectionView:didSelectItemWithViewController:collectionViewDelegate:index:)]) {
        [[LYCountlyEventDistributor sharedInstance].delegate collectionView:collectionView didSelectItemWithViewController:viewController collectionViewDelegate:_delegate index:indexPath];
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
    NSMethodSignature *methodSignature = [_delegate methodSignatureForSelector:sel];
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = [invocation selector];
    if ([_delegate respondsToSelector:sel]) {
        [invocation invokeWithTarget:_delegate];
    }

}

@end
