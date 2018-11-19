//
//  UIScrollView+CCRefresh.m
//  CCLoading
//
//  Created by demoncraz on 2018/11/15.
//  Copyright © 2018 demoncraz. All rights reserved.
//

#import "UIScrollView+CCRefresh.h"
#import "CCRereshHeader.h"
#import <objc/runtime.h>

@implementation NSObject (CCRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchanageClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (CCRefresh)

static const char CCRefreshHeaderKey = '\0';

- (void)setCc_header:(CCRereshHeader *)cc_header {
    if (cc_header != self.cc_header) {
        [self.cc_header removeFromSuperview];
        [self insertSubview:cc_header atIndex:0];
        
        [self willChangeValueForKey:@"cc_header"]; //KVO
        objc_setAssociatedObject(self, &CCRefreshHeaderKey, cc_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"cc_header"]; // KVO
    }
}

- (CCRereshHeader *)cc_header {
    return objc_getAssociatedObject(self, &CCRefreshHeaderKey);
}

- (NSInteger)cc_totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section ++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section ++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char CCRefreshReloadDataBlockKey = '\0';
- (void)setCc_reloadDataBlock:(void (^)(NSInteger))cc_reloadDataBlock {
    [self willChangeValueForKey:@"cc_reloadDataBlock"];
    objc_setAssociatedObject(self, &CCRefreshReloadDataBlockKey, cc_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"cc_reloadDataBlock"];
}

- (void (^)(NSInteger))cc_reloadDataBlock {
    return objc_getAssociatedObject(self, &CCRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock {
    !self.cc_reloadDataBlock ? : self.cc_reloadDataBlock(self.cc_totalDataCount);
}

@end

@implementation UITableView (CCRefresh)

+ (void)load {
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(cc_reloadData)];
}

- (void)cc_reloadData {
    [self cc_reloadData];
    [self executeReloadDataBlock];
}


@end
