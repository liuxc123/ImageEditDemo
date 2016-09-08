//
//  PasterImageView.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/28.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit



class PasterImageView: UIImageView {
    
    var title: String = "请输入文字"
    var font: UIFont!
    var textColor = UIColor.blackColor()
    var top: CGFloat = 0
    var constant: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        drawText(title, font: font, color: textColor)
    }
    
    
    func drawText(title: String, font: UIFont, color: UIColor) {
        let rect = CGRect(x: 0, y: top, width: self.frame.size.width, height: self.frame.size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        let font = font
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        (title as NSString).drawInRect(rect, withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName:style])
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func drawTextWithImage(image: UIImage?, title: String, font: UIFont, color: UIColor) {
        
        let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
   
        let font = font
        
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        (title as NSString).drawInRect(rect, withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName:style])
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        let textImage = self.image
        UIGraphicsEndImageContext()
        
        
        UIGraphicsBeginImageContext(rect.size)
        
        if image != nil {
            image?.drawInRect(rect)
        }
        
        let width = self.frame.size.width - 2*constant
        let height = width * self.frame.size.height / self.frame.size.height
        
        let textRect = CGRect(x: constant, y: top, width: width, height: height)
        textImage?.drawInRect(textRect)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
       

      
    }


}
