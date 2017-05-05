//
//  ZANotificationBar.h
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ZANotifyAction;
@class ZANotificationBarView;
@class ZANotificationBarContext;

/**
 The notification styles
    - ZANotificationStyleSimple
    - ZANotificationStyleDetail

 - ZANotificationStyleSimple: Displays notification as simple banner
 - ZANotificationStyleDetail: Displays notification that can open in detail by swiping down
 */
typedef NS_ENUM(NSInteger, ZANotificationStyle) {
    ZANotificationStyleSimple,
    ZANotificationStyleDetail
};

@interface ZANotificationBar : NSObject

/**
 The display duration of the notification bar. The default value is `5 second`
 If 0 is set, notification bar auto hide will be disabled.
 */
@property (nonatomic, readwrite) double displayDuration;

@property (nonatomic, copy) void (^handler)(BOOL);

@property (nonatomic, readwrite) ZANotificationBarView *notificationBar;

@property (nonatomic, readwrite) ZANotificationBarContext *context;

/**
 Init a notifacation bar for displaying an alert to the user.

 @param header The title of alert
 @param body Descriptive text that provides additional details about the reason for the alert
 @param preferredStyle The style of the alert. Use this parameter to configure the notification bar as an `simple` or `detail`
 @param handler The block that execute when the use selects the notification message.
 @return an instance ZANotificationBar object
 */
- (instancetype)initWithHeader:(NSString *)header
                          body:(NSString *)body
               preferredStyle:(ZANotificationStyle)preferredStyle
                      handler:(void (^)(BOOL))handler;

/**
 Playing the sound file while displaying notification. 
 If file name or type doesn't found, default sound will be played.

 @param name Name of the sound file in bundle
 @param type Sound format (.waw, .mp3 ...)
 @param vibrate The bool value that used to indicate the vibrate effect should turn on or turn off for notification
 */
- (void)notoficationSoundFromName:(NSString *)name ofType:(NSString *)type vibrate:(BOOL)vibrate;

- (void)addAction:(ZANotifyAction *)action;

- (void)hideNotification:(UIButton *)sender;

@end
