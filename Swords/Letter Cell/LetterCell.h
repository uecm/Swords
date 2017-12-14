//
//  LetterCell.h
//  Swords
//
//  Created by Egor on 12/10/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LetterCell : UITableViewCell

@property (assign, nonatomic, getter = isUsed) BOOL used;
@property (strong, nonatomic) NSString *letter;

//- (void)configureWithLetter:(NSString *)letter;

@end
