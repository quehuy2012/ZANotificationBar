//
//  ZANotifyAction.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZANotifyAction.h"

@implementation ZANotifyAction

- (instancetype)initWithTitle:(NSString *)title type:(ZANotificationActionType)type handler:(void (^)(ZANotifyAction *))handler {
    if (self = [super init]) {
        _actionTitle = title;
        _actionType = type;
        _actionHandler = handler;
    }
    return self;
}

@end
