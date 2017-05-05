//
//  UILabel+ZANotificationBar.h
//  ZANotificationBar
//
//  Created by CPU11713 on 5/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZANotificationBar)

- (CGFloat)heightToFit:(NSString *)string width:(CGFloat)width;
- (void)resizeHeightToFit;

@end
