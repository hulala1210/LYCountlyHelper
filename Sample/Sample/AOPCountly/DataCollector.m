//
//  DataCollector.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/25.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "DataCollector.h"

@implementation DataCollector

+ (instancetype)sharedInstance {
    static DataCollector *collector = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collector = [[DataCollector alloc] init];
    });
    
    return collector;
}

- (void)didEnterViewController:(UIViewController *)viewController {
    NSLog(@"%s,%@", __func__,viewController);
}

- (void)didLeaveViewController:(UIViewController *)viewController {
    NSLog(@"%s,%@", __func__,viewController);

}

- (void)tableView:(UITableView *)tableView didSelectRowWithViewController:(UIViewController *)viewController tableViewDelegate:(id <UITableViewDelegate>)delegate index:(NSIndexPath *)indexPath {
    NSLog(@"%s,%@,%@,%@,%@", __func__,viewController,tableView,delegate,indexPath);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemWithViewController:(UIViewController *)viewController collectionViewDelegate:(id <UICollectionViewDelegate>)delegate index:(NSIndexPath *)indexPath {
    NSLog(@"%s,%@,%@,%@,%@", __func__,viewController,collectionView,delegate,indexPath);

}

- (void)receiveEventsWithControlAction:(LYCountlyUIControlAction *)controlAction {
    NSLog(@"%s,%@", __func__, controlAction);

}

@end
