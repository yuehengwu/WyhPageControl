//
//  DemoViewController.m
//  WyhPageControlDemo
//
//  Created by wyh on 2018/8/17.
//  Copyright © 2018年 wyh. All rights reserved.
//

#import "DemoViewController.h"
#import "DemoTableViewCell.h"

@interface DemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isReload;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.tableView = table;
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    table.tableHeaderView = header;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:(UIBarButtonItemStylePlain) target:self action:@selector(reload)];
    
}

- (void)reload {
    _isReload = !_isReload;
    [self.tableView reloadData];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DemoTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = 0;
    cell.indexStyle = indexPath.section;
    [cell configCellStyle:^(DemoTableViewCell *cell) {
        switch (indexPath.section) {
            case 0:
            {
                cell.pageControl.numberOfPages = (!_isReload)?3:7;
                
            } break;
            case 1:
            {
                cell.pageControl.numberOfPages = (!_isReload)?4:3;
            } break;
            case 2:
            {
                cell.pageControl.currentPage = 2;
                cell.pageControl.numberOfPages = (!_isReload)?5:3;
            } break;
            case 3:
            {
                cell.pageControl.numberOfPages = (!_isReload)?3:5;
                cell.pageControl.currentPage = 2;
                cell.pageControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            } break;
            case 4:
            {
                cell.pageControl.numberOfPages = (!_isReload)?6:3;
                cell.pageControl.dotSpace = 20.f;
                cell.pageControl.backgroundImage  = [UIImage imageNamed:@"glass"];
            } break;
            default:
                break;
        }
    }];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return @"Default";
        } break;
        case 1:
        {
            return @"Custom Image";
        } break;
        case 2:
        {
            return @"Square";
        } break;
        case 3:
        {
            return @"Background Color";
        } break;
        case 4:
        {
            return @"Background Image";
        } break;
        default:
            break;
    }
    return @"";
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
