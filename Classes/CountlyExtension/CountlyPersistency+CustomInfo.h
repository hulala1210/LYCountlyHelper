//
//  CountlyPersistency+CustomInfo.h
//  Apps
//
//  Created by Kevin Chen on 2019/12/18.
//  Copyright © 2019 appscomm. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface CountlyPersistency : NSObject

@end

@interface CountlyPersistency (CustomInfo)

- (NSArray *)dictionaryRepresentationRecordedEvents;

@end

@interface CountlyPersistency()

@property (nonatomic) NSMutableArray* recordedEvents;

+ (instancetype)sharedInstance;

- (void)addToQueue:(NSString *)queryString;
- (NSString *)firstItemInQueue;
- (void)removeFromQueue:(NSString *)queryString;
- (void)saveToFile;

@end

NS_ASSUME_NONNULL_END
