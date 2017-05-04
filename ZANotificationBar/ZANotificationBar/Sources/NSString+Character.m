//
//  NSString+Character.m
//  ZANotificationBar
//
//  Created by CPU11713 on 5/4/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "NSString+Character.h"

@implementation NSString (Character)

- (NSUInteger)characterCount {
    NSUInteger cnt = 0;
    NSUInteger index = 0;
    while (index < self.length) {
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:index];
        cnt++;
        index += range.length;
    }
    
    return cnt;
}

@end
