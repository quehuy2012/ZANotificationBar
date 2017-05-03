//
//  ZANotifyAction.h
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Notification actions types

 - ZANotificationActionTypeDefault: Apply the default style to the action's button
 - ZANotificationActionTypeDestructive: Apply a style that indicates the action might change or delete data.
 - ZANotificationActionTypeTextInput: Apply a style that indicates the action displays an textfield helps to respond notification
 - ZANotificationActionTypeOnlyTextInput: Apply a style which remove all other action added and add only 1 textfield as input to respond notification
 - ZANotificationActionTypeCancel: Apply a style that indicates the action cancels the operation and leaves thing unchanged
 */
typedef NS_ENUM(NSInteger, ZANotificationActionType) {
    ZANotificationActionTypeDefault = 0,
    ZANotificationActionTypeDestructive,
    ZANotificationActionTypeTextInput,
    ZANotificationActionTypeOnlyTextInput,
    ZANotificationActionTypeCancel
};


@interface ZANotifyAction : NSObject

@property (nonatomic, readwrite) NSString *actionTitle;

@property (nonatomic, readwrite) ZANotificationActionType actionType;

/**
 The text that user input to respond the notification
 */
@property (nonatomic, readwrite) NSString *textResponse;

/**
 The block that execute when the use selects the action
 */
@property (nonatomic, copy) void (^actionHandler)(ZANotifyAction *action);


/**
 Init a notification action

 @param title Title to be displayed in the button
 @param type The type of the action NotifyAction
 @param handler The block that execute when the user selects the action.
 @return a ZANotifyAction object
 */
- (instancetype)initWithTitle:(NSString *)title
                         type:(ZANotificationActionType)type
                      handler:(void (^)(ZANotifyAction *action))handler;

@end
