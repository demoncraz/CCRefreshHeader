# CCRefreshHeader
A easy-to-use loading header, see gif for the demo:
<p align="center"><img src ="https://github.com/demoncraz/CCRefreshHeader/blob/master/demo.gif" width="300" /></p>

How to use:
1. Simply use the CCRefreshHeader class by adding a cc_header for your scrollView:
```objective-c
self.tableView.cc_header = [CCRereshHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
```
or 
```objective-c
self.tableView.cc_header = [CCRereshHeader headerWithRefreshingBlock:^{
  [weakSelf getData];
}];
```

call -(void)endRefreshing after data is loaded for example:
```objective-c
[self.tableView.cc_header endRefreshing];
```

2. You can use the CCLoadingIndicator directly if you don't need the default behaviour of capturing master ScrollView's content offset change. Simply change the "progress" value:
```objective-c
CCLoadingIndicator *indicatorView = [CCLoadingIndicator alloc] init];
indicatorView.progress = 0.5;
```
And it automatically starts animating according to the "automaticallyLoading" property configuration when progress >= 1.0.
