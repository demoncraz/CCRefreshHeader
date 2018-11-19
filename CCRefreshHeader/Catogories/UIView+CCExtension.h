//
//  UIView+Frame.h
//  qtec_app
//
//  Created by Steve on 2017/6/6.
//  Copyright © 2017年 Steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGFloat)cc_x;
- (void)setCc_x:(CGFloat)x;

- (CGFloat)cc_y;
- (void)setCc_y:(CGFloat)y;

- (CGFloat)cc_width;
- (void)setCc_width:(CGFloat)width;

- (CGFloat)cc_height;
- (void)setCc_height:(CGFloat)height;

- (CGFloat)cc_centerX;
- (void)setCc_centerX:(CGFloat)centerX;

- (CGFloat)cc_centerY;
- (void)setCc_centerY:(CGFloat)centerY;

@end
