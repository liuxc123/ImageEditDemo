//
//  UIImageExtension.swift
//  PictureDealDemo
//
//  Created by XiaLuo on 16/8/28.
//  Copyright © 2016年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK: - 拆分image
    func separateImage(byX x: Int, andY y: Int) -> [UIImage]? {
        
        guard x >= 1 else {
            print("请输入大于1的X值")
            return nil
        }
        guard y >= 1 else {
            print("请输入大于1的Y值")
            return nil
        }
        
        let _xstep = size.width*1.0/CGFloat(y)
        let _ystep = size.height*1.0/CGFloat(x)
        var dict = Array<UIImage>()
        for i in 0...x {
            for j in 0...y {
                let rect = CGRectMake(_xstep*CGFloat(j), _ystep*CGFloat(i), _xstep, _ystep)
                if let imageRef = CGImageCreateWithImageInRect(CGImage, rect) {
                    let elementImage = UIImage.init(CGImage: imageRef)
                    dict.insert(elementImage, atIndex: i*y+j)
                }
            }
        }
        return dict
    }
    
    //MARK: - 拆分image，并绘制文字
    func separateImageAndDescripetion(byX x: Int, andY y: Int, descripetion _descripetion: String?, textColor color: UIColor?) -> [UIImage]? {
        
        guard x >= 1 else {
            print("请输入大于1的X值")
            return nil
        }
        guard y >= 1 else {
            print("请输入大于1的Y值")
            return nil
        }
        
        let _xstep = size.width*1.0/CGFloat(y)
        let _ystep = size.height*1.0/CGFloat(x)
        var dict = Array<UIImage>()
        for i in 0...x {
            for j in 0...y {
                let rect = CGRectMake(_xstep*CGFloat(j), _ystep*CGFloat(i), _xstep, _ystep)
                if let imageRef = CGImageCreateWithImageInRect(CGImage, rect) {
                    var elementImage = UIImage.init(CGImage: imageRef)
                    if let des = _descripetion {
                        if (des as NSString).length >= i*y+j+1 {
                            //需要绘制文字的image
                            let imgRect = CGRectMake(0, 0, _xstep, _ystep)
                            UIGraphicsBeginImageContext(imgRect.size)
                            elementImage.drawInRect(imgRect)
                            //取出要绘制的文字
                            let startIndex = des.startIndex.advancedBy(i*y+j)
                            let endIndex = des.startIndex.advancedBy(i*y+j+1)
                            let character = des.substringWithRange( Range<String.Index> (startIndex..<endIndex))
                            //设置文字绘制的区域
                            let avatarSize = CGRectMake(0, 0, _xstep*0.5, _ystep*0.5)
                            let _x = (imgRect.width - avatarSize.width)*0.5
                            let _y = (imgRect.height - avatarSize.height)*0.5
                            //设置绘制文字的font，根据需要绘制的区域计算出合理的font
                            let font = character.calculateFontWithImageSize(avatarSize.size)
                            //设置文字绘制的属性
                            let style = NSMutableParagraphStyle()
                            style.alignment = .Center
                            
                            if let _color = color {
                                (character as NSString).drawInRect(CGRectMake(_x, _y, avatarSize.width, avatarSize.height), withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: _color, NSParagraphStyleAttributeName: style])
                            } else {
                                (character as NSString).drawInRect(CGRectMake(_x, _y, avatarSize.width, avatarSize.height), withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: style])
                            }
                            
                            elementImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                        }
                    }
                    dict.insert(elementImage, atIndex: i*y+j)
                }
            }
        }
        return dict
    }

    //MARK: - 将颜色转换成image
    class func createImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 800*PROPORTION_BASIC6P, 800*PROPORTION_BASIC6P)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
   
}
