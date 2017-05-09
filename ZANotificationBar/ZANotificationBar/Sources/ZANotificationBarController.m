//
//  ZANotificationBar.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "Masonry.h"
#import "ZANotificationBarController.h"
#import "ZANotificationBarView.h"
#import "ZANotificationBarContext.h"
#import "ZANotifyAction.h"
#import "NSString+Character.h"



@interface ZANotificationBarController ()

@property (nonatomic, readwrite) CGFloat height;

@property (nonatomic, readwrite) NSTimer *timer;

@end


@implementation ZANotificationBarController

#pragma mark - Init

- (instancetype)initWithTitle:(NSString *)title
                        message:(NSString *)message
               preferredStyle:(ZANotificationStyle)preferredStyle
                      handler:(void (^)(BOOL))handler {
    if (self = [super init]) {
        _displayDuration = 5.0;
        _context = [[ZANotificationBarContext alloc] init];
        _context.didSelectHandler = handler;
        
        if (APP_DELEGATE.keyWindow.subviews) {
            [self setUpNotificationBarWithHeader:title body:message notificationStyle:preferredStyle];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setUpNotificationBarWithHeader:title body:message notificationStyle:preferredStyle];
            });
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_displayDuration != 0) {
                if (_timer) {
                    [_timer invalidate];
                }
                _timer = [NSTimer scheduledTimerWithTimeInterval:_displayDuration - 1.0 target:self selector:@selector(hideNotification:) userInfo:nil repeats:NO];
            }
        });
    }
    return self;
}

- (void)setUpNotificationBarWithHeader:(NSString *)header
                                  body:(NSString *)body
                    notificationStyle:(ZANotificationStyle)notificationStyle {
    for (UIView *subView in APP_DELEGATE.keyWindow.subviews) {
        // Clear old notification from queue
        if ([subView isKindOfClass:[ZANotificationBarView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    CGRect frame = CGRectMake(0, -BAR_HEIGHT, WINDOW_WIDTH, BAR_HEIGHT);
    self.notificationBar = [[ZANotificationBarView alloc] initWithFrame:frame];
    self.notificationBar.context = self.context;
    self.notificationBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    switch (notificationStyle) {
        case ZANotificationStyleDetail:
            self.notificationBar.notificationStyleIndicator.hidden = NO;
            self.context.showNotificationInDetail = YES;
            break;
        default:
            self.notificationBar.notificationStyleIndicator.hidden = YES;
            self.context.showNotificationInDetail = NO;
            break;
    }
    
    if ([header characterCount] == 0) {
        self.notificationBar.bodyLabel.text = body;
    }
    else {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",header,body]];
        [attributeString addAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:15] } range:NSMakeRange(0, [header characterCount])];
        self.notificationBar.bodyLabel.attributedText = attributeString;
    }
    
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    self.context.appName = infoDictionary[@"CFBundleName"];
    self.notificationBar.headerLabel.text = self.context.appName;
    
    if (infoDictionary[@"CFBundleIcons"]) {
        infoDictionary = infoDictionary[@"CFBundleIcons"][@"CFBundlePrimaryIcon"];
        self.context.appIconName = ((NSArray *)infoDictionary[@"CFBundleIconFiles"]).firstObject;
        self.notificationBar.appIcon.image = [UIImage imageNamed:self.context.appIconName];
    } else {
        self.notificationBar.appIcon.layer.borderColor = [UIColor grayColor].CGColor;
        self.notificationBar.appIcon.layer.borderWidth = 1.0;
        
        self.context.appIconName = @"";
        NSLog(@"Not found app icon");
    }
    
    self.notificationBar.appIcon.layer.cornerRadius = 5.0;
    self.notificationBar.appIcon.clipsToBounds = YES;
    
#warning not sure is headerVisual or contentVisual
    self.notificationBar.contentVisualEffectView.layer.cornerRadius = 14.0;
    self.notificationBar.contentVisualEffectView.clipsToBounds = YES;
    
       
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.notificationBar.frame = CGRectMake(0, 0, WINDOW_WIDTH, BAR_HEIGHT);
    } completion:nil];
    
    APP_DELEGATE.keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
    [APP_DELEGATE.keyWindow addSubview:self.notificationBar];
    
    [self.notificationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(self.notificationBar.superview);
        make.height.equalTo(@100);
    }];
}

#pragma mark - Publics

- (void)notificationSoundWithName:(NSString *)name ofType:(NSString *)type vibrate:(BOOL)vibrate {
    if (vibrate) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if (!path) {
        NSLog(@"File name or type doesn't exists");
        AudioServicesPlaySystemSound(1054);
        return;
    }
    
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
    if (error) {
        NSLog(@"Unable to play sound");
        AudioServicesPlaySystemSound(1054);
    }
    
}

- (void)addAction:(ZANotifyAction *)action {
    [self.context addAction:action];
}


@end
