//
//  ViewController.m
//  Swords
//
//  Created by Egor on 10/15/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import "GameSceneViewController.h"
#import <Colours.h>
#import <FCAlertView.h>

#import "LetterCell.h"
#import "Level.h"

@interface GameSceneViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, FCAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UITableView) NSArray *tableViews;
@property (weak, nonatomic) IBOutlet UIView *tableContainer;
@property (weak, nonatomic) IBOutlet UILabel *currentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;

@property (assign, nonatomic) CGFloat itemWidth;
@property (assign, nonatomic) CGFloat itemHeight;

// Game layer
@property (strong, nonatomic) Level *level;
@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *usedIndexPaths;
@property (strong, nonatomic) NSMutableArray<NSString *> *usedWords;
@property (assign, nonatomic) NSInteger currentScore;

@end

static NSString * const kCellIdentifier = @"cellIdentifier";

@implementation GameSceneViewController {
    UISelectionFeedbackGenerator *feedbackGenerator;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_levelNumber == 1) {
        _level = [Level createFirstLevel];
    } else {
        _level = [Level createSecondLevel];
    }

    _usedIndexPaths = @[].mutableCopy;
    _usedWords = @[].mutableCopy;
    
    feedbackGenerator = [[UISelectionFeedbackGenerator alloc] init];
    
    [self initializeTableView];
    [self configureView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CALayer *layer = self.tableContainer.layer;
    layer.borderWidth = 1.5;
    layer.borderColor = UIColor.goldenrodColor.CGColor;
    layer.cornerRadius = 4;
    layer.masksToBounds = true;
    
    for (UITableView *tableView in self.tableViews) {
        [self scrollToRowAtCenterOfScrollView:tableView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initializeTableView {
    UITableView *tableView = _tableViews.firstObject;
    _itemWidth = CGRectGetWidth(tableView.frame);
    _itemHeight = _itemWidth;
    
    UINib *letterCell = [UINib nibWithNibName:NSStringFromClass(LetterCell.class) bundle:nil];
    
    for (UITableView *tableView in _tableViews) {
        [tableView registerNib:letterCell forCellReuseIdentifier:kCellIdentifier];
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [tableView reloadData];
    }
}

- (void)configureView {
    self.currentScore = 0;
    self.currentScoreLabel.text = @"0";
    self.totalScoreLabel.text = [NSString stringWithFormat:@" / %d", (int)self.level.totalLetters];
    
    self.title = [NSString stringWithFormat:@"Уровень %d", (int)self.levelNumber];
}

- (void)updateCurrentScoreWithValue:(NSInteger)value {
    self.currentScore += value;
    self.currentScoreLabel.text = [NSString stringWithFormat:@"%d", (int)self.currentScore];
    
    if (self.currentScore == self.level.totalLetters) {
        [self showCompletedLevelAlert];
    }
}

#pragma mark Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return _level.levelMap[tableView.tag].count + 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LetterCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    }
    
    NSInteger lettersInColumn = _level.levelMap[tableView.tag].count;
    BOOL emptyCell = indexPath.section < 2 || indexPath.section >= lettersInColumn + 2;
    if (!emptyCell) {
        NSString *letter = _level.levelMap[tableView.tag][indexPath.section - 2];
        cell.letter = letter;
        if ([self.usedIndexPaths containsObject:indexPath]) {
            cell.used = true;
        }
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001; // xD
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self tableView:tableView viewForHeaderInSection:section];
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
    if ([scrollView isKindOfClass:UITableView.class]) {
        [feedbackGenerator prepare];
    }
}


#pragma mark - Game Layer

- (void)checkForWord {
    
    NSMutableArray *currentWord = [[NSMutableArray array] init];
    NSMutableDictionary<NSNumber *, NSIndexPath *> *winMap = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < _tableViews.count; i++) {
        currentWord[i] = @"";
    }
    
    for (UITableView *tableView in _tableViews) {
        CGPoint centerPoint = [self.tableContainer convertPoint:tableView.center toView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:centerPoint];
        LetterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [winMap setObject:indexPath forKey:@(tableView.tag)];
            currentWord[tableView.tag] = cell.letter;
        }
    }
    
    NSString *result = [currentWord componentsJoinedByString:@""].lowercaseString;
    if (result.length == _tableViews.count) {
        
        for (NSString *string in self.usedWords) {
            if ([string isEqualToString:result]) {
                return;
            }
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"4-character-words-rus" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        if ([content containsString:result]) {
            [self.usedWords addObject:result];
            [self setAsUsedCellsFromWinMap:winMap.copy];
            [feedbackGenerator selectionChanged];
        }
    }
}

- (void)setAsUsedCellsFromWinMap:(NSDictionary<NSNumber *, NSIndexPath *> *)winMap {
    for (UITableView *tableView in _tableViews) {
        NSIndexPath *indexPath = [winMap objectForKey:@(tableView.tag)];
        LetterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell.isUsed) {
            [self updateCurrentScoreWithValue:1];
            [self.usedIndexPaths addObject:indexPath];
            cell.used = true;
        }
    }
}


#pragma mark - Alert

- (void)showCompletedLevelAlert {
    FCAlertView *alert = [[FCAlertView alloc] init];
    alert.colorScheme = alert.flatOrange;
    alert.fullCircleCustomImage = false;
    alert.delegate = self;

    NSString *subtitle = [NSString stringWithFormat:@"Уровень %d пройден 😜👌", (int)self.levelNumber];
    [alert showAlertWithTitle:@"Восхитительно!"
                 withSubtitle:subtitle
              withCustomImage:nil
          withDoneButtonTitle:@"Продолжить"
                   andButtons:nil];
}

- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Table Handling

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
    CGPoint rowPoint = [self.tableContainer convertPoint:tableView.center toView:tableView];
    
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:rowPoint];
    
    [UIView animateWithDuration:0.3 delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [tableView scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionMiddle
                                                  animated:false];
                     } completion:^(BOOL finished) {
                         [self checkForWord];
                     }];
}


#pragma mark - Custom colors

- (UIColor *)randomColor {
    UIColor *referenceColor = [UIColor emeraldColor];
    NSArray *colorScheme = [referenceColor colorSchemeOfType:ColorSchemeComplementary];
    return colorScheme[arc4random_uniform((uint32_t)colorScheme.count)];
}

@end
