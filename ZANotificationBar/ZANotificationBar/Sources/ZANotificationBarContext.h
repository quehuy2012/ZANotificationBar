//
//  ZANotificationBarContext.h
//  ZANotificationBar
//
//  Created by CPU11713 on 5/4/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZANotifyAction;

@interface ZANotificationBarContext : NSObject

@property (nonatomic, readwrite) BOOL showNotificationInDetail;
@property (nonatomic, readwrite) NSString *appName;
@property (nonatomic, readwrite) NSString *appIconName;

@property (nonatomic, readonly) NSArray<ZANotifyAction *> *actions;

- (void)addAction:(ZANotifyAction *)action;
@end
