//
//  ZANotificationDetailView.h
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@class ZANotificationBarContext;

@interface ZANotificationBarView : UIView

@property (nonatomic, readwrite) ZANotificationBarContext *context;

#pragma mark - Default NotficationBar Views

@property (nonatomic, readwrite) UIView *notificationMessageView;
@property (nonatomic, readwrite) UILabel *headerLabel;
@property (nonatomic, readwrite) UILabel *bodyLabel;
@property (nonatomic, readwrite) UIImageView *appIcon;
@property (nonatomic, readwrite) UIView *notificationStyleIndicator;
@property (nonatomic, readwrite) UIVisualEffectView *contentVisualEffectView;
@property (nonatomic, readwrite) UIVisualEffectView *headerVisualEffectView;

#pragma mark - Variable

@property (nonatomic, readwrite) CGFloat dismissLabelAlpha;
@property (nonatomic, readwrite) BOOL dismissLimitReached;
@property (nonatomic, readwrite) MASConstraint *toolBarBottomConstraint;




- (instancetype)initWithContext:(ZANotificationBarContext *)context;
- (void)didSelectMessage:(UITapGestureRecognizer *)tapGesture;

+ (instancetype)context:(ZANotificationBarContext *)context;
@end

typedef NS_ENUM(NSInteger, PanGestureDirection) {
    PanGestureDirectionUp = -1,
    PanGestureDirectionDown = 1
};
