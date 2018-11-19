//
//  CCLoadingIndicator.m
//  CCLoading
//
//  Created by demoncraz on 2018/11/13.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import "CCLoadingIndicator.h"

static CGFloat kCCLoadingDefaultZoomScale = 1.3;
static NSString * const kCCLoadingRotateAnimationKey = @"com.steve.kCCLoadingRotateAnimationKey";

@interface CCLoadingIndicator ()

@property (nonatomic, strong) UIImageView *gradientImageView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGRect centerSquareRect;

@property (nonatomic, assign) BOOL animating;

@end

@implementation CCLoadingIndicator

- (CGRect)centerSquareRect {
    if (CGRectIsEmpty(_centerSquareRect)) {
        _centerSquareRect = [self getCenterSquare];
    }
    return _centerSquareRect;
}

- (CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        CGRect frame = self.centerSquareRect;
        _shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.width);
        CGFloat lineWidth = frame.size.width / 10.0;
        _shapeLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width * 0.5, frame.size.width * 0.5) radius:frame.size.width * 0.5 - lineWidth * 0.5 startAngle:- M_PI * 0.5 endAngle:M_PI * 1.5 clockwise:YES].CGPath;
        _shapeLayer.lineWidth = lineWidth;
        CGFloat adjust = lineWidth / (M_PI * frame.size.width);
        _shapeLayer.strokeStart = adjust;
        _shapeLayer.strokeEnd = adjust;
        _shapeLayer.lineCap = kCALineCapRound;
        
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
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
    self.gradientImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gradient"]];
    [self addSubview:self.gradientImageView];
    [self.gradientImageView setFrame:self.centerSquareRect];
    self.gradientImageView.layer.mask = self.shapeLayer;
}

- (CGRect)getCenterSquare {
    CGFloat wh = MIN(self.bounds.size.width, self.bounds.size.height);
    if (self.bounds.size.width > self.bounds.size.height) {
        return CGRectMake((self.bounds.size.width - wh) * 0.5, 0, wh, wh);
    } else {
        return CGRectMake(0, (self.bounds.size.height - wh) * 0.5, wh, wh);
    }
}

- (void)setProgress:(CGFloat)progress {
    if (self.animating) { return; }
    [super setProgress:progress];
    self.shapeLayer.strokeEnd = progress * 0.75;
    if (progress >= 1.0 && self.automaticallyLoading) {
        [self _startAnimating];
    }
}

- (void)_startAnimating {
    if (!self.animating) {

        self.animating = YES;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.transform = CGAffineTransformMakeScale(kCCLoadingDefaultZoomScale, kCCLoadingDefaultZoomScale);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.35 animations:^{
                                 self.transform = CGAffineTransformIdentity;
                             } completion:^(BOOL finished) {
                                 
                             }];
                         }];
        
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotate.fromValue = @0;
        rotate.toValue = @(M_PI * 2);
        rotate.repeatCount = MAXFLOAT;
        rotate.duration = 1.0;
        [self.layer addAnimation:rotate forKey:kCCLoadingRotateAnimationKey];
    }
}

- (void)_stopAnimating {
    self.animating = NO;
    [self.layer removeAllAnimations];
}

- (void)startLoading {
    self.progress = 1.0;
}

- (void)endLoading {
    [self _stopAnimating];
}

@end
