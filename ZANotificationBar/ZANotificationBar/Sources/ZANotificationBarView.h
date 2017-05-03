//
//  ZANotificationDetailView.h
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZANotificationBarView : UIView

@property (nonatomic, readwrite) UILabel *headerLabel;
@property (nonatomic, readwrite) UILabel *bodyLabel;
@property (nonatomic, readwrite) UIImageView *appIcon;
@property (nonatomic, readwrite) UIView *notificationStyleIndicator;
@property (nonatomic, readwrite) UIVisualEffectView *contentVisualEffectView;
@property (nonatomic, readwrite) UIVisualEffectView *headerVisualEffectView;

@property (nonatomic, readwrite) CGFloat dismissLabelAlpha;
@property (nonatomic, readwrite) BOOL dismissLimitReached;

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIView *mainView;
@property (nonatomic, readonly) UILabel *dismissLabel;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UITextView *notificationMessage;
@property (nonatomic, readonly) UIToolbar *toolBar;
@property (nonatomic, readonly) UIVisualEffectView *backgroundView;
@property (nonatomic, readonly) UIVisualEffectView *notificationActionView;

@end
