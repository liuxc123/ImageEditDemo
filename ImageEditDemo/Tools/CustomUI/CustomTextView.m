//
//  CustomTextView.m
//  sadsad
//
//  Created by codans on 16/4/15.
//  Copyright © 2016年 codans. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

-(void)awakeFromNib{
    [super awakeFromNib];
    [super setFont:[CustomFontAdapter adjustFont:self.font]];
}

-(void)setFont:(UIFont *)font{
    [super setFont:[CustomFontAdapter adjustFont:font]];
}

@end
