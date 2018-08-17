//
//  WyhPageControlDot.h
//  NewPagedFlowViewDemo
//
//  Created by wyh on 2018/8/16.
//  Copyright © 2018年 robertcell.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WyhPageControlDot : UIView

@property(nonatomic, strong) UIColor *unSelectTintColor;

@property(nonatomic, strong) UIColor *selectTintColor;

@property (nonatomic, strong) UIImage *unselectImage;

@property (nonatomic, strong) UIImage *selectImage;

@property (nonatomic, assign) CGSize size; // default is (20,20)

@property (nonatomic, strong) UIColor *borderColor; //defult is nil;

@property (nonatomic, assign) CGFloat borderWidth; // default is 0.f;

@property (nonatomic, assign) CGFloat conerRadius; //default is 10.f

- (void)setSelected:(BOOL)selected;


@end
