//
//  CCLoadingComponent.m
//  CCLoading
//
//  Created by demoncraz on 2018/11/19.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import "CCLoadingComponent.h"

@implementation CCLoadingComponent

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (void)initial {
    self.backgroundColor = [UIColor clearColor];
    self.automaticallyLoading = YES;
}

- (void)startLoading {}
- (void)endLoading {}

@end
