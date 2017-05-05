//
//  ZANotificationBarContext.m
//  ZANotificationBar
//
//  Created by CPU11713 on 5/4/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZANotificationBarContext.h"
#import "ZANotifyAction.h"

@interface ZANotificationBarContext ()

@property (nonatomic, readwrite) NSMutableArray<ZANotifyAction *> *internalActions;

@end

@implementation ZANotificationBarContext

- (instancetype)init {
    if (self = [super init]) {
        _showNotificationInDetail = YES;
        _internalActions = [NSMutableArray array];
    }
    return self;
}

- (NSArray<ZANotifyAction *> *)actions {
    return [self.internalActions copy];
}

- (void)addAction:(ZANotifyAction *)action {
    [self.internalActions addObject:action];
}

- (void)removeAction:(ZANotifyAction *)action {
    [self.internalActions removeObject:action];
}

- (void)clearAction {
    self.internalActions = [NSMutableArray array];
}

@end
