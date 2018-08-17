//
//  DemoTableViewCell.h
//  WyhPageControlDemo
//
//  Created by wyh on 2018/8/17.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WyhPageControl.h"

@interface DemoTableViewCell : UITableViewCell

@property (nonatomic, strong) WyhPageControl *pageControl;

@property (nonatomic, assign) NSInteger indexStyle;

- (void)configCellStyle:(void(^)(DemoTableViewCell *))configuration;

@end
