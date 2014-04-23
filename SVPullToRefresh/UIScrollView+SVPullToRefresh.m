//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"

//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

typedef void (^RefreshControlBlock)();

static char UIScrollViewRefreshControlView;
static char UIScrollViewRefreshActionBlock;

@interface UIScrollView ()

//@property (nonatomic, strong, readwrite) ODRefreshControl *refreshControl;
@property (nonatomic, copy) RefreshControlBlock refreshActionBlock;

@end

@implementation UIScrollView (SVPullToRefresh)

@dynamic refreshControl;

- (void)addRefreshControlWithActionHandler:(void (^)(void))actionHandler;
{
    if (!self.refreshControl) {
        self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self];
        self.refreshActionBlock = actionHandler;
        [self.refreshControl addTarget:self action:@selector(refreshControlDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)refreshControlDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    if (self.refreshActionBlock) {
        self.refreshActionBlock();
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        
//      NSString *updated = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
//        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:updated];
    }
}

- (void)setRefreshControl:(ODRefreshControl *)refreshControl
{
    [self willChangeValueForKey:@"RefreshControll"];
    objc_setAssociatedObject(self, &UIScrollViewRefreshControlView,
                             refreshControl,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"RefreshControll"];
}

- (ODRefreshControl *)refreshControl
{
    return objc_getAssociatedObject(self, &UIScrollViewRefreshControlView);
}

- (void)setRefreshActionBlock:(RefreshControlBlock)refreshActionBlock
{
    [self willChangeValueForKey:@"RefreshControll"];
    objc_setAssociatedObject(self, &UIScrollViewRefreshActionBlock,
                             refreshActionBlock,
                             OBJC_ASSOCIATION_COPY);
    [self didChangeValueForKey:@"RefreshControll"];
}

- (RefreshControlBlock)refreshActionBlock
{
    return objc_getAssociatedObject(self, &UIScrollViewRefreshActionBlock);
}

@end
