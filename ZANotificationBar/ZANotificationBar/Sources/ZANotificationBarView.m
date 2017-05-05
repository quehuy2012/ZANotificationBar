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
#import "ZANotificationBarContext.h"
#import "UILabel+ZANotificationBar.h"
#import "NSString+Character.h"

@interface ZANotificationBarView ()

@property (nonatomic, readwrite) UIView *detailedBanner;

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
    [self setupNotificationActionView];
    
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
    titleLabel.text = self.context.appName;
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
    if (self.context.appIconName.characterCount != 0) {
        appIconImageView.image = [UIImage imageNamed:self.context.appIconName];
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
    
    [self.detailedBanner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.detailedBanner.superview);
        make.height.greaterThanOrEqualTo(@20);
        make.top.equalTo(self.dismissLabel.mas_bottom).with.offset(8);
        make.bottom.lessThanOrEqualTo(self.detailedBanner.superview.mas_bottom).with.offset(30);
    }];
    
    [self.notificationActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.notificationActionView.superview).with.offset(8);
        make.bottom.lessThanOrEqualTo(self.notificationActionView.superview.mas_bottom).with.offset(10);
        make.width.greaterThanOrEqualTo(@0);
    }];

    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageTextView.superview.mas_left).with.offset(15);
        make.right.equalTo(self.messageTextView.superview.mas_right).with.offset(-15);
    }]
    
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(self.mainView.mas_top).with.offset(5);
        make.bottom.equalTo(self.toolBar.superview.mas_bottom).with.priorityLow();
    }];
    
    
    
    [self.dismissLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dismissLabel.superview.mas_top);
    }];
    
    }

- (void)setupNotificationActionView {
    [self sortActions];
    
    self.notificationActionView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.notificationActionView.layer.cornerRadius = 14.0;
    self.notificationActionView.clipsToBounds = YES;
    [self.mainView addSubview:self.notificationActionView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.notificationActionView addSubview:tableView];
    
    CGFloat tableViewHeight = 0;
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = self.messageTextView.text;
    CGFloat messageHeight = self.context.actions.count * 50 + [messageLabel heightToFit:self.messageTextView.text width:[UIApplication sharedApplication].keyWindow.frame.size.width];
    
    if (messageHeight > [UIApplication sharedApplication].keyWindow.frame.size.height - 50) {
        tableView.scrollEnabled = self.context.actions.count > 4 ? YES : NO;
        self.messageTextView.scrollEnabled = YES;
        tableViewHeight = MIN(200, self.context.actions.count * 50);
    } else {
        tableView.scrollEnabled = NO;
        tableViewHeight = self.context.actions.count * 50;
    }
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableView.superview);
        make.height.mas_equalTo(tableViewHeight);
    }];
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
    
}

- (void)tapToClose:(UITapGestureRecognizer *)tapGesture {
    
}

- (void)handleDetailedPanGesture:(UIPanGestureRecognizer *)panGesture {
    
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


@end
