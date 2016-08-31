//
//  PasterView.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

let IS_IOS_7 = Double(UIDevice.currentDevice().systemVersion) >= 7.0;
let IMAGE_ICON_SIZE: CGFloat = 26
let MAX_FONT_SIZE: CGFloat = 500

protocol PasterViewDelegate{
    func pasterViewDidBeginEditing(pasterView: PasterView)
    func pasterViewDidChangeEditing(pasterView: PasterView)
    func pasterViewDidEndEditing(pasterView: PasterView)
    func pasterDidClose(pasterView: PasterView)
}

class PasterView: UIView, UITextViewDelegate {
    
    var delegate: PasterViewDelegate?
    
    var textString: String = ""
    var touchLocation: CGPoint?
    var prevPoint: CGPoint?
    var beginningPoint: CGPoint?
    var beginningCenter: CGPoint?
    var beginningBounds: CGRect?
    
    var initialBounds: CGRect?
    var initialDistance: CGFloat = 0
    
    var deltaAngle: CGFloat = 0
    var currentAngle: CGFloat = 0
    
    var minSize: CGSize!
    var minFontSize: CGFloat = 0
    var curFont: UIFont?                                //当前字体大小
    var textColor: UIColor = UIColor.blackColor()       //字体颜色（默认黑色）
    var borderColor: UIColor = UIColor.yellowColor()    //边框颜色 (默认黄色)
    
    var resizingControl: UIImageView!                   //选择移动按钮
    var deleteControl: UIImageView!                     //删除按钮
    var textImageView: PasterImageView!                 //文本图片展示
    var textView: UITextView!                           //编辑层
    var isDeleting: Bool = false                        //是否是删除
    var isShowBorder: Bool = true                       //是否展示边框
    var directionIndex: Int = 0
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        //空白视图
        let tempView = UITextView(frame: CGRectZero)
        self.addSubview(tempView)
        
        self.userInteractionEnabled = true
        let font = UIFont.systemFontOfSize(20)
        self.curFont = font
        self.minFontSize = font.pointSize
        textString = text
        
        //创建textView
        createTextView(frame, text: textString, font: curFont)
        
        //创建展示图层
        textImageView = PasterImageView(frame: CGRectZero)
        textImageView.userInteractionEnabled = true
        textImageView.layer.borderColor = self.borderColor.CGColor
        textImageView.layer.borderWidth = 2
        textImageView.layer.masksToBounds = true
        self.addSubview(textImageView)
        textImageView.hidden = true
      
        //创建移动选择图标
        resizingControl = UIImageView(frame: CGRect(x: 0, y: 0, width: IMAGE_ICON_SIZE, height: IMAGE_ICON_SIZE))
        resizingControl.image = UIImage(named: "paster_size")
        resizingControl.userInteractionEnabled = true
        self.addSubview(resizingControl)
        
        //创建删除按钮
        deleteControl = UIImageView(frame: CGRect(x: 0, y: 0, width: IMAGE_ICON_SIZE, height: IMAGE_ICON_SIZE))
        deleteControl.image = UIImage(named: "paster_delete")
        deleteControl.userInteractionEnabled = true
        self.addSubview(deleteControl)
        
        
        let twoTap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        twoTap.numberOfTapsRequired = 2
        textImageView.addGestureRecognizer(twoTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        tap.numberOfTapsRequired = 1
        textImageView.addGestureRecognizer(tap)
                
        //关闭手势
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(deleteControlTapAction(_:)))
        deleteControl.addGestureRecognizer(closeTap)
        //移动手势
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(moveGestureAction(_:)))
        self.addGestureRecognizer(moveGesture)
        let panRotateGesture = UIPanGestureRecognizer(target: self, action: #selector(rotateViewPanGesture(_:)))
        resizingControl.addGestureRecognizer(panRotateGesture)
        
        self.minSize = CGSizeMake(IMAGE_ICON_SIZE, IMAGE_ICON_SIZE);
        if (self.minSize.height >  frame.size.height ||
            self.minSize.width  >  frame.size.width  ||
            self.minSize.height <= 0 || self.minSize.width <= 0)
        {
            self.minSize = CGSizeMake(frame.size.width/3.0, frame.size.height/3.0);
        }
        
        //绘制字体绘制
        calFontSize()
        
//        var cFont = self.textView.font!.pointSize
//        var tSize = self.textSize(cFont, string: nil)
//        self.textView.textContainerInset = UIEdgeInsetsZero
//       
//        while !isBeyond(tSize) && cFont < MAX_FONT_SIZE {
//            cFont += 1
//            tSize = self.textSize(cFont, string: nil)
//        }
//            
//        cFont -= 1
//        self.textView.font = self.curFont?.fontWithSize(cFont)
//        
//        layoutSubview(frame)
//        centerTextVertically()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*************************************************************************************************/
    
    //TODO: 开启编辑模式
    func beginEditing() {
        textView.hidden = false
        textImageView.hidden = true
        textView.backgroundColor = UIColor.whiteColor()
        deleteControl.hidden = false
        resizingControl.hidden = false
        
        textView.layer.borderColor = borderColor.CGColor
        textView.layer.masksToBounds = true
        textImageView.layer.borderColor = UIColor.clearColor().CGColor
        textImageView.layer.masksToBounds = true
    }
    
    //TODO: 结束编辑模式带边框or不带边框
    func endEditingWithShowBorder(isShow: Bool) {
        textView.hidden = true
        textImageView.hidden = false
        isShowBorder = isShow
        if isShow {
            
            if deleteControl.hidden == true {
                deleteControl.hidden = false
                resizingControl.hidden = false
                textImageView.layer.borderColor = borderColor.CGColor
                textImageView.layer.masksToBounds = true
            }
            
        } else {
            
            if deleteControl.hidden == false {
                deleteControl.hidden = true
                resizingControl.hidden = true
                textImageView.layer.borderColor = UIColor.clearColor().CGColor
                textImageView.layer.masksToBounds = true
            }
        }
        
        
    }
    
    //隐藏、展示边框， 编辑按钮
    func isHiddenBorder(isShow: Bool) {
        isShowBorder = isShow
        
        if isShow {
            
            if deleteControl.hidden == true {
                deleteControl.hidden = false
                resizingControl.hidden = false
                textView.layer.borderWidth = 2
                textView.layer.borderColor = borderColor.CGColor
                textView.layer.masksToBounds = true
                textImageView.layer.borderWidth = 2
                textImageView.layer.borderColor = borderColor.CGColor
                textImageView.layer.masksToBounds = true
            }

        } else {
            if deleteControl.hidden == false {
                deleteControl.hidden = true
                resizingControl.hidden = true
                textView.layer.borderWidth = 2
                textView.layer.borderColor = UIColor.clearColor().CGColor
                textView.layer.masksToBounds = true
                textImageView.layer.borderWidth = 2
                textImageView.layer.borderColor = UIColor.clearColor().CGColor
                textImageView.layer.masksToBounds = true
            }

        }
    }
    
    
    
    /*************************************************************************************************/
    
    //TODO: 双击开启开启编辑
    func tapAction(tap: UITapGestureRecognizer) {
        
        if tap.numberOfTapsRequired == 1 {
            print("单击")
            self.endEditingWithShowBorder(true)
        } else {
            print("双击")
            beginEditing()
            self.textView.becomeFirstResponder()
        }

    }
    
    //TODO: 删除点击手势
    func deleteControlTapAction(tap: UITapGestureRecognizer) {
        print("删除")
        self.removeFromSuperview()
    }
    
    //TODO: 移动手势
    func moveGestureAction(recognizer: UIPanGestureRecognizer) {
        print("移动")
        isHiddenBorder(true)
        touchLocation = recognizer.locationInView(self.superview)
        
        switch recognizer.state {
        case .Began:
            beginningPoint = touchLocation
            beginningCenter = self.center
            self.center = CGPoint(x: beginningCenter!.x + (touchLocation!.x - beginningPoint!.x), y: beginningCenter!.y + (touchLocation!.y - beginningPoint!.y))
            beginningBounds = self.bounds
            
        case .Changed:
     
            self.center = CGPoint(x: beginningCenter!.x + (touchLocation!.x - beginningPoint!.x), y: beginningCenter!.y + (touchLocation!.y - beginningPoint!.y))
            
        case .Ended:
            beginningPoint = touchLocation
            beginningCenter = self.center
            self.center = CGPoint(x: beginningCenter!.x + (touchLocation!.x - beginningPoint!.x), y: beginningCenter!.y + (touchLocation!.y - beginningPoint!.y))

        default:
            break
        }
        
        prevPoint = touchLocation
        
    }
    
    //TODO: 旋转手势
    func rotateViewPanGesture(recognizer: UIPanGestureRecognizer) {
        print("旋转")
        touchLocation = recognizer.locationInView(self.superview)
        
        center = CGRectGetCenter(self.frame)
        
        switch recognizer.state {
        case .Began:
            //求出反正切角
            deltaAngle = atan2(touchLocation!.y-center.y, touchLocation!.x-center.x) - CGAffineTransformGetAngle(self.transform)
            initialBounds = self.bounds
            initialDistance = CGPointGetDistance(center, point2: touchLocation!)
            
            prevPoint = recognizer.locationInView(self)
        case .Changed:
            var increase = false
            
            if self.bounds.size.width < self.minSize!.width || self.bounds.size.height < self.minSize!.height {
                self.bounds = CGRectMake(self.bounds.origin.x,
                                         self.bounds.origin.y,
                                         self.minSize!.width,
                                         self.minSize!.height)
                self.resizingControl.frame = CGRect(x: self.bounds.size.width - IMAGE_ICON_SIZE / 2, y: self.bounds.size.height - IMAGE_ICON_SIZE / 2, width: IMAGE_ICON_SIZE, height: IMAGE_ICON_SIZE)
                self.deleteControl.frame = CGRect(x: 0, y: 0, width: IMAGE_ICON_SIZE, height: IMAGE_ICON_SIZE)
                    
                prevPoint = recognizer.locationInView(self)
            } else {
                let point = recognizer.locationInView(self)
                var wChange: CGFloat = 0
                var hChange: CGFloat = 0
                wChange = (point.x - prevPoint!.x)
                hChange = (point.y - prevPoint!.y)
                
                if abs(wChange) > 20.0 || abs(hChange) > 20.0 {
                    prevPoint = recognizer.locationInView(self)
                    return
                }
                
                if wChange < 0 && hChange < 0 {
                    let change = min(wChange, hChange)
                    wChange = change
                    hChange = change
                }
                
                if wChange < 0 {
                    hChange = wChange
                } else if hChange < 0 {
                    wChange = hChange
                } else {
                    let change = max(wChange, hChange)
                    wChange = change
                    hChange = change
                }
                
                increase = wChange > 0 ? true : false
                self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width + (wChange), height: self.bounds.size.height + (hChange))
                
                //重新布局
                self.layoutSubview(self.bounds)
                prevPoint = recognizer.locationInView(self)
                
            }
            
            /* Rotation */
            let ang = atan2(recognizer.locationInView(self.superview).y - self.center.y, recognizer.locationInView(self.superview).x - self.center.x)
            let angleDiff = deltaAngle - ang
            self.transform = CGAffineTransformMakeRotation(-angleDiff)
            currentAngle = fabs(angleDiff)
            //重新绘制文字
            var cFont = self.textView.font!.pointSize
            var tSize = self.textSize(cFont, string: nil)
            self.textView.textContainerInset = UIEdgeInsetsZero
            
            if increase {
                
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
            
        case .Ended:
            print("移动结束")
        default:
            break
        }
    }
    

    /*************************************************************************************************/
    
    func layoutSubview(frame: CGRect) {
        var tRect = frame
        
        //计算textViewframe
        tRect.size.width = self.bounds.size.width - IMAGE_ICON_SIZE
        tRect.size.height = self.bounds.size.height - IMAGE_ICON_SIZE
        tRect.origin.x = IMAGE_ICON_SIZE / 2.0
        tRect.origin.y = IMAGE_ICON_SIZE / 2.0
        self.textView.frame = tRect
        textImageView.frame = tRect
        
        //计算按钮frame
        resizingControl.frame = CGRect(x: tRect.size.width, y: tRect.size.height, width: IMAGE_ICON_SIZE, height: IMAGE_ICON_SIZE)
        deleteControl.frame = CGRect(x: 0, y: 0, width: IMAGE_ICON_SIZE, height: IMAGE_ICON_SIZE)

    }
    
    
    
    //MARK: - initTextView
    func createTextView(frame: CGRect, text: String, font: UIFont?) {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        textView.backgroundColor = UIColor.clearColor()
        textView.scrollEnabled = false
        textView.delegate = self
        textView.keyboardType = UIKeyboardType.Default
        textView.returnKeyType = .Done
        textView.textAlignment = .Center
        textView.textColor = UIColor.blackColor()
        textView.font = font
        textView.text = text
        textView.autocorrectionType = .No
        self.addSubview(textView)
        
        textView.layer.borderWidth = 2
        textView.layer.borderColor = borderColor.CGColor
        textView.layer.masksToBounds = true

        self.textView  = textView
    }
    
    
    
    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        beginEditing()
        if textView.text == textString {
            textView.text = ""
            //重新绘制图片
            calFontSize()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        endEditingWithShowBorder(true)
        if textView.text.isEmpty {
            textView.text = textString
            //重新绘制图片
            calFontSize()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.endEditing(true)
            return false
        }
        
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
        
        layoutSubview(frame)
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
        
        
        
        //重新绘制图片
        textImageView.font = textView.font!
        textImageView.textColor = textColor
        textImageView.title = textView.text
        textImageView.top = offset
        textImageView.drawText(textView.text, font: textView.font!, color: textColor)
        
        textImageView.layer.borderWidth = 2
        textImageView.layer.borderColor = isShowBorder ? borderColor.CGColor : UIColor.clearColor().CGColor
        textImageView.layer.masksToBounds = true
    }
    
    
    func CGRectGetCenter(rect: CGRect) -> CGPoint {
        return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
    }
    
    func CGPointGetDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let fx = point2.x - point1.x
        let fy = point2.y - point1.y
        
        return sqrt((fx*fx + fy+fy))
    }
    
    func CGAffineTransformGetAngle(t: CGAffineTransform) -> CGFloat {
        return atan2(t.b, t.a)
    }

    
/****************************************************************************************************/


}
