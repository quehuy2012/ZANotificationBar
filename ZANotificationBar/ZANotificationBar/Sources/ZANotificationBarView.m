//
//  ZANotificationDetailView.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZANotificationBarView.h"
#import "ZANotifyAction.h"
#import "ZANotificationBar.h"
#import "Masonry.h"
#import "NSString+Character.h"

@interface ZANotificationBarView ()

@property (nonatomic, readwrite) UIView *detailedBanner;

@end


@implementation ZANotificationBarView

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"Dealloc view");
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

- (void)commonInit {
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
    
    [self setupNotificationBar];
    
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
    [self.backgroundView addSubview:self.mainView];
    
    self.notificationStyleIndicator.layer.cornerRadius = 3.0;
    self.notificationStyleIndicator.alpha = 0.5;
    
    [self setupBackgroundView];
    [self setupMainView:body];
    
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
    
    [self.backgroundView addGestureRecognizer:panGesture];
    [self.backgroundView addGestureRecognizer:tapToCloseGesture];
    self.backgroundView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    
    self.toolBar.hidden = YES;
    [self.backgroundView addSubview:self.toolBar];
}

- (void)setupMainView:(NSString *)body {
    self.mainView.backgroundColor = [UIColor clearColor];
    
    // Dismiss label
    self.dismissLabel.text = @"DISMISS";
    self.dismissLabel.textAlignment = NSTextAlignmentCenter;
    self.dismissLabel.textColor = [UIColor whiteColor];
    self.dismissLabel.font = [UIFont systemFontOfSize:14];
    self.dismissLabel.alpha = 0.0;
    
    [self.mainView addSubview:self.dismissLabel];
    
    // Notification banner
    
    self.detailedBanner.backgroundColor = [UIColor whiteColor];
    self.detailedBanner.layer.cornerRadius = 14.0;
    self.detailedBanner.clipsToBounds = YES;
    
    UITapGestureRecognizer *selectMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectMessage:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDetailedPanGesture:)];
    [self.detailedBanner addGestureRecognizer:selectMessageGesture];
    [self.detailedBanner addGestureRecognizer:panGesture];
    
    [self.mainView addSubview:self.detailedBanner];
    
    // Message title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = kAppName;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.detailedBanner addSubview:titleLabel];
    
    // Message body
    NSArray<NSString *> *tempContainer = [body componentsSeparatedByString:@"\n"];
    NSString *rangeStr = tempContainer.firstObject;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:body];
    if ([body containsString:@"\n"]) {
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:15] }
                                 range:NSMakeRange(0, [rangeStr characterCount])];
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] }
                                 range:NSMakeRange([rangeStr characterCount], tempContainer[1].characterCount)];
    } else {
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] }
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
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    
    [self.detailedBanner addSubview:separatorView];
    
    // AppIcon
    UIImageView *appIconImageView = [[UIImageView alloc] init];
    if (kAppIconName.characterCount != 0) {
        appIconImageView.image = [UIImage imageNamed:kAppIconName];
    } else {
        appIconImageView.layer.borderColor = [UIColor grayColor].CGColor;
        appIconImageView.layer.borderWidth = 1.0;
    }
    
    appIconImageView.layer.cornerRadius = 5.0;
    appIconImageView.clipsToBounds = YES;
    
    [self.detailedBanner addSubview:appIconImageView];
    
    // Close Button
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailedBanner addSubview:closeButton];
}

- (void)setupDetailedNotificationBarLayout {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backgroundView.superview);
    }];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.mainView.superview);
        make.bottom.lessThanOrEqualTo(self.mainView.superview.mas_bottom).with.offset(10);
        make.height.equalTo(@200).with.priorityLow();
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.mainView.mas_top).with.offset(5);
        make.bottom.equalTo(self.toolBar.superview.mas_bottom).with.priorityLow();
    }];
    
    [self.detailedBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.detailedBanner.superview);
        make.height.greaterThanOrEqualTo(@20);
        make.top.equalTo(self.dismissLabel.mas_bottom).with.offset(8);
        make.bottom.lessThanOrEqualTo(self.detailedBanner.superview).with.offset(30);
    }];
    
    [self.dismissLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dismissLabel.superview.mas_top);
    }];
}

- (void)createNotificationActionView {
    
}

#pragma mark - UI Event
- (void)closeMessage:(UIButton *)sender {
    
}

#pragma mark - GestureRecognizer

- (void)didSelectMessage:(UITapGestureRecognizer *)tapGesture {
    
}

- (void)tapToClose:(UITapGestureRecognizer *)tapGesture {
    
}

- (void)handleDetailedPanGesture:(UIPanGestureRecognizer *)panGesture {
    
}

#pragma mark - Notification center

- (void)keyboardWillShow:(NSNotification *)notification {
    
}

- (void)keyboardwillHide:(NSNotification *)notification {
    
}

#pragma mark - Support

- (void)sortActions {
     
}

@end
