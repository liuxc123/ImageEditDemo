//
//  StringExtension.swift
//  NinePictureDemo
//
//  Created by XiaLuo on 16/8/30.
//  Copyright © 2016年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

extension String {

    //MARK: - 根据image大小计算字体的大小
    func calculateFontWithImageSize(size: CGSize) -> UIFont {
        var font = UIFont.systemFontOfSize(0)
        var cFont = font.pointSize
        var textSize = (self as NSString).sizeWithAttributes([NSFontAttributeName: font])
        repeat {
            cFont += 1
            font = UIFont.systemFontOfSize(cFont)
            textSize = (self as NSString).sizeWithAttributes([NSFontAttributeName: font])
        } while textSize.width <= size.width && textSize.height <= size.height
        font = UIFont.systemFontOfSize(cFont-1)
        return font
    }
    
}
