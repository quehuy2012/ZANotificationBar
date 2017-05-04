//
//  ZANotificationDetailView.h
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZANotificationBarView : UIView

@property (nonatomic, readwrite) NSArray<ZANotifyAction *> *actions;

@property (nonatomic, readwrite) UILabel *headerLabel;
@property (nonatomic, readwrite) UILabel *bodyLabel;
@property (nonatomic, readwrite) UIImageView *appIcon;
@property (nonatomic, readwrite) UIView *notificationStyleIndicator;
@property (nonatomic, readwrite) UIVisualEffectView *contentVisualEffectView;
@property (nonatomic, readwrite) UIVisualEffectView *headerVisualEffectView;

@property (nonatomic, readwrite) CGFloat dismissLabelAlpha;
@property (nonatomic, readwrite) BOOL dismissLimitReached;

#pragma mark - Detailed Banner Views

@property (nonatomic, readonly) UIScrollView *scrollView;

/**
 The view which containing message banner and button action
 */
@property (nonatomic, readonly) UIView *mainView;

@property (nonatomic, readonly) UILabel *dismissLabel;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UITextView *messageTextView;
@property (nonatomic, readonly) UIToolbar *toolBar;
@property (nonatomic, readonly) UIVisualEffectView *backgroundView;
@property (nonatomic, readonly) UIVisualEffectView *notificationActionView;

- (void)didSelectMessage:(UITapGestureRecognizer *)tapGesture;
@end
