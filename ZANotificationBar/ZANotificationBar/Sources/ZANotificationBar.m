//
//  ZANotificationBar.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ZANotificationBar.h"
#import "ZANotificationBarView.h"
#import "ZANotifyAction.h"

#define WINDOW_WIDTH [UIApplication sharedApplication].keyWindow.bounds.size.width
#define APP_DELEGATE [UIApplication sharedApplication]
#define BAR_HEIGHT 100

@interface ZANotificationBar ()

@property (nonatomic, readwrite) CGFloat height;

@property (nonatomic, readwrite) NSMutableArray<ZANotifyAction *> *internalActions;

@property (nonatomic, readwrite) NSTimer *timer;

@property (nonatomic, readwrite) BOOL showNotificationInDetail;

@end


@implementation ZANotificationBar

#pragma mark - Init

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               preferredStyle:(ZANotificationStyle)preferredStyle
                      handler:(void (^)(BOOL))handler {
    if (self = [super init]) {
        _internalActions = [NSMutableArray array];
        _handler = handler;
        _displayDuration = 5.0;
        _showNotificationInDetail = YES;
        
        if (APP_DELEGATE.keyWindow.subviews) {
            [self setUpNotificationBarWithTitle:title message:message notificationStyle:preferredStyle];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setUpNotificationBarWithTitle:title message:message notificationStyle:preferredStyle];
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

- (void)setUpNotificationBarWithTitle:(NSString *)title
                              message:(NSString *)message
                    notificationStyle:(ZANotificationStyle)notificationStyle {
    for (UIView *subView in APP_DELEGATE.keyWindow.subviews) {
        // Clear old notification from queue
        if ([subView isKindOfClass:[ZANotificationBarView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    CGRect frame = CGRectMake(0, -BAR_HEIGHT, WINDOW_WIDTH, BAR_HEIGHT);
    self.notificationBar = [[ZANotificationBarView alloc] initWithFrame:frame];
    self.notificationBar.translatesAutoresizingMaskIntoConstraints = NO;
    
#warning line 241 bên swift
    switch (notificationStyle) {
        case ZANotificationStyleDetail:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Getters

- (NSArray *)actions {
    return [_internalActions copy];
}

#pragma mark - Publics

- (void)notoficationSoundFromName:(NSString *)name ofType:(NSString *)type vibrate:(BOOL)vibrate {
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
    [self.internalActions addObject:action];
}

- (void)hideNotification:(UIButton *)sender {
    if (self.notificationBar) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = weakSelf.notificationBar.frame;
            frame.origin = CGPointMake(0, -BAR_HEIGHT);
            weakSelf.notificationBar.frame = frame;
        } completion:^(BOOL finished) {
            [weakSelf.notificationBar removeFromSuperview];
            APP_DELEGATE.keyWindow.windowLevel = 0.0;
        }];
    }
}

@end
