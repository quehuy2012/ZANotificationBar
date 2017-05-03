//
//  ZANotificationDetailView.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ZANotificationBarView.h"
#import "Masonry.h"

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

#pragma mark - Setup notfication bar

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
    _notificationMessage = [[UITextView alloc] init];
    _notificationActionView = [[UIVisualEffectView alloc] init];
    _backgroundView = [[UIVisualEffectView alloc] init];
    
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupView {
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

#pragma mark - Open in detail


#pragma mark - Notification center

- (void)keyboardWillShow:(NSNotification *)notification {
    
}

- (void)keyboardwillHide:(NSNotification *)notification {
    
}

@end
