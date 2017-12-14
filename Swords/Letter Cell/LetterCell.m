//
//  LetterCell.m
//  Swords
//
//  Created by Egor on 12/10/17.
//  Copyright © 2017 egor. All rights reserved.
//

#import "LetterCell.h"
#import <Colours.h>

@interface LetterCell ()

@property (weak, nonatomic) IBOutlet UILabel *letterLabel;

@end

@implementation LetterCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.letterLabel.text = @"";
    self.used = false;
    
    self.letterLabel.backgroundColor = UIColor.clearColor;
    self.letterLabel.textAlignment = NSTextAlignmentCenter;
    self.letterLabel.textColor = UIColor.whiteColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.letterLabel.text = @"";
    self.used = false;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//- (void)configureWithLetter:(NSString *)letter {
//    self.letterLabel.text = letter;
//}

- (void)setUsed:(BOOL)used {
    _used = used;
    if (used) {
        self.contentView.backgroundColor = UIColor.mandarinColor;
    } else {
        self.contentView.backgroundColor = UIColor.brickRedColor;
    }
}

- (void)setLetter:(NSString *)letter {
    _letter = letter;
    self.letterLabel.text = letter;
}

@end
