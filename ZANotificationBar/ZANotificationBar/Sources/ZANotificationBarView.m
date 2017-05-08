//
//  ZANotificationDetailView.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//


#import "ZANotificationBarView.h"
#import "ZANotifyAction.h"
#import "ZANotificationBarController.h"
#import "ZANotificationBarContext.h"
#import "UILabel+ZANotificationBar.h"
#import "NSString+Character.h"
#import "Constants.h"

@interface ZANotificationBarView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, readwrite) UIView *detailedBanner;
@property (nonatomic, readwrite) UILabel *titleLabel;
@property (nonatomic, readwrite) UIView *separatorView;
@property (nonatomic, readwrite) UIButton *closeButton;
@property (nonatomic, readwrite) UIImageView *detailedBannerAppIconImageView;
@property (nonatomic, readwrite) UITableView *actionsTableView;

@property (nonatomic, readwrite) UIPanGestureRecognizer *panGesture;

@end


@implementation ZANotificationBarView

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"Dealloc view");
}

+ (instancetype)context:(ZANotificationBarContext *)context {
    return [[ZANotificationBarView alloc] initWithContext:context];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithContext:(ZANotificationBarContext *)context {
    self = [self initWithFrame:CGRectZero];
    _context = context;
    return self;
}

- (void)commonInit {
    _context = [[ZANotificationBarContext alloc] init];
    
    _headerLabel = [[UILabel alloc] init];
    _bodyLabel = [[UILabel alloc] init];
    _appIcon = [[UIImageView alloc] init];
    _notificationStyleIndicator = [[UIView alloc] init];
    _contentVisualEffectView = [[UIVisualEffectView alloc] init];
    _headerVisualEffectView = [[UIVisualEffectView alloc] init];
    
    _scrollView = [[UIScrollView alloc] init];
    _textField = [[UITextField alloc] init];
    _mainView = [[UIView alloc] init];
    _dismissLabel = [[UILabel alloc] init];
    _toolBar = [[UIToolbar alloc] init];
    _messageTextView = [[UITextView alloc] init];
    _notificationActionView = [[UIVisualEffectView alloc] init];
    _backgroundView = [[UIVisualEffectView alloc] init];
    _detailedBanner = [[UIView alloc] init];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:_panGesture];
    
    [self setupNotificationBar];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Setup notfication bar

- (void)setupNotificationBar {
    [self addSubview:self.contentVisualEffectView];
    [[self.contentVisualEffectView contentView] addSubview:self.headerVisualEffectView];
    [[self.contentVisualEffectView contentView] addSubview:self.bodyLabel];
    [[self.contentVisualEffectView contentView] addSubview:self.notificationStyleIndicator];
    
    [[self.headerVisualEffectView contentView] addSubview:self.appIcon];
    [[self.headerVisualEffectView contentView] addSubview:self.headerLabel];

    
    [self setupContentVisualEffectView];
    
    // Setup header
    [self setupHeaderVisualEffectView];
    [self setupAppIcon];
    [self setupHeaderLabel];
    
    [self setupBodyLabel];
    [self setupNotificationStyleIndicator];
}

- (void)setupContentVisualEffectView {
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIEdgeInsets padding = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.contentVisualEffectView.effect = blurEffect;
    [self.contentVisualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentVisualEffectView.superview).with.insets(padding);
    }];
}

- (void)setupHeaderVisualEffectView {
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    self.headerVisualEffectView.effect = blurEffect;
    [self.headerVisualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([self.contentVisualEffectView contentView].mas_top);
        make.left.equalTo([self.contentVisualEffectView contentView].mas_left);
        make.right.equalTo([self.contentVisualEffectView contentView].mas_right);
        make.height.equalTo(@30);
    }];
}

- (void)setupAppIcon {
    self.appIcon.image = [UIImage imageNamed:@"Icon"];
    
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([self.headerVisualEffectView contentView].mas_left).with.offset(8);
        make.centerY.equalTo([self.headerVisualEffectView contentView].mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
}

- (void)setupHeaderLabel {
    self.headerLabel.text = @"App name";
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.appIcon.mas_right).with.offset(8);
        make.right.equalTo(self.headerLabel.superview.mas_right).with.offset(8);
        make.centerY.equalTo(self.headerLabel.superview.mas_centerY);
        make.height.equalTo(@20);
    }];
}

- (void)setupBodyLabel {
    self.bodyLabel.text = @"GitHub explore the week of Apr 25 - May 2. Explore this week on GitHub";
    
    [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bodyLabel.superview.mas_left).with.offset(8);
        make.right.equalTo(self.bodyLabel.superview.mas_right).with.offset(-8);
        make.top.equalTo(self.headerVisualEffectView.mas_bottom).with.offset(8);
        make.bottom.equalTo(self.notificationStyleIndicator.mas_top).with.offset(-8);
    }];
}

- (void)setupNotificationStyleIndicator {
    self.notificationStyleIndicator.backgroundColor = [UIColor grayColor];
    
    [self.notificationStyleIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.notificationStyleIndicator.superview.mas_centerX);
        make.bottom.equalTo(self.notificationStyleIndicator.superview.mas_bottom).with.offset(-8);
        make.width.equalTo(@40);
        make.height.equalTo(@3);
    }];
}

#pragma mark - Setup detailed notification bar

- (void)setupDetailedNotificationBarWithHeader:(NSString *)header
                                          body:(NSString *)body
                                       actions:(NSArray<ZANotifyAction *> *)actions {
    self.notificationStyleIndicator.layer.cornerRadius = 3.0;
    self.notificationStyleIndicator.alpha = 0.5;
    
    [self setupBackgroundView];
    [self setupMainView:body];
    [self setupNotificationActionView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    
    self.toolBar.hidden = YES;
    [self.backgroundView addSubview:self.toolBar];
    
    // Autolayout
    [self setupDetailedNotificationBarLayout];
    
    // Animate
    self.mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.mainView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.mainView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)setupBackgroundView {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectMessage:)];
    UITapGestureRecognizer *tapToCloseGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose:)];
    tapToCloseGesture.delegate = self;
    
    [self.backgroundView addGestureRecognizer:panGesture];
    [self.backgroundView addGestureRecognizer:tapToCloseGesture];
    self.backgroundView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
}

- (void)setupMainView:(NSString *)body {
    //[self.backgroundView addSubview:self.mainView];
    
    self.mainView.backgroundColor = [UIColor clearColor];
    
    // Notification banner
    self.detailedBanner = [[UIView alloc] init];
    self.detailedBanner.backgroundColor = [UIColor whiteColor];
    self.detailedBanner.layer.cornerRadius = 14.0;
    self.detailedBanner.clipsToBounds = YES;
    
    
    
    UITapGestureRecognizer *selectMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectMessage:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDetailedPanGesture:)];
    [self.detailedBanner addGestureRecognizer:selectMessageGesture];
    [self.detailedBanner addGestureRecognizer:panGesture];
    
    [self.mainView addSubview:self.detailedBanner];
    
    [self.backgroundView addSubview:self.mainView];
    
    // Dismiss label
    self.dismissLabel.text = @"DISMISS";
    self.dismissLabel.textAlignment = NSTextAlignmentCenter;
    self.dismissLabel.textColor = [UIColor whiteColor];
    self.dismissLabel.font = [UIFont systemFontOfSize:14];
    self.dismissLabel.alpha = 0.0;
    
    [self.mainView addSubview:self.dismissLabel];
    
    // Message title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.context.appName;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.detailedBanner addSubview:self.titleLabel];
    
    // Message body
    NSArray<NSString *> *tempContainer = [body componentsSeparatedByString:@"\n"];
    NSString *rangeStr = tempContainer.firstObject;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:body];
    if ([body containsString:@"\n"]) {
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:13] }
                                 range:NSMakeRange(0, [rangeStr characterCount])];
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13] }
                                 range:NSMakeRange([rangeStr characterCount], [tempContainer[1]characterCount])];
    } else {
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13] }
                                 range:NSMakeRange(0, body.characterCount)];
    }
    
    self.messageTextView.font = [UIFont systemFontOfSize:25];
    self.messageTextView.backgroundColor = [UIColor clearColor];
    self.messageTextView.textColor = [UIColor blackColor];
    self.messageTextView.showsHorizontalScrollIndicator = NO;
    self.messageTextView.scrollEnabled = NO;
    self.messageTextView.editable = NO;
    self.messageTextView.attributedText = attributeString;
    
    [self.detailedBanner addSubview:self.messageTextView];
    
    // Separator Line
    self.separatorView = [[UIView alloc] init];
    self.separatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.detailedBanner addSubview:self.separatorView];
    
    // AppIcon
    self.detailedBannerAppIconImageView = [[UIImageView alloc] init];
    if (self.context.appIconName.characterCount != 0) {
        self.detailedBannerAppIconImageView.image = [UIImage imageNamed:self.context.appIconName];
    } else {
        self.detailedBannerAppIconImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.detailedBannerAppIconImageView.layer.borderWidth = 1.0;
    }
    
    self.detailedBannerAppIconImageView.layer.cornerRadius = 5.0;
    self.detailedBannerAppIconImageView.clipsToBounds = YES;
    
    [self.detailedBanner addSubview:self.detailedBannerAppIconImageView];
    
    // Close Button
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailedBanner addSubview:self.closeButton];
}

- (void)setupDetailedNotificationBarLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView.superview);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.superview).with.offset(16);
        make.right.equalTo(self.mainView.superview).with.offset(-16);
        make.top.equalTo(self.mainView.superview).with.offset(20);
        make.bottom.lessThanOrEqualTo(self.mainView.superview.mas_bottom).with.offset(-10);
        make.height.equalTo(@200).with.priorityLow();
    }];
    
    [self.detailedBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailedBanner.superview.mas_left).with.offset(8);
        make.right.equalTo(self.detailedBanner.superview.mas_right).with.offset(-8);
        make.top.equalTo(self.dismissLabel.mas_bottom).with.offset(8);
        make.bottom.lessThanOrEqualTo(self.detailedBanner.superview.mas_bottom).with.offset(-30);
        
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.notificationActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.notificationActionView.superview.mas_left).with.offset(8);
        make.right.equalTo(self.notificationActionView.superview.mas_right).with.offset(-8);
        make.top.equalTo(self.detailedBanner.mas_bottom).with.offset(10);
        make.bottom.lessThanOrEqualTo(self.notificationActionView.superview.mas_bottom).with.offset(-10);
        make.height.greaterThanOrEqualTo(@0);
    }];

#warning
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = self.messageTextView.text;
    CGFloat expectedContentHeight = self.context.actions.count * 50 + [messageLabel heightToFit:messageLabel.text width:[UIApplication sharedApplication].keyWindow.frame.size.width];
    CGFloat messageHeight;
    NSInteger priority;
    if (expectedContentHeight > ([UIApplication sharedApplication].keyWindow.frame.size.height - 50)) {
        messageHeight = [UIApplication sharedApplication].keyWindow.frame.size.height - self.context.actions.count < 4 ? self.context.actions.count * 50 : 200;
        priority = 750;
    } else {
        messageHeight = 30;
        priority = 250;
    }
    
    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageTextView.superview.mas_left).with.offset(15);
        make.right.equalTo(self.messageTextView.superview.mas_right).with.offset(-15);
        make.top.equalTo(self.separatorView.mas_bottom).with.offset(8);
        make.bottom.lessThanOrEqualTo(self.messageTextView.superview.mas_bottom).with.offset(-5);
        
        make.height.mas_equalTo(messageHeight).with.priority(priority);
    }];
    
    [self.self.detailedBannerAppIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailedBannerAppIconImageView.superview.mas_left).with.offset(10);
        make.top.equalTo(self.detailedBannerAppIconImageView.superview.mas_top).with.offset(15);
        make.width.and.height.equalTo(@20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailedBannerAppIconImageView.mas_right).with.offset(10);
        make.right.equalTo(self.closeButton.mas_left).with.offset(-10);
        make.top.equalTo(self.titleLabel.superview.mas_top).with.offset(15);
        make.height.equalTo(@20);
    }];
    
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separatorView.superview.mas_left).with.offset(8);
        make.right.equalTo(self.separatorView.superview.mas_right).with.offset(-8);
        make.height.equalTo(@1);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(8);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.closeButton.superview.mas_right).with.offset(-10);
        make.top.equalTo(self.closeButton.superview.mas_top).with.offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
    
    [self.dismissLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dismissLabel.superview.mas_left).with.offset(15);
        make.right.equalTo(self.dismissLabel.superview.mas_right).with.offset(-15);
        make.top.equalTo(self.dismissLabel.superview.mas_top);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.toolBar.superview);
        
        make.top.greaterThanOrEqualTo(self.mainView.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.toolBar.superview.mas_bottom).priorityLow();
    }];
    
    
    CGFloat tableViewHeight = 0;
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.text = self.messageTextView.text;
    CGFloat test = self.context.actions.count * 50 + [testLabel heightToFit:self.messageTextView.text width:[UIApplication sharedApplication].keyWindow.frame.size.width];
    
    if (test > [UIApplication sharedApplication].keyWindow.frame.size.height - 50) {
        self.actionsTableView.scrollEnabled = self.context.actions.count > 4 ? YES : NO;
        self.messageTextView.scrollEnabled = YES;
        tableViewHeight = MIN(200, self.context.actions.count * 50);
    } else {
        self.actionsTableView.scrollEnabled = NO;
        tableViewHeight = self.context.actions.count * 50;
    }
    
    NSLog(@"Table view height:%f", tableViewHeight);

    
    [self.actionsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.actionsTableView.superview);
        make.bottom.lessThanOrEqualTo(self.actionsTableView.superview);
        make.height.mas_equalTo(tableViewHeight).with.priorityHigh();
    }];
    
    [self.actionsTableView reloadData];
}

- (void)setupNotificationActionView {
    [self sortActions];
    
    self.notificationActionView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.notificationActionView.layer.cornerRadius = 14.0;
    self.notificationActionView.clipsToBounds = YES;
    [self.mainView addSubview:self.notificationActionView];
    
    self.actionsTableView = [[UITableView alloc] init];
    self.actionsTableView.backgroundColor = [UIColor clearColor];
    self.actionsTableView.dataSource = self;
    self.actionsTableView.delegate = self;
    self.actionsTableView.showsVerticalScrollIndicator = NO;
    self.actionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.notificationActionView addSubview:self.actionsTableView];
}

#pragma mark - UI Event
- (void)closeMessage:(UIButton *)sender {
    [self.context clearAction];
    [self.textField resignFirstResponder];
    [UIApplication sharedApplication].keyWindow.windowLevel = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.mainView.frame;
        frame.origin = CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height);
        self.mainView.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.backgroundView removeFromSuperview];
        } completion:nil];
    }];
}


#pragma mark - GestureRecognizer

- (void)didSelectMessage:(UITapGestureRecognizer *)tapGesture {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, -BAR_HEIGHT);
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [self closeMessage:nil];
    self.context.didSelectHandler(true);
}

- (void)tapToClose:(UITapGestureRecognizer *)tapGesture {
    [self closeMessage:nil];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint velocity = [panGesture velocityInView:self];
    CGPoint translation = [panGesture translationInView:self];
    
    UIView *target = panGesture.view;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            
            PanGestureDirection direction = velocity.y < 1.0 ? PanGestureDirectionUp : PanGestureDirectionDown;
            
            switch (direction) {
                case PanGestureDirectionUp:
                    target.center = CGPointMake(target.center.x, target.center.y + translation.y);
                    break;
                case PanGestureDirectionDown:
                    if (self.context.showNotificationInDetail) {
                        target.center = CGPointMake(target.center.x, target.center.y + translation.y);
                    }
                    break;
                default:
                    break;
            }
            
            [panGesture setTranslation:CGPointMake(0, 0) inView:self];
            
            if (target.frame.origin.y > target.frame.size.height) {
                [self removeFromSuperview];
                [self setupDetailedNotificationBarWithHeader:self.headerLabel.text body:self.bodyLabel.text actions:@[]];
                return;
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (target.frame.origin.y < -(self.contentVisualEffectView.frame.origin.y)) {
                APP_DELEGATE.keyWindow.windowLevel = 0.0;
                [self.context clearAction];
                [self removeFromSuperview];
                return;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = target.frame;
                frame.origin = CGPointMake(target.frame.origin.x, 10);
                target.frame = frame;
            }];
            
            break;
        }
        default:
            break;
    }
}

- (void)handleDetailedPanGesture:(UIPanGestureRecognizer *)panGesture {
    BOOL isLandScape = NO;
    CGPoint translation = [panGesture translationInView:self];
    CGPoint velocity = [panGesture velocityInView:self];
    CGFloat panVelocity;
    
    [panGesture setTranslation:CGPointMake(0, 0) inView:self];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            UIInterfaceOrientation orientation = APP_DELEGATE.statusBarOrientation;
            
            switch (orientation) {
                case UIInterfaceOrientationPortrait:
                    self.mainView.center = CGPointMake(self.mainView.center.x, self.mainView.center.y + translation.y / 5);
                    panVelocity = velocity.y;
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    self.mainView.center = CGPointMake(self.mainView.center.x, self.mainView.center.y + translation.x / 5);
                    panVelocity = velocity.x;
                    isLandScape = YES;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    self.mainView.center = CGPointMake(self.mainView.center.x, self.mainView.center.y + (-translation.x / 5));
                    panVelocity = -velocity.x;
                    isLandScape = YES;
                    break;
                default:
                    break;
            }
            
            PanGestureDirection direction = panVelocity < 1.0 ? PanGestureDirectionUp : PanGestureDirectionDown;
            
            switch (direction) {
                case PanGestureDirectionUp:
                    if (self.dismissLabel.alpha > 0.0) {
                        self.dismissLabelAlpha -= isLandScape ? 0.05 : 0.02;
                    } else if (self.dismissLabel.alpha <= 1.0 && self.dismissLimitReached) {
                        self.dismissLimitReached = NO;
                    }
                    
                    if (panVelocity > -1500) {
                        self.dismissLimitReached = NO;
                        self.dismissLabel.alpha = 0.0;
                    }
                    
                    break;
                case PanGestureDirectionDown:
                    if (self.dismissLabel.alpha < 1.0) {
                        self.dismissLabelAlpha += isLandScape ? 0.05: 0.02;
                    } else if (self.dismissLabel.alpha >= 1.0 && !self.dismissLimitReached) {
                        self.dismissLimitReached = YES;
                        self.dismissLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
                        
                        __weak typeof(self) weakSelf = self;
                        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            weakSelf.dismissLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                self.dismissLabel.transform = CGAffineTransformIdentity;
                            } completion:nil];
                        }];
                    }
                    
                    if (panVelocity > 2000) {
                        self.dismissLimitReached = YES;
                        self.dismissLabelAlpha = 1.0;
                    }
                    
                    break;
                default:
                    break;
            }
            
            self.dismissLabel.alpha = self.dismissLabelAlpha;
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.dismissLimitReached) {
                [self setCloseButton:nil];
                return;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.mainView.frame;
                frame.origin = CGPointMake(0, 0);
                self.mainView.frame = frame;
            }];
            
            self.dismissLimitReached = NO;
            self.dismissLabel.alpha = 0.0;
            self.dismissLabelAlpha = 0.0;
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - Notification center

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = ((NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    
    [UIView animateWithDuration:0.1 animations:^{
        if (self.toolBarBottomConstraint) {
            self.toolBarBottomConstraint.offset(-keyboardFrame.size.height);
            [self.backgroundView layoutIfNeeded];
        }
    }];
}

- (void)keyboardwillHide:(NSNotification *)notification {
    CGRect keyboardFrame = ((NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    
    [UIView animateWithDuration:0.1 animations:^{
        if (self.toolBarBottomConstraint) {
            self.toolBarBottomConstraint.offset(keyboardFrame.size.height);
            [self.backgroundView layoutIfNeeded];
        }
    }];
}

#pragma mark - Support

/**
 sort `GLNotifyAction` which have style ZANotificationActionTypeCancel to last index
 @note If multi ZANotificationActionTypeCancel is found, just only first `ZANotificationActionTypeCancel`  sort to last index, other `ZANotificationActionTypeCancel` will be removed.
 */
- (void)sortActions {
    NSMutableArray<ZANotifyAction *> *cancelActions = [NSMutableArray array];
    NSInteger index = 0;
    BOOL isCancelTypeFound = NO;
    
    for (ZANotifyAction *action in self.context.actions) {
        switch (action.actionType) {
            case ZANotificationActionTypeCancel:
                [self.context removeAction:action];
                index -= 1;
                if (!isCancelTypeFound) {
                    isCancelTypeFound = YES;
                    [cancelActions addObject:action];
                }
                break;
            case ZANotificationActionTypeOnlyTextInput:
                [self setupTextField:action senderTag:index];
                continue;
            default:
                break;
        }
        index += 1;
    }
    if (cancelActions.count != 0) {
        [self.context addAction:cancelActions.firstObject];
    }
}

- (void)setupTextField:(ZANotifyAction *)action senderTag:(NSInteger)senderTag {
    [UIView animateWithDuration:1.0 animations:^{
        self.notificationActionView.hidden = YES;
    } completion:^(BOOL finished) {
        [self.notificationActionView removeFromSuperview];
    }];
    
    self.textField.placeholder = action.actionTitle;
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = senderTag;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"Send" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *textFieldBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.textField];
    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.toolBar.hidden = NO;
    self.toolBar.items = @[textFieldBarButtonItem, sendBarButtonItem];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField.superview.mas_left).with.offset(8);
        make.right.equalTo(button.mas_left);
        make.height.equalTo(@30);
        make.top.and.bottom.equalTo(self.textField.superview).with.offset(8);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button.superview.mas_right);
        make.width.equalTo(@60);
        make.top.and.bottom.equalTo(button.superview).width.offset(8);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.backgroundView);
        self.toolBarBottomConstraint = make.bottom.equalTo(self.backgroundView.mas_bottom);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });
}

- (void)sendButtonPressed:(UIButton *)sender {
    ZANotifyAction *action = self.context.actions[sender.tag];
    
    if (!action.actionHandler) {
        [self closeMessage:sender];
        return;
    }
    
    action.textResponse = self.textField.text;
    action.actionHandler(action);
    [self closeMessage:sender];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.notificationActionView]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Number of row: %d", self.context.actions.count);
    return self.context.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZANotifyActionViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    
    // Add separator line
    CALayer *layer = [[CALayer alloc] init];
    layer.borderColor = [UIColor grayColor].CGColor;
    layer.borderWidth = 0.75;
    
    CGFloat width = MAX(APP_DELEGATE.keyWindow.frame.size.height, APP_DELEGATE.keyWindow.frame.size.width);
    layer.frame = CGRectMake(0, 49, width, 2);
    
    [cell.layer addSublayer:layer];
    cell.layer.masksToBounds = YES;
    
    ZANotifyAction *action = self.context.actions[indexPath.row];
    switch (action.actionType) {
        case ZANotificationActionTypeCancel:
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
            break;
        case ZANotificationActionTypeDestructive:
            cell.textLabel.textColor = [UIColor redColor];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = self.context.actions[indexPath.row].actionTitle;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZANotifyAction *action = self.context.actions[indexPath.row];
    switch (action.actionType) {
        case ZANotificationActionTypeCancel:
        case ZANotificationActionTypeDestructive:
        case ZANotificationActionTypeDefault:
            if (action.actionHandler) {
                action.actionHandler(action);
            }
            [self closeMessage:nil];
            break;
        case ZANotificationActionTypeTextInput:
            [self setupTextField:action senderTag:indexPath.row];
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
@end
