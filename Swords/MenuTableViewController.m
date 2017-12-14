//
//  MenuTableViewController.m
//  Swords
//
//  Created by Egor on 12/10/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import "MenuTableViewController.h"
#import "GameSceneViewController.h"

@interface MenuTableViewController ()

@property (assign, nonatomic) NSInteger selectedLevel;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedLevel = 1;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath
                                animated:true
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1) {
        return;
    }
    
    if (self.selectedIndexPath == indexPath) {
        return;
    }
    else if (self.selectedIndexPath != indexPath) {
        [tableView cellForRowAtIndexPath:self.selectedIndexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath;
    self.selectedLevel = indexPath.row + 1;
}

- (IBAction)soundSwitchAction:(id)sender {
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newGameSegue"]) {
        GameSceneViewController *destination = segue.destinationViewController;
        destination.levelNumber = self.selectedLevel;
    }
}

@end
