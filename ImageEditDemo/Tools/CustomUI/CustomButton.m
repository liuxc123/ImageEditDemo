//
//  CustomButton.m
//  sadsad
//
//  Created by codans on 16/4/15.
//  Copyright © 2016年 codans. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.titleLabel setFont:[CustomFontAdapter adjustFont:self.titleLabel.font]];
}

@end
