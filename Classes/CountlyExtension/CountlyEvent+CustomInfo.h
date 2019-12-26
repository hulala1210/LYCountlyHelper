//
//  CountlyEvent+CustomInfo.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/24.
//  Copyright © 2019 appscomm. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface CountlyEvent : NSObject

@end

@interface CountlyEvent (CustomInfo)

- (NSDictionary *)dictionaryRepresentation;

@end
