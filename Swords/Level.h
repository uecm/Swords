//
//  Level.h
//  Swords
//
//  Created by Egor on 12/10/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *levelMap;
@property (assign, nonatomic) NSInteger wordLength;
@property (assign, nonatomic) NSInteger totalLetters;

+ (Level *)createFirstLevel;
+ (Level *)createSecondLevel;

@end
