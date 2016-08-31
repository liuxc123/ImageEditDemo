//
//  CustomFontAdapter.m
//  sadsad
//
//  Created by codans on 16/4/15.
//  Copyright © 2016年 codans. All rights reserved.
//

#import "CustomFontAdapter.h"

@implementation CustomFontAdapter
+(UIFont *)adjustFont:(UIFont *)font{
    UIFont *newFont = nil;
    if (IS_IPHONE_6){
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize - IPHONE6_DECREASE];
    }else if (IS_IPHONE_4_5){
        newFont = [UIFont fontWithName:font.fontName size:font.pointSize - IS_IPHONE_4_5_DECREASE];
    }else{
        newFont = font;
    }
    
    return newFont;
}

@end
