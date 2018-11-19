//
//  CCLoadingComponent.h
//  CCLoading
//
//  Created by demoncraz on 2018/11/19.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCLoadingComponent : UIView

/**
 start loading animation when progress >= 1.0 if automaticallyLoading is YES;
 */
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL automaticallyLoading;   //Default is YES;

- (void)startLoading;
- (void)endLoading;

@end

NS_ASSUME_NONNULL_END
