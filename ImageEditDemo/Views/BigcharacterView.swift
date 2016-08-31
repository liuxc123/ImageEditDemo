//
//  BigcharacterView.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class BigcharacterView: UIView {
    
    var title: String = ""   //内容
    var titleText: UITextView!
    var textViewFont: CGFloat = 17
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleText = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(titleText)
        titleText.backgroundColor = UIColor.lightGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textViewTextDidChange), name: UITextViewTextDidChangeNotification, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textViewTextDidChange() {
        calFontSize()
    }
    
    
    
    func calFontSize() {
        
        var height = (titleText.text! as NSString).boundingRectWithSize(CGSizeMake(frame.width, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(textViewFont)], context: nil).height
        
        if height > frame.size.height {
        while height > frame.size.height {
            textViewFont -= 1
            height = (titleText.text! as NSString).boundingRectWithSize(CGSizeMake(frame.width, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(textViewFont)], context: nil).height
            }
        } else {
            while height < frame.size.height && textViewFont < 17 {
                textViewFont += 1
                height = (titleText.text! as NSString).boundingRectWithSize(CGSizeMake(frame.width, 1000), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(textViewFont)], context: nil).height
            }
        }
        
        
        
    
        titleText.font = UIFont.systemFontOfSize(textViewFont)
    }
    
    
    func drawText(context: CGContextRef, title: String, fontSize: CGFloat, color: UIColor) {
        let rect = CGRect(x: 10, y: 10, width: self.frame.size.width - 20, height: self.frame.size.height - 20)
        let font = UIFont.systemFontOfSize(fontSize)
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Left
        (title as NSString).drawInRect(rect, withAttributes: [NSFontAttributeName:font, NSForegroundColorAttributeName:color])
    }

}
