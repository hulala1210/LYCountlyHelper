//
//  CountlyEvent+CustomInfo.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/24.
//  Copyright © 2019 appscomm. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@interface CountlyEvent : NSObject

@end

@interface CountlyEvent (CustomInfo)

- (NSDictionary *)dictionaryRepresentation;


@end

NS_ASSUME_NONNULL_END
