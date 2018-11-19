//
//  CCLoadingDots.m
//  CCLoading
//
//  Created by demoncraz on 2018/11/15.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import "CCLoadingDots.h"

static CGFloat kCCLoadingDotsWidth = 6.0;

@interface CCLoadingDots ()

@property (nonatomic, strong) NSMutableArray<CALayer *> *layers;
@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@implementation CCLoadingDots

- (NSMutableArray<CALayer *> *)layers {
    if (_layers == nil) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    //draw three dots
    CGFloat x = 0;
    CGFloat wh = kCCLoadingDotsWidth;
    CGFloat y = self.frame.size.width * 0.5 - wh * 0.5;
    CGFloat distance = (self.frame.size.width - wh * 3) / 2;
    for (NSInteger i = 0; i < 3; i ++) {
        x = i * (distance + wh);
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.dotColor ? self.dotColor.CGColor : [UIColor lightGrayColor].CGColor;
        layer.frame = CGRectMake(x, y, wh, wh);
        layer.cornerRadius = wh * 0.5;
        [self.layer addSublayer:layer];
        [self.layers addObject:layer];
    }
}

- (void)setProgress:(CGFloat)progress { 
    if (self.isAnimating) return;
    [super setProgress:progress];
    NSInteger showLevel = 0;
    if (progress >= 0.33 && progress < 0.66) {
        showLevel = 1;
    } else if (progress >= 0.66 && progress < 1) {
        showLevel = 2;
    } else if (progress >= 1) {
        showLevel = 3;
        [self startLoading];
    }
    for (NSInteger i = 0; i < self.layers.count; i++) {
        CALayer *layer = self.layers[i];
        [UIView animateWithDuration:0.25 animations:^{
            layer.hidden = i >= showLevel;
        } completion:nil];
    }
    
}

- (void)startLoading {
    if (!self.animating) {
        NSInteger i = 0;
        for (CALayer *layer in self.layers) {
            CGPoint position = layer.position;
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.animations = @[[self translateAnimationWithCurrentPosition:position], [self scaleAnimation]];
            group.duration = 1.6;
            group.repeatCount = MAXFLOAT;
            group.beginTime = CACurrentMediaTime() + i * 0.15;
            [layer addAnimation:group forKey:nil];
            i ++;
        }
        self.animating = YES;
    }
}

- (void)endLoading {
    for (CALayer *layer in self.layers) {
        [layer removeAllAnimations];
    }
    self.animating = NO;
}

- (CAAnimation *)scaleAnimation {
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@1, @0.7, @1, @1, @1, @1, @1];
    return scale;
}

- (CAAnimation *)translateAnimationWithCurrentPosition:(CGPoint)position {
    CAKeyframeAnimation *translate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *value1 = [NSValue valueWithCGPoint:position];
    NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(position.x, position.y - 10)];
    translate.values = @[value1, value2, value1, value1, value1, value1, value1];
    return translate;
}

- (CABasicAnimation *)createAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    return animation;
}

#pragma mark - Public configuration
- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    for (CALayer *layer in self.layers) {
        layer.backgroundColor = dotColor.CGColor;
    }
}

@end
