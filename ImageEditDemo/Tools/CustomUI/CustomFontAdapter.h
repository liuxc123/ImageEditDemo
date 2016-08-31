//
//  CustomFontAdapter.h
//  sadsad
//
//  Created by codans on 16/4/15.
//  Copyright © 2016年 codans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import "CustomLabel.h"
#import "CustomTextView.h"
#import "CustomTextField.h"

#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667.0f)
//#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4_5 ([[UIScreen mainScreen] bounds].size.width == 320.0f)
// 这里设置iPhone6减小的字号数（现在是减小1号，也就是iPhone6 plus上字体为17时，iPhone6上字号为16）
#define IPHONE6_DECREASE 1
// 这里设置iPhone4活iPhone5减小的字号数（现在是减小2号，也就是iPhone6 plus上字体为17时，iPhone6上字号为14）
#define IS_IPHONE_4_5_DECREASE 2


@interface CustomFontAdapter : NSObject
+ (UIFont *)adjustFont:(UIFont *)font;
@end
