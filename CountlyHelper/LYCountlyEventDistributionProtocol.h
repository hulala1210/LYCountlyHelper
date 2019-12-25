//
//  LYCountlyEventDistributionProtocol.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/24.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYCountlyUIControlAction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LYCountlyEventDistributionProtocol <NSObject>

@optional
- (void)didEnterViewController:(UIViewController *)viewController;
- (void)didLeaveViewController:(UIViewController *)viewController;

@optional
- (void)tableView:(UITableView *)tableView didSelectRowWithViewController:(UIViewController *)viewController tableViewDelegate:(id <UITableViewDelegate>)delegate index:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView didSelectItemWithViewController:(UIViewController *)viewController collectionViewDelegate:(id <UICollectionViewDelegate>)delegate index:(NSIndexPath *)indexPath;

@optional
- (void)receiveEventsWithControlAction:(LYCountlyUIControlAction *)controlAction;

@end

NS_ASSUME_NONNULL_END
