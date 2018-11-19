//
//  UIScrollView+CCRefresh.h
//  CCLoading
//
//  Created by demoncraz on 2018/11/15.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCRereshHeader;

@interface UIScrollView (CCRefresh)

@property (nonatomic, strong) CCRereshHeader *cc_header;

- (NSInteger)cc_totalDataCount;
@property (nonatomic, copy) void (^cc_reloadDataBlock)(NSInteger totalDataCount);

@end
