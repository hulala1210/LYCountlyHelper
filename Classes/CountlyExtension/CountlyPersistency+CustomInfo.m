//
//  CountlyPersistency+CustomInfo.m
//  Apps
//
//  Created by Kevin Chen on 2019/12/18.
//  Copyright © 2019 appscomm. All rights reserved.
//

#import "CountlyPersistency+CustomInfo.h"
#import "CountlyExtensions.h"

@implementation CountlyPersistency (CustomInfo)

- (NSArray *)dictionaryRepresentationRecordedEvents {
    NSMutableArray* tempArray = NSMutableArray.new;

    @synchronized (self.recordedEvents)
    {
        if (self.recordedEvents.count == 0)
            return nil;

        for (CountlyEvent* event in self.recordedEvents.copy)
        {
            [tempArray addObject:[event dictionaryRepresentation]];
            [self.recordedEvents removeObject:event];
        }
    }

    return tempArray.copy;
}

@end
