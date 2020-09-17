//
//  DynamicGradientController.m
//  MyApp
//
//  Created by rex on 9/17/20.
//  Copyright © 2020 rex. All rights reserved.
//

#import "DynamicGradientController.h"

@interface DynamicGradientController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DynamicGradientController


#pragma mark - UITableViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    self.headerView.frame = [self headerImageFrame];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell---%zd", indexPath.row];
    return cell;
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAppearance];
}
- (void)setupAppearance {
    [self.view addSubview:self.tableView];
    if (@available(iOS 11,*)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"lakeside_sunset" ofType:@"png"];
    UIImage *headerImage = [UIImage imageWithContentsOfFile:imagePath];
    _headerView = [[UIImageView alloc] initWithImage:headerImage];
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_headerView aboveSubview:_tableView];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    
    CGRect headerFrame = headerView.frame;
    
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}

- (CGRect) headerImageFrame {
    UITableView *tableView = self.tableView;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



@end
