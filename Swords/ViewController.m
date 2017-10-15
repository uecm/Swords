//
//  ViewController.m
//  Swords
//
//  Created by Egor on 10/15/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import "ViewController.h"
#import <Colours.h>

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UITableView) NSArray *tableViews;
@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) CGFloat itemHeight;

@end

static NSString * const kCellIdentifier = @"cellIdentifier";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITableView *tableView = _tableViews.firstObject;
    _itemWidth = CGRectGetWidth(tableView.frame);
    _itemHeight = _itemWidth;
    
    for (UITableView *tableView in _tableViews) {
        tableView.dataSource = self;
        tableView.delegate = self;

        [tableView reloadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (cell) {
        BOOL emptyCell = indexPath.section < 2 || indexPath.section > 6;
        if (!emptyCell) {
            cell.contentView.backgroundColor = [self randomColor];
        }
        else {
            cell.contentView.backgroundColor = [UIColor wheatColor];
        }
    }
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _itemHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToRowAtCenterOfScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToRowAtCenterOfScrollView:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


#pragma mark - Custom colors

- (void)scrollToRowAtCenterOfScrollView:(UIScrollView *)scrollView {
    UITableView *tableView;
    for (UITableView *table in _tableViews) {
        if ([table isEqual:scrollView]) {
            tableView = table;
            break;
        }
    }
    if (!tableView) {
        return;
    }
    CGPoint centerPoint = CGPointMake(scrollView.center.x, self.view.center.y);
    CGPoint rowPoint = [self.view convertPoint:centerPoint toView:tableView];
    
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:rowPoint];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:true];
}


- (UIColor *)randomColor {
    UIColor *referenceColor = [UIColor emeraldColor];
    NSArray *colorScheme = [referenceColor colorSchemeOfType:ColorSchemeComplementary];
    return colorScheme[arc4random_uniform((uint32_t)colorScheme.count)];
}

@end
