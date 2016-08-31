//
//  TextPasterItem.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/30.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class TextPasterItem: PasterItem, UITextViewDelegate {
    /**
     *  占位字符
     */
    var textString: String = "双击输入文字"
    
    /**
     *  编辑页
     */
    var textView: UITextView!
    /**
     *  展示页
     */
    var textImageView: PasterImageView!
    
    /**
     *  编辑页上边距
     */
    var textViewTop: CGFloat = 0
    
    /**
     *  文字颜色
     */
    var textColor = UIColor.blackColor()
    /**
     *   当前字体大小
     */
    var curFont: UIFont?
    /**
     *   当前字体大小
     */
    var minFSize: CGSize?
    var minFontSize: CGFloat = 0
    /**
     *  文字编辑-- 是否正在删除
     */
    var isDeleting: Bool = false
    
    
    override init(frame: CGRect, myPaster: MyPaster) {
        super.init(frame: frame, myPaster: myPaster)
        
        initialMyTextPasterItemView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialMyTextPasterItemView() {
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
        self.curFont = UIFont.systemFontOfSize(10)
        self.minFontSize = curFont!.pointSize
        
        //设置当前ImageView
        textImageView = PasterImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height))
        textImageView.userInteractionEnabled = true
        textImageView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(textImageView)
        //点击手势
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(pasterTapGes(_:)))
        textImageView.addGestureRecognizer(oneTap)
        //双击手势
        let twoTap = UITapGestureRecognizer(target: self, action: #selector(pasterTapGes(_:)))
        twoTap.numberOfTapsRequired = 2
        textImageView.addGestureRecognizer(twoTap)
        
        //创建编辑层
        createTextView(self.bounds, text: textString, font: curFont)

        //重新计算文字
        calFontSize()
        
    }
    
    //MARK: - initTextView
    func createTextView(frame: CGRect, text: String, font: UIFont?) {
        let textView = UITextView(frame: self.textImageView.frame)
        textView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        textView.scrollEnabled = false
        textView.delegate = self
        textView.keyboardType = UIKeyboardType.Default
        textView.returnKeyType = .Default
        textView.textAlignment = .Center
        textView.textColor = UIColor.blackColor()
        textView.font = font
        textView.text = text
        textView.autocorrectionType = .No
        self.contentView.addSubview(textView)
        
        textView.hidden = true
        self.textView  = textView
        
        initEditPasterView()
    }
    
    /**
     *   键盘编辑层
     */
    func initEditPasterView() {
        let inputAccessoryView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        inputAccessoryView.backgroundColor  = UIColor.clearColor()
        textView.inputAccessoryView = inputAccessoryView
        
        //选择颜色
        inputAccessoryView.inPutColorView.selectColorBlock = {[unowned self] color in
            self.textColor = color
            self.textView.textColor = color
            self.drawTextImageView()
        }
        //完成操作
        inputAccessoryView.completeBlock = {[unowned self] in
            self.textView.resignFirstResponder()
            self.textView.hidden = true
            self.textImageView.hidden = false
        }
    }
    
    
    /**
     *   双击开启编辑
     */
    override func pasterTapGes(ges: UITapGestureRecognizer) {
        super.pasterTapGes(ges)
        
        switch ges.numberOfTapsRequired {
        case 1:
            self.isSelect = true
        case 2:
            textView.becomeFirstResponder()
            textView.hidden = false
            textImageView.hidden = true
        default:
            break
        }

    }

    
    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        self.isSelect = true
        if textView.text == textString {
            textView.text = ""
            calFontSize()
        }

    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textString
            calFontSize()
        }
        drawTextImageView()
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        isDeleting = range.length >= 1 && text.characters.count == 0
        if textView.font!.pointSize <= self.minFontSize && !isDeleting {
            return false
        }

        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        var cFont = self.textView.font!.pointSize
        var tSize = self.textSize(cFont, string: nil)
        self.textView.textContainerInset = UIEdgeInsetsZero
        
        if isDeleting {
            
            while !isBeyond(tSize) && cFont < MAX_FONT_SIZE {
                cFont += 1
                tSize = self.textSize(cFont, string: nil)
            }
            
            cFont -= 1
            self.textView.font = self.curFont?.fontWithSize(cFont)
            
        } else {
            
            while self.isBeyond(tSize) && cFont > 0 {
                cFont -= 1
                tSize = self.textSize(cFont, string: nil)
            }
            
            self.textView.font = self.curFont?.fontWithSize(cFont)
        }
        
        centerTextVertically()
    }
    
    

    
    func isBeyond(size: CGSize) -> Bool {
        let ost = self.textView.textContainerInset.top + self.textView.textContainerInset.bottom
        return size.height + ost > self.textView.frame.size.height
    }
    
    //MARK: - 计算字体大小, 重新布局
    func calFontSize() {
        let font = UIFont.systemFontOfSize(1)
        var cFont = font.pointSize
        var tSize = self.textSize(cFont, string: nil)
        self.textView.textContainerInset = UIEdgeInsetsZero
        
        while !isBeyond(tSize) && cFont < MAX_FONT_SIZE {
            cFont += 1
            tSize = self.textSize(cFont, string: nil)
        }
        
        cFont -= 1
        self.textView.font = self.curFont?.fontWithSize(cFont)
        
        centerTextVertically()
    }
    
    
    //计算字体文本大小
    func textSize(font: CGFloat, string: String?) -> CGSize {
        let text = (string != nil) ? string : self.textView.text
        
        let p0 = self.textView.textContainer.lineFragmentPadding * 2
        let cW = self.textView.frame.size.width - p0
        
        let tH = (text as NSString).boundingRectWithSize(CGSize(width: cW, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.curFont!.fontWithSize(font)], context: nil).size
        
        return tH
    }
    
    
    //设置文字垂直居中
    func centerTextVertically() {
        let tH = self.textSize(self.textView.font!.pointSize, string: nil)
        let offset = (self.textView.frame.size.height - tH.height) / 2.0
        self.textView.textContainerInset = UIEdgeInsets(top: offset, left: 0, bottom: offset, right: 0)
        textViewTop = offset
        drawTextImageView()
    }
    
    //重新绘制展示图片
    func drawTextImageView() {
        //重新绘制图片
        textImageView.font = textView.font!
        textImageView.textColor = textColor
        textImageView.title = textView.text
        textImageView.top = textViewTop
        textImageView.drawText(textView.text, font: textView.font!, color: textColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame.size = self.contentView.frame.size
        textImageView.frame.size = self.contentView.frame.size
        
        calFontSize()
        
    }
    
    
    

}
