//
//  WyhPageControl.h
//  NewPagedFlowViewDemo
//
//  Created by wyh on 2018/8/16.
//  Copyright © 2018年 robertcell.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WyhPageControlDot.h"

@class WyhPageControl;

@protocol WyhPageControlDataSource <NSObject>

@optional

- (WyhPageControlDot *)pageControl:(WyhPageControl *)pageControl dotForIndex:(NSInteger)index;

@end

@protocol WyhPageControlDelegate <NSObject>

@optional
- (void)pageControl:(WyhPageControl *)pageControl didClickForIndex:(NSInteger)index;

@end



@interface WyhPageControl : UIView

@property (nonatomic, assign) NSUInteger numberOfPages;          // default is 0
@property (nonatomic, assign) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property (nonatomic, assign) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property(nonatomic, strong) UIColor *pageIndicatorTintColor;

@property(nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (nonatomic, assign) CGFloat dotLeftMargin; // distance left and right outside.

@property (nonatomic, assign) CGFloat dotTopMargin; // distance top and bottom outside.

@property (nonatomic, assign) CGFloat dotSpace; //distance between each dot.

@property (nonatomic, strong) UIImage *backgroundImage; //background image.

@property (nonatomic, strong) UIColor *backgroundColor; //background color.

@property (nonatomic, strong) UIColor *borderColor; //pageControl's border-color.

@property (nonatomic, assign) CGFloat borderWidth; // pageControl's border width.

@property (nonatomic, assign) CGFloat cornerRadius; // pageControl's cornerRadius.

@property (nonatomic, assign) BOOL showReloadActivityIndicator; // Whether show activity indicator when reloadData, default is YES.

- (instancetype)initWithDataSource:(id<WyhPageControlDataSource>)dataSource
                          Delegate:(id<WyhPageControlDelegate>)delegate
                 WithConfiguration:(void(^)(WyhPageControl *pageControl))configuration;


- (void)setCurrentPage:(NSInteger)currentPage;

- (CGSize)sizeForPageControl;

- (void)reloadData;



@end
