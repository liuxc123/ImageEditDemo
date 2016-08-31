//
//  PasterItem.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/30.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class PasterItem: UIView {

    /**
     *   删除按钮图片
     */
    var deleteIcon: UIImage! {
        didSet{
            deleteView.image = deleteIcon
        }
    }
    /**
     *   尺寸控制按钮图片
     */
    var sizeIcon: UIImage! {
        didSet{
            sizeView.image = sizeIcon
        }
    }
    /**
     *  旋转按钮图片
     */
    var rotateIcon: UIImage! {
        didSet{
            rotateView.image = rotateIcon
        }
    }
    /**
     *  内容View
     */
    var contentView: UIView!
    
    /**
     *  myPaster数据类
     */
    var myPaster: MyPaster! {
        didSet{
            
        }
    }
    
    /**
     *  Paster
     */
    var paster: Paster! {
        didSet{
            
        }
    }
    
    /*************************************************************/
    /**
     *  起始尺寸
     */
    var originSize: CGSize!
    
    /**
     *  缩放最小尺寸
     */
    var minSize: CGSize!
    
    /**
     *  touch手势起点
     */
    var startTouchPoint: CGPoint!
    var deletaAngle: CGFloat = 0
    var prevPoint: CGPoint!
    
    /**
     *  开始缩放时的尺寸
     */
    var startScaleSize: CGSize!
    
    /**
     *  是否已经旋转  -- 默认为false
     */
    var haveTransform: Bool = false
    
    /**
     *  开始\结束位置
     */
    var startTcPoint: CGPoint!
    var endTcPoint: CGPoint!
    
    /**
     *  删除按钮
     */
    var deleteView: UIImageView!
    
    /**
     *  尺寸控制按钮
     */
    var sizeView: UIImageView!
    
    /**
     *  镜像按钮
     */
    var rotateView: UIImageView!

 
   
    
    /**
     *  pasterItemTouchObj
     */
    typealias PasterItemTouchObj = (pasterItem: PasterItem) -> Void
    var pasterItemTouchObj: PasterItemTouchObj?
    
    /**
     *  重写init方法
     *
     *  @param frame  frame
     *  @param paster paster
     *
     *  @return 实例化后的pasterItem
     */
    init(frame: CGRect, myPaster: MyPaster) {
        super.init(frame: frame)
        self.myPaster = myPaster

        self.userInteractionEnabled = true
        iconSize = CGSize(width: 30.0, height: 30.0)
        originSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
        minSize = CGSize(width: self.bounds.size.width*0.3, height: self.bounds.size.height*0.3)
        deletaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,self.frame.origin.x+self.frame.size.width - self.center.x)
        initialView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        iconSize = CGSize(width: 30.0, height: 30.0)
        originSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
        minSize = CGSize(width: self.bounds.size.width*0.5, height: self.bounds.size.height*0.5)
        deletaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,self.frame.origin.x+self.frame.size.width - self.center.x)
        initialView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialView() {
        //贴花
        contentView = UIView(frame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
        contentView.backgroundColor = UIColor.clearColor()
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clearColor().CGColor
        contentView.layer.shouldRasterize = true
        contentView.clipsToBounds = true
        self.addSubview(contentView)
        
        //删除控制
        deleteView = UIImageView(frame: CGRectMake(0, 0, iconSize.width, iconSize.height))
        deleteView.backgroundColor = UIColor.clearColor()
        deleteView.userInteractionEnabled = true
        deleteView.image = deleteIcon
        self.addSubview(deleteView)
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGes(_:)))
        deleteView.addGestureRecognizer(tapGes)
        
        //缩放+旋转控制
        sizeView = UIImageView(frame: CGRectMake(self.bounds.size.height - iconSize.height, self.bounds.size.width - iconSize.width, iconSize.width, iconSize.height))
        sizeView.backgroundColor = UIColor.clearColor()
        sizeView.userInteractionEnabled = true
        sizeView.image = sizeIcon
        self.addSubview(sizeView)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panGes(_:)))
        sizeView.addGestureRecognizer(panGes)
        
        //镜像/Y轴对称
        rotateView = UIImageView(frame: CGRectMake(0, self.bounds.size.height - iconSize.height, iconSize.width, iconSize.height))
        rotateView.backgroundColor = UIColor.clearColor()
        rotateView.userInteractionEnabled = true
        rotateView.image = rotateIcon
        self.addSubview(rotateView)
        let rotateTapGes = UITapGestureRecognizer(target: self, action: #selector(rotateTapGes(_:)))
        rotateView.addGestureRecognizer(rotateTapGes)
        
        //旋转手势
        let rotationGes = UIRotationGestureRecognizer(target: self, action: #selector(rotationGes(_:)))
        self.addGestureRecognizer(rotationGes)
        
        let pincheGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pincheGesture)
        
        let pasterTapGes = UITapGestureRecognizer(target: self, action: #selector(pasterTapGes(_:)))
        self.addGestureRecognizer(pasterTapGes)
    }
    
    /**
     *  点击block
     *
     *  @param touchObj touchObj
     */
    func addTouch(touchObj: PasterItemTouchObj) {
        self.pasterItemTouchObj = touchObj
    }
    
    /**
     *  添加贴图带动画
     *
     */
    func addPasterItemWithAnimation() {
        let frameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        frameAnimation.values = [1.3, 1]
        frameAnimation.duration = 0.3
        frameAnimation.repeatCount = 1
        frameAnimation.removedOnCompletion = false
        frameAnimation.fillMode = kCAFillModeForwards
        self.layer.addAnimation(frameAnimation, forKey: "frameAnimation")
    }
    
    
    //MARK: - 触摸手势
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
        
        //KVC
        myPaster.currentSelectPasterItem = self
        startTouchPoint = (touches as NSSet).anyObject()!.locationInView(self.superview)
        startTcPoint = startTouchPoint
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //判断手势是否在pan手势之上
        let touchLocation = (touches as NSSet).anyObject()!.locationInView(self)
        if CGRectContainsPoint(sizeView.frame, touchLocation) {
            return
        }
        
        //获取手势在父控件上的位置，并且根据手势位置更改自身位置
        let touchPoint = (touches as NSSet).anyObject()!.locationInView(self.superview)
        self.resetFrameWithTouchPoint(touchPoint)
        startTouchPoint = touchPoint
        endTcPoint = startTouchPoint
        
    }
    
    
    /**
     *  删除点击
     *
     *  @param ges 单击手势
     */
    func tapGes(ges: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
    
    /**
     *  缩放+旋转手势
     *
     *  @param ges 拖动手势
     */
    func panGes(ges: UIPanGestureRecognizer) {

        
        
        switch ges.state {
        case .Began:

            prevPoint = ges.locationInView(self)
            self.setNeedsLayout()
            
        case .Changed:
            if self.bounds.size.width < minSize.width || self.bounds.size.height < minSize.height {
                self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: minSize.width, height: minSize.height)
                prevPoint = ges.locationInView(self)
                self.setNeedsLayout()
                
            } else {
                let point = ges.locationInView(self)
                var wChange: CGFloat = 0.0
                var hChange: CGFloat = 0.0
                
                wChange = point.x - prevPoint.x
                let wRationChange = wChange / self.bounds.size.width
                
                hChange = wRationChange * self.bounds.size.height
                
                if abs(wChange) > 50.0 || abs(hChange) > 50.0 {
                    prevPoint = ges.locationOfTouch(0, inView: self)
                    return
                }
                
                var finalWidth = self.bounds.size.width + CGFloat(sqrtf(3.8)) * wChange
                var finalHeight = self.bounds.size.height + CGFloat(sqrtf(3.8)) * hChange
                
                //尺寸控制
                if finalWidth < minSize.width {
                    finalWidth = minSize.width
                }
                if finalHeight < minSize.height {
                    finalHeight = minSize.height
                }
                let maxSize = max(self.superview!.bounds.size.width*1.3, self.superview!.bounds.size.height*1.3)
                if finalWidth > finalHeight {
                    //宽大于高
                    if finalHeight > maxSize {
                        finalWidth = finalWidth/finalHeight*maxSize;
                        finalHeight = maxSize;
                    }
                } else {
                    //宽小于等于高
                    if (finalWidth > maxSize) {
                        finalHeight = finalHeight/finalWidth*maxSize;
                        finalWidth = maxSize;
                    }
                }
                
                self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: finalWidth, height: finalHeight)
                
                prevPoint = ges.locationOfTouch(0, inView: self)
                
                /* Rotation */
                let ang = atan2(Double(ges.locationInView(self.superview).y - self.center.y) , Double(ges.locationInView(self.superview).x - self.center.x))
                let angleDiff = deletaAngle - CGFloat(ang)
                self.transform = CGAffineTransformMakeRotation(-angleDiff)
                self.setNeedsLayout()
            }
         
        case .Ended:
            prevPoint = ges.locationInView(self)
            self.setNeedsLayout()
        default:
            break
        }
        
    }
    
    /**
     *  镜像手势
     *
     *  @param ges 镜像手势
     */
    func rotateTapGes(ges: UITapGestureRecognizer) {
        if ges.state == .Ended {
            if haveTransform == false {
                haveTransform = true
                let transform = CATransform3DMakeRotation(180.0*CGFloat(M_PI/180.0), 0, 1, 0)
                contentView.layer.transform = transform
            } else {
                haveTransform = false
                let transform = CATransform3DMakeRotation(0.0*CGFloat(M_PI/180.0), 0, 1, 0)
                contentView.layer.transform = transform
            }
        }
    }
    
    /**
     *  旋转手势
     *
     *  @param ges 旋转手势
     */
    func rotationGes(ges: UIRotationGestureRecognizer) {
        self.transform = CGAffineTransformRotate(self.transform, ges.rotation)
        ges.rotation = 0
    }
    
    func handlePinch(pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == .Began {
            startScaleSize = self.bounds.size
        } else {
            let maxSize = max(self.superview!.bounds.size.width*1.3, self.superview!.bounds.size.height*1.3)
            let maxScale = max(maxSize/startScaleSize.width, maxSize/startScaleSize.height)
            if pinchGesture.scale > maxScale {
                pinchGesture.scale = maxScale
            }
            
            self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: startScaleSize.width*pinchGesture.scale, height: startScaleSize.height*pinchGesture.scale)
        }
        
    }
    
    func pasterTapGes(ges: UITapGestureRecognizer) {
        if startTcPoint == nil || endTcPoint == nil {
            return
        }
        
        if CGPointEqualToPoint(startTcPoint, endTcPoint) {
            return
        }
        let touchLocation = ges.locationInView(self)
        if CGRectContainsPoint(deleteView.frame, touchLocation) || CGRectContainsPoint(sizeView.frame, touchLocation) || CGRectContainsPoint(rotateView.frame, touchLocation) {
            return
        }
        if CGRectContainsPoint(contentView.frame, touchLocation) != true {
            return
        }
        
        if self.pasterItemTouchObj != nil {
            pasterItemTouchObj!(pasterItem: self)
        }
        
    }
    
    
    /**
     *  是否为选中 -- 默认为false
     */
    var isSelect: Bool = false {
        didSet{
            /**
             *  选中处理
             */
            if isSelect {
                /**
                 *  选中的
                 */
                contentView.layer.borderWidth = 2
                contentView.layer.borderColor = UIColor.yellowColor().CGColor
                contentView.layer.masksToBounds = true
                deleteView.hidden = false
                sizeView.hidden = false
                rotateView.hidden = false
            } else {
                /**
                 *  未选中的
                 */
                contentView.layer.borderWidth = 2
                contentView.layer.borderColor = UIColor.clearColor().CGColor
                contentView.layer.masksToBounds = true
                deleteView.hidden = true
                sizeView.hidden = true
                rotateView.hidden = true
            }
        }
    }

    /**
     *  按钮尺寸
     */
    var iconSize: CGSize! {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    
    /**
     *  更改自身位置，以touch手势触摸点为依据
     *
     *  @param point 触摸点位置
     */
    func resetFrameWithTouchPoint(point: CGPoint) {
        //获取新的中心点
        var newCenter = CGPoint(x: self.center.x+(point.x - startTouchPoint.x), y: self.center.y+(point.y-startTouchPoint.y))
        
        //对newCenter进行矫正处理：不能偏移出界
        let midPointX = CGRectGetMaxX(self.bounds)
        if newCenter.x > self.superview!.bounds.size.width + midPointX - minSize.width/2.0 {
            newCenter.x = self.superview!.bounds.size.width + midPointX - minSize.width/2.0
        }
        
        if newCenter.x < minSize.width/2.0 - midPointX {
            newCenter.x = minSize.width/2.0 - midPointX
        }
        
        let midPointY = CGRectGetMaxY(self.bounds)
        if newCenter.y > self.superview!.bounds.size.height + midPointY - minSize.width/2.0 {
            newCenter.y = self.superview!.bounds.size.height + midPointY - minSize.width/2.0
        }
        
        if newCenter.y < minSize.height/2.0 - midPointY {
            newCenter.y = minSize.height/2.0 - midPointY
        }
        
        self.center = newCenter
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        deleteView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        sizeView.frame = CGRect(x: self.bounds.size.width - iconSize.width, y: self.bounds.size.height - iconSize.height, width: iconSize.width, height: iconSize.height)
        rotateView.frame = CGRect(x: 0, y: self.bounds.size.height - iconSize.height, width: iconSize.width, height: iconSize.height)
        contentView.frame = CGRect(x: iconSize.width/2.0, y: iconSize.height/2.0, width: self.bounds.size.width - iconSize.width, height: self.bounds.size.height - iconSize.height)
    }
    
    
}
