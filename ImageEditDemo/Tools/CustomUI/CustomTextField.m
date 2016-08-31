//
//  CustomTextField.m
//  sadsad
//
//  Created by codans on 16/4/15.
//  Copyright © 2016年 codans. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(void)awakeFromNib{
    [super awakeFromNib];
    [super setFont:[CustomFontAdapter adjustFont:self.font]];
}

-(void)setFont:(UIFont *)font{
    [super setFont:[CustomFontAdapter adjustFont:font]];
}

@end
