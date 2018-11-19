//
//  CCRereshHeader.m
//  CCLoading
//
//  Created by demoncraz on 2018/11/15.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import "CCRereshHeader.h"
#import "CCLoadingIndicator.h"
#import "CCLoadingDots.h"
#import "UIView+CCExtension.h"
#import <objc/message.h>

static NSString *const kCCRreshKeyPathContentOffset = @"contentOffset";
static NSString *const kCCRreshKeyPathContentInset = @"contentInset";
static NSString *const kCCRreshKeyPathContentSize = @"contentSize";
static NSString *const kCCRreshKeyPathPanState = @"state";

static CGFloat kDefaultCCHeaderHeight = 70.0;

@interface CCRereshHeader ()
@property (nonatomic, strong) CCLoadingComponent *loadingView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, weak) id refreshingTarget;
@property (nonatomic, assign) SEL refreshingAction;

@property (nonatomic, assign) CCRefreshHeaderType type;

@end

@implementation CCRereshHeader {
    __weak UIScrollView *_scrollView;
    UIEdgeInsets _scrollViewOriginalInset;
}

+ (instancetype)headerWithType:(CCRefreshHeaderType)type refreshingBlock:(CCRefreshingBlock)refreshingBlock {
    CCRereshHeader *header = [[self alloc] init];
    header.refreshingBlock = refreshingBlock;
    header.type = type;
    return header;
}
+ (instancetype)headerWithType:(CCRefreshHeaderType)type refreshingTarget:(id)target refreshingAction:(SEL)action {
    CCRereshHeader *header = [[self alloc] init];
    [header setRefreshingTarget:target refreshingAction:action];
    header.type = type;
    return header;
}
+ (instancetype)headerWithRefreshingBlock:(CCRefreshingBlock)refreshingBlock {
    return [self headerWithType:CCRefreshHeaderTypeIndicator refreshingBlock:refreshingBlock];
}


- (CCLoadingComponent *)loadingView {
    if (_loadingView == nil) {
        if (self.type == CCRefreshHeaderTypeIndicator) {
            _loadingView = [[CCLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        } else if (self.type == CCRefreshHeaderTypeDots) {
            _loadingView = [[CCLoadingDots alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action {
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    if (newSuperview) {
        self.frame = CGRectMake(0, -kDefaultCCHeaderHeight, newSuperview.cc_width, kDefaultCCHeaderHeight);
        self.loadingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
        [self addObservers];
    }
}

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:kCCRreshKeyPathContentOffset options:options context:nil];
    [_scrollView addObserver:self forKeyPath:kCCRreshKeyPathContentSize options:options context:nil];
    self.pan = _scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:kCCRreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:kCCRreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:kCCRreshKeyPathContentSize];
    [self.superview removeObserver:self forKeyPath:kCCRreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.userInteractionEnabled) return;
    if (self.hidden) return;
    
    if ([keyPath isEqualToString:kCCRreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:kCCRreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    CGFloat relativeOffsetY = _scrollView.contentOffset.y + _scrollViewOriginalInset.top;
    NSLog(@"relativeOffsetY : %.2f", relativeOffsetY);
    self.loadingView.progress = MIN(relativeOffsetY / -kDefaultCCHeaderHeight, 1);
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    CGFloat relativeOffsetY = _scrollView.contentOffset.y + _scrollViewOriginalInset.top;
    if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (relativeOffsetY < -kDefaultCCHeaderHeight && !self.isRefreshing) {
            [self startRefreshing];
        }
    }
}

- (void)startRefreshing {
    self.refreshing = YES;
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = UIEdgeInsetsMake(self->_scrollViewOriginalInset.top + kDefaultCCHeaderHeight, self->_scrollViewOriginalInset.left, self->_scrollViewOriginalInset.bottom, self->_scrollViewOriginalInset.right);
        [self->_scrollView setContentInset:inset];
    }];
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
    if (self.refreshingTarget && [self.refreshingTarget respondsToSelector:self.refreshingAction]) {
        ((void (*)(void *, SEL, UIView *))objc_msgSend)((__bridge void *)self.refreshingTarget, self.refreshingAction, self);
    }
}

- (void)endRefreshing {
    self.refreshing = NO;
    [self.loadingView endLoading];
    [UIView animateWithDuration:0.25 animations:^{
        [self->_scrollView setContentInset:self->_scrollViewOriginalInset];
    }];
}

@end
