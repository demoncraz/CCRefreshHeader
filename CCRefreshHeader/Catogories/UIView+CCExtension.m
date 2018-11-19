//
//  UIView+Frame.m
//  qtec_app
//
//  Created by Steve on 2017/6/6.
//  Copyright © 2017年 Steve. All rights reserved.
//

#import "UIView+CCExtension.h"

@implementation UIView (Frame)

- (CGFloat)cc_x {
    return self.frame.origin.x;
}

- (void)setCc_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)cc_y {
    return self.frame.origin.y;
}

- (void)setCc_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)cc_width {
    return self.frame.size.width;
}

- (void)setCc_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)cc_height {
    return self.frame.size.height;
}

- (void)setCc_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)cc_centerX {
    return self.center.x;
}

- (void)setCc_centerX:(CGFloat)centerX {
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)cc_centerY {
    return self.center.y;
}

- (void)setCc_centerY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}


@end
