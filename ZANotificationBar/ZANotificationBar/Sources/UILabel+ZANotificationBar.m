//
//  UILabel+ZANotificationBar.m
//  ZANotificationBar
//
//  Created by CPU11713 on 5/5/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "UILabel+ZANotificationBar.h"

@implementation UILabel (ZANotificationBar)

- (CGFloat)heightToFit:(NSString *)string width:(CGFloat)width {
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14] };
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height;
}

- (void)resizeHeightToFit {
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14] };
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGRect newFrame = self.frame;
    newFrame.size.height = rect.size.height;
    self.frame = newFrame;
}

@end
