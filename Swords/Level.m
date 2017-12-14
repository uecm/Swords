//
//  Level.m
//  Swords
//
//  Created by Egor on 12/10/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import "Level.h"

@implementation Level

- (instancetype)init {
    self = [super init];
    if (self) {
        _levelMap = @[];
        _wordLength = 0;
    }
    return self;
}


+ (Level *)createFirstLevel {
    Level *level = [[Level alloc] init];
    
    level.wordLength = 4;
    level.levelMap = @[
                       @[@"В", @"К", @"М"],
                       @[@"О", @"И"],
                       @[@"Д", @"Н"],
                       @[@"О", @"А"]
                       ];
    
    level.totalLetters = 9;
    return level;
}

+ (Level *)createSecondLevel {
    Level *level = [[Level alloc] init];
    
    level.wordLength = 4;
    level.levelMap = @[
                       @[@"Е", @"К", @"П"],
                       @[@"Л", @"Н", @"Р"],
                       @[@"У", @"О", @"А"],
                       @[@"Т", @"Д"]
                       ];
    
    level.totalLetters = 11;
    return level;
}

@end
