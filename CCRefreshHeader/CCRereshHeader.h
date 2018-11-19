//
//  CCRereshHeader.h
//  CCLoading
//
//  Created by demoncraz on 2018/11/15.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+CCRefresh.h"

typedef NS_ENUM(NSUInteger, CCRefreshHeaderType) {
    CCRefreshHeaderTypeIndicator,
    CCRefreshHeaderTypeDots
};

typedef void(^CCRefreshingBlock)(void);

@interface CCRereshHeader : UIView

@property (copy, nonatomic) CCRefreshingBlock refreshingBlock;

+ (instancetype)headerWithRefreshingBlock:(CCRefreshingBlock)refreshingBlock; //default type: Indicator;
+ (instancetype)headerWithType:(CCRefreshHeaderType)type refreshingBlock:(CCRefreshingBlock)refreshingBlock;
+ (instancetype)headerWithType:(CCRefreshHeaderType)type refreshingTarget:(id)target refreshingAction:(SEL)action;

- (void)startRefreshing;
- (void)endRefreshing;

@end
