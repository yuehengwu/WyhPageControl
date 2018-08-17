//
//  WyhPageControlDot.m
//  NewPagedFlowViewDemo
//
//  Created by wyh on 2018/8/16.
//  Copyright © 2018年 robertcell.net. All rights reserved.
//

#import "WyhPageControlDot.h"

static CGFloat const _defaultDotWidth = 10.f;

@interface WyhPageControlDot ()

@property (nonatomic, strong) UIImageView *coverImageView;

@end

@implementation WyhPageControlDot

- (instancetype)init {
    if (self = [super init]) {
        [self initializeConfig];
    }
    return self;
}

- (void)initializeConfig {
    
    self.clipsToBounds = YES;
    
    _coverImageView = [[UIImageView alloc]init];
    [self addSubview:_coverImageView];
    
    _unselectImage = nil;
    _selectImage = nil;
    _conerRadius = _defaultDotWidth/2;
    
    _unSelectTintColor = [UIColor lightGrayColor];
    _selectTintColor = [UIColor darkGrayColor];
    _borderColor = nil;
    
    _size = CGSizeMake(_defaultDotWidth, _defaultDotWidth);
    
}

- (void)layoutSubviews {
    
    _coverImageView.frame = self.bounds;
}

#pragma mark - API

- (void)setSelected:(BOOL)selected {
    if (selected) {
        if (_selectImage) {
            self.coverImageView.image = _selectImage;
            self.backgroundColor = [UIColor clearColor];
        }else {
            self.backgroundColor = _selectTintColor;
        }
    }else {
        if (_unselectImage) {
            self.coverImageView.image = _unselectImage;
        }else {
            self.backgroundColor = _unSelectTintColor;
        }
    }
}

@end
