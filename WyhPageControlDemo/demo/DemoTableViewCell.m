//
//  DemoTableViewCell.m
//  WyhPageControlDemo
//
//  Created by wyh on 2018/8/17.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "DemoTableViewCell.h"


@interface DemoTableViewCell () <WyhPageControlDelegate,WyhPageControlDataSource>


@end

@implementation DemoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.pageControl = [[WyhPageControl alloc]initWithDataSource:self Delegate:self WithConfiguration:^(WyhPageControl *pageControl) {
        // initialize some config
    }];
    [self.contentView addSubview:self.pageControl];
}

- (void)configCellStyle:(void (^)(DemoTableViewCell *))configuration {
    
    if (configuration) {
        configuration(self);
    }
    [self.pageControl reloadData];
}

- (void)layoutSubviews {
    self.pageControl.center = self.contentView.center;
}

#pragma mark - delegate

- (WyhPageControlDot *)pageControl:(WyhPageControl *)pageControl dotForIndex:(NSInteger)index {
    
    WyhPageControlDot *dot = [[WyhPageControlDot alloc]init];
    switch (_indexStyle) {
        case 0:
        {
            // defalut style.
        } break;
        case 1:
        {
            if (index == pageControl.numberOfPages -1) {
                dot.size = CGSizeMake(35, 35);
                dot.conerRadius = 17.5;
                dot.unselectImage = [UIImage imageNamed:@"time"];
                dot.selectImage = [UIImage imageNamed:@"time_select"];
            }
        } break;
        case 2:
        {
            dot.size = CGSizeMake(25.f, 8.f);
            dot.conerRadius = 4.f;
            dot.unSelectTintColor = [UIColor purpleColor];
            dot.selectTintColor = [UIColor blueColor];
        } break;
        case 3:
        {
            pageControl.cornerRadius = (pageControl.dotTopMargin*2+20)*0.5;
            pageControl.dotTopMargin = 15.f;
            pageControl.dotLeftMargin = 25.f;
            dot.size = CGSizeMake(20.f, 20.f);
            dot.conerRadius = 2.f;
            dot.unSelectTintColor = [UIColor whiteColor];
            dot.selectTintColor = [UIColor darkGrayColor];
        } break;
        case 4:
        {
            pageControl.cornerRadius = (pageControl.dotTopMargin*2+15.f)*0.5;
            dot.size = CGSizeMake(15.f, 15.f);
            dot.conerRadius = 7.5;
        } break;
        default:
            break;
    }
    return dot;
}

- (void)pageControl:(WyhPageControl *)pageControl didClickForIndex:(NSInteger)index {
    
    NSLog(@"点击第%ld行 第%ld个dot",_indexStyle+1,index+1);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
