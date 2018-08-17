//
//  WyhPageControl.m
//  NewPagedFlowViewDemo
//
//  Created by wyh on 2018/8/16.
//  Copyright © 2018年 robertcell.net. All rights reserved.
//

#import "WyhPageControl.h"


@interface WyhPageControl ()

@property (nonatomic, weak) id<WyhPageControlDataSource> dataSource;

@property (nonatomic, weak) id<WyhPageControlDelegate> delegate;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) NSMutableArray<WyhPageControlDot *>* visibleDots;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) BOOL isReloading;

@end

@implementation WyhPageControl

#pragma mark - Life

- (instancetype)initWithDataSource:(id<WyhPageControlDataSource>)dataSource
                          Delegate:(id<WyhPageControlDelegate>)delegate
                 WithConfiguration:(void (^)(WyhPageControl *))configuration {
    if (self = [self init]) {
        if(configuration) configuration(self);
        _dataSource = dataSource;
        _delegate = delegate;
        
        [self reloadUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initializeConfig];
    }
    return self;
}

#pragma mark - Initialize

- (void)initializeConfig {
    self.clipsToBounds = YES;
    
    _numberOfPages = 0;
    _currentPage = 0;
    _hidesForSinglePage = NO;
    _pageIndicatorTintColor = [UIColor lightGrayColor];
    _currentPageIndicatorTintColor = [UIColor darkGrayColor];
    _backgroundColor = [UIColor clearColor];
    _borderWidth = 0.f;
    _cornerRadius = 0.f;
    _borderColor = [UIColor darkGrayColor];
    _backgroundImage = nil;
    _showReloadActivityIndicator = YES;
    
    // const
    _dotLeftMargin = 15.f;
    _dotTopMargin = 8.f;
    _dotSpace = 8.f;
    
    // ui
    _coverView = [[UIView alloc]init];
    _coverImageView = [[UIImageView alloc]init];
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [_indicator sizeToFit];
    [self addSubview:_coverView];
    [self addSubview:_coverImageView];
    [self addSubview:_indicator];
}

#pragma mark - UI

- (void)showActivity:(BOOL)show {
    if (show) {
        if (_showReloadActivityIndicator) {
            _isReloading = YES;
            [self.indicator startAnimating];
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![obj isEqual:self.indicator]) {
                    obj.hidden = YES;
                }
            }];
        }
    }else {
        if (_showReloadActivityIndicator) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isReloading = NO;
                [self.indicator stopAnimating];
                [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj isEqual:self.indicator]) {
                        obj.hidden = NO;
                    }
                }];
            });
        }
        
    }
}

- (void)reloadUI {
    
    [self showActivity:YES];
    [self checkHiddenIfNeeded];
    [self configPageControlUI];
    [self initDots];
    [self showActivity:NO];
}

- (void)checkHiddenIfNeeded {
    
    // whether hidden.
    if (_hidesForSinglePage && _numberOfPages <= 1) {
        self.hidden = YES;
    }else {
        self.hidden = NO;
    }
}

- (void)configPageControlUI {
    
    if (_backgroundImage) {
        [self.coverImageView setImage:_backgroundImage];
    }
    if (_borderWidth > 0) {
        self.layer.borderWidth = _borderWidth;
        self.layer.borderColor = _borderColor.CGColor;
    }
    self.layer.cornerRadius = _cornerRadius;
    
}

- (void)initDots {
    
    [self.visibleDots makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.visibleDots = [NSMutableArray new];
    
    WyhPageControlDot *lastDot ;
    
    for (int i = 0; i < _numberOfPages; i++) {
        
        WyhPageControlDot *dot = nil;
        
        if (![self.dataSource respondsToSelector:@selector(pageControl:dotForIndex:)]) {
            dot = [[WyhPageControlDot alloc]init];
            dot.unSelectTintColor = _pageIndicatorTintColor;
            dot.selectTintColor = _currentPageIndicatorTintColor;
        }else {
            dot = [self.dataSource pageControl:self dotForIndex:i];
        }
        dot.hidden = _isReloading;
        // frame
        CGFloat dotX = (!lastDot)?_dotLeftMargin:CGRectGetMaxX(lastDot.frame)+_dotSpace;
        dot.frame = CGRectMake(dotX, 0, dot.size.width, dot.size.height);
        // gesture
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageControlDotTapAction:)];
        [dot addGestureRecognizer:tapges];
        [self addSubview:dot];
        [self.visibleDots addObject:dot];
        lastDot = dot;
    }
    [self bringSubviewToFront:self.indicator];
    
    [self configDotsUI];
    [self autoConfigBounds];
    [self configAllDotsCenterY]; // must after autoConfigBounds.
}

- (void)autoConfigBounds {
    
    __block CGFloat maxHeight = 0.f;
    [self.visibleDots enumerateObjectsUsingBlock:^(WyhPageControlDot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.size.height > maxHeight) {
            maxHeight = obj.size.height;
        }
    }];
    
    CGFloat width = CGRectGetMaxX(self.visibleDots.lastObject.frame)+_dotLeftMargin;
    CGFloat height = maxHeight + 2*_dotTopMargin;
    // adjust bounds
    self.bounds = CGRectMake(0, 0, width, height);
    self.coverView.frame = self.bounds;
    self.coverImageView.frame = self.bounds;
    self.indicator.frame = self.bounds;
}

- (void)configAllDotsCenterY {
    [self.visibleDots enumerateObjectsUsingBlock:^(WyhPageControlDot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint center = obj.center;
        center.y = self.bounds.size.height/2;
        obj.center = center;
    }];
}

- (void)configDotsUI {
    
    [self.visibleDots enumerateObjectsUsingBlock:^(WyhPageControlDot * _Nonnull dot, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dot.borderWidth > 0) {
            dot.layer.borderWidth = dot.borderWidth;
            dot.layer.borderColor = dot.borderColor.CGColor;
        }
        dot.layer.cornerRadius = dot.conerRadius;
        if (idx == _currentPage) {
            [dot setSelected:YES];
        }else {
            [dot setSelected:NO];
        }
    }];
}

#pragma mark - API

- (void)reloadData {
    
    [self reloadUI];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self moveToIndex:currentPage];
}

- (CGSize)sizeForPageControl {
    return self.bounds.size;
}

#pragma mark - Setter

- (void)setNumberOfPages:(NSUInteger)numberOfPages {
    _numberOfPages = numberOfPages;
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage {
    _hidesForSinglePage = hidesForSinglePage;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    _coverView.backgroundColor = backgroundColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setDotLeftMargin:(CGFloat)dotLeftMargin {
    _dotLeftMargin = dotLeftMargin;
}

- (void)setDotTopMargin:(CGFloat)dotTopMargin {
    _dotTopMargin = dotTopMargin;
}

- (void)setDotSpace:(CGFloat)dotSpace {
    _dotSpace = dotSpace;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    _coverImageView.image = backgroundImage;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - Gesture

- (void)pageControlDotTapAction:(UITapGestureRecognizer *)tapGes {
    WyhPageControlDot *dot = (WyhPageControlDot *)tapGes.view;
    NSInteger index = [self.visibleDots indexOfObject:dot];
    if (index == NSNotFound) {
        NSAssert(NO, @"Can't found this tap dot !");
        return;
    }

    [self moveToIndex:index];
    // call back
    if ([self.delegate respondsToSelector:@selector(pageControl:didClickForIndex:)]) {
        [self.delegate pageControl:self didClickForIndex:index];
    }
}

#pragma mark - Private

- (void)moveToIndex:(NSInteger)index {
    _currentPage = index;
    [self.visibleDots enumerateObjectsUsingBlock:^(WyhPageControlDot * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            [obj setSelected:YES];
        }else {
            [obj setSelected:NO];
        }
    }];
}

@end
