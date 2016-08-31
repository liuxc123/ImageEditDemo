//
//  Paster.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/30.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit



////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////      Paster     /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  Paster基类
 */
class Paster: NSObject {
    /**
     *  贴花尺寸
     *  图片类型默认为120x120：即初始化出的贴花尺寸；非方形图片会等比缩放。
     *  文字类型默认为160x80：即初始化出的贴花尺寸；非方形图片会等比缩放。
     */
    var size: CGSize?
}



////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////   ImagePaster   /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/**
 *  Paster图片类
 */
class ImagePaster: Paster {
    /**
     *  图片
     */
    var image: UIImage? {
        didSet {
            //设置图片大小
            if let image = image {
               self.size = CGSize(width: image.size.width, height: image.size.height)
            }
        }
    }
    
    
    override init() {
        super.init()
        self.size = CGSize(width: 100, height: 100)
    }
    
}


////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////    TextPaster   /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/**
 *  Paster文本类
 */
class TextPaster: Paster {
    /**
     *  文本内容
     */
    var text: String = ""
    /**
     *  文本颜色
     */
    var textColor: UIColor!
    /**
     *  文本字体 -- 忽略大小
     */
    var font: UIFont!
    
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////                      //////////////////////////////
////////////////////////////   MyPasterDelegate   //////////////////////////////
////////////////////////////                      //////////////////////////////
////////////////////////////////////////////////////////////////////////////////

protocol MyPasterDelegate {
    /**
     *  pasterIsSelect
     *
     *  @param myPaster myPaster
     *  @param paster   selectPaster
     */
    func pasterIsSelect(myPaster: MyPaster, selectorPaster: Paster)
}



////////////////////////////////////////////////////////////////////////////////
//////////////////////////////                 /////////////////////////////////
//////////////////////////////     MyPaster    /////////////////////////////////
//////////////////////////////                 /////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class MyPaster: UIView {
    /**
     *  MyPasterDelegate
     */
    var delegate: MyPasterDelegate?
    
    /**
     *  原始图片
     */
    var originImage: UIImage? {
        didSet{
            contentImageView.image = originImage
            self.setNeedsLayout()
        }
    }
    /**
     *  贴花后生成的图片
     */
    var pasterImage: UIImage? {
        
        get {
            //取消选中
            self.currentSelectPasterItem = nil
            return getPasterImage()
        }
    }
    /**
     *  删除按钮图片
     */
    var deleteIcon: UIImage? {
        didSet{
            for subview in contentImageView.subviews {
                if subview is PasterItem {
                    (subview as! PasterItem).deleteIcon = deleteIcon
                }
            }
        }
    }
    /**
     *  尺寸控制按钮图片
     */
    var sizeIcon: UIImage? {
        didSet{
            for subview in contentImageView.subviews {
                if subview is PasterItem {
                    (subview as! PasterItem).sizeIcon = sizeIcon
                }
            }
        }
    }
    /**
     *  旋转按钮图片
     */
    var rotateIcon: UIImage? {
        didSet{
            for subview in contentImageView.subviews {
                if subview is PasterItem {
                    (subview as! PasterItem).rotateIcon = rotateIcon
                }
            }
        }
    }
    /**
     *  按钮尺寸 -- 默认为30x30
     */
    var iconSize: CGSize! {
        didSet {
            for subview in contentImageView.subviews {
                if subview is PasterItem {
                    (subview as! PasterItem).iconSize = iconSize
                }
            }
        }
    }
    /**
     *  currentPaster
     */
    var currentPaster: Paster! {
        didSet{
            currentSelectPasterItem?.paster = currentPaster
        }
    }
    /**
     *  底层内容图
     */
    var contentImageView: UIImageView!
    /**
     *  当前选中的PasterItem
     */
    var currentSelectPasterItem: PasterItem? {
        didSet {
            //设置当前选中的item
            setCurrentSelectPaster(currentSelectPasterItem)
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        iconSize = CGSize(width: 30, height: 30)
        initialView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     *  初始化view
     */
    func initialView() {
        //底层内容图
        contentImageView = UIImageView()
        contentImageView.userInteractionEnabled = true
        contentImageView.clipsToBounds = true
        self.addSubview(contentImageView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGes(_:)))
        self.addGestureRecognizer(tapGes)
    }
    
    /**
     *  页面点击 -- 取消选中状态
     *
     *  @param ges 点击手势
     */
    func tapGes(ges: UITapGestureRecognizer) {
        if currentSelectPasterItem == nil {
            return
        }
        
        let gesPoint = ges.locationInView(self)
        let contentRect = contentImageView.frame
        
        if CGRectContainsPoint(contentRect, gesPoint) {
            //在目标之内 -- KVC
            let itemRect = currentSelectPasterItem!.convertRect(currentSelectPasterItem!.bounds, toView: self)
            if !CGRectContainsPoint(itemRect, gesPoint) {
                currentSelectPasterItem!.isSelect = false
                currentSelectPasterItem = nil
            }
        } else {
            //在目标之外 -- KVC
            currentSelectPasterItem!.isSelect = false
            currentSelectPasterItem = nil
        }
        
        
    }
    
    //MARK: - 添加贴花
    /**
     *  添加贴花 -- 位置随机
     *
     *  @param paster Paster
     */
    func addPaster(paster: Paster) {
        if paster is ImagePaster {
            self.addImagePaster(paster as! ImagePaster)
        }
        
        if paster is TextPaster {
            self.addTextPaster(paster as! TextPaster)
        }
    }
    
    
    /**
     *  添加贴花 -- 图片类型
     *
     *  @param paster 贴花
     */
    func addImagePaster(paster: ImagePaster){
        //创建一个pasterItem对象，并且添加到底层图片上
        if contentImageView.image != nil {
            let imageSize = self.getPasterImageSize(paster)
            let tpPoint = self.getPasterImagePoint(imageSize)
            let imagePasterItem = ImagePasterItem(frame: CGRect(x: tpPoint.x, y: tpPoint.y, width: imageSize.width, height: imageSize.height), myPaster: self)
            imagePasterItem.paster = paster
            imagePasterItem.deleteIcon = deleteIcon
            imagePasterItem.sizeIcon = sizeIcon
            imagePasterItem.rotateIcon = rotateIcon
            imagePasterItem.iconSize = iconSize
            contentImageView.addSubview(imagePasterItem)
            imagePasterItem.addPasterItemWithAnimation()

            imagePasterItem.addTouch({[unowned self] (pasterItem)  in
                self.currentSelectPasterItem = pasterItem
                //delegate
                self.delegate?.pasterIsSelect(self, selectorPaster: self.currentSelectPasterItem!.paster)
            })
            
            self.currentSelectPasterItem = imagePasterItem
        }
        
    }
    
    /**
     *  添加贴花 -- 文字类型
     *
     *  @param paster 贴花
     */
    func addTextPaster(paster: TextPaster) {
        //创建一个pasterItem对象，并且添加到底层图片上
        if contentImageView.image != nil {
            //随机贴纸位置
            let tpPoint = self.getPasterImagePoint(paster.size!)
            let textPasterItem = TextPasterItem(frame: CGRect(x: tpPoint.x, y: tpPoint.y, width: paster.size!.width, height: paster.size!.height), myPaster: self)
            textPasterItem.paster = paster
            textPasterItem.deleteIcon = deleteIcon
            textPasterItem.sizeIcon = sizeIcon
            textPasterItem.rotateIcon = rotateIcon
            textPasterItem.iconSize = iconSize
            contentImageView.addSubview(textPasterItem)
            textPasterItem.addPasterItemWithAnimation()
            
            textPasterItem.addTouch({[unowned self] (pasterItem)  in
                self.currentSelectPasterItem = pasterItem
                //delegate
                self.delegate?.pasterIsSelect(self, selectorPaster: self.currentSelectPasterItem!.paster)
            })
            
            self.currentSelectPasterItem = textPasterItem
        }
        
    }
    
    /**
     *  设置当前选中的item
     *
     *  @param currentSelectPaster 当前选中的item
     */
    func setCurrentSelectPaster(currentSelectPasterItem: PasterItem?) {
       
        if currentSelectPasterItem == nil {
            //没有选中行
            for subview in contentImageView.subviews {
                if subview is PasterItem {
                    (subview as! PasterItem).isSelect = false
                }
            }
        } else {
            //有选中行
            for subview in contentImageView.subviews {
                if subview is PasterItem {
                    if subview == currentSelectPasterItem {
                        //发现自己，则将当前选中item，则通过KVC将item设置为选中状态
                        (subview as! PasterItem).isSelect = true
                    } else {
                        //没有发现自己，则将当前选中item，则通过KVC将item设置为未选中状态
                        (subview as! PasterItem).isSelect = false
                    }
                }
                
            }
            
        }
    }
    
    
    
    /**
     *  getPasterImage
     *
     *  @return pasterImage
     */
    func getPasterImage() -> UIImage? {
        //取消选中
        self.currentSelectPasterItem = nil
        return getImageFromView(contentImageView)
    }
    
    /**
     *  获取图片展示尺寸
     *
     *  @param image 原始图片
     *
     *  @return 转换后的尺寸
     */
    func getImageSize(image: UIImage?) -> CGSize{
        var size = CGSizeZero
        if image != nil {
            let imageRate = image!.size.width/image!.size.height
            let selfRate = self.bounds.size.width/self.bounds.size.height
            if imageRate > selfRate {
                //图片顶左右边
                size.width = self.bounds.size.width
                size.height = image!.size.height/image!.size.width*self.bounds.size.width
            } else {
                //图片顶上下边
                size.width = image!.size.width/image!.size.height*self.bounds.size.height
                size.height = self.bounds.size.height
            }
        }
        return size
    }
    
    
    /**
     *  获取贴花展示尺寸
     *
     *  @param image 贴花
     *
     *  @return 贴花尺寸
     */
    func getPasterImageSize(paster: ImagePaster) -> CGSize{
        var size = CGSizeZero
        if paster.image != nil {
            
            if paster.image?.size.width > paster.image?.size.height {
                //宽大于高
                size.width = paster.size!.width
                size.height = paster.image!.size.height/paster.image!.size.width*paster.size!.width
            } else {
                //宽不大于
                size.width = paster.image!.size.width/paster.image!.size.height*paster.size!.height;
                size.height = paster.size!.height
            }
            
        }
        return size
    }
    
    /**
     *  获取贴纸起点
     *
     *  @param size 贴纸尺寸
     *
     *  @return 贴纸起点
     */
    func getPasterImagePoint(size: CGSize) -> CGPoint{
        var tpPoint = CGPointZero
        if contentImageView.bounds.size.width - 40.0 > size.width {
            tpPoint.x = CGFloat(arc4random() % UInt32(contentImageView.bounds.size.width - 20.0 - size.width)) + 20
        } else {
             tpPoint.x = contentImageView.bounds.size.width/2.0 - size.width/2.0
        }
        
        if contentImageView.bounds.size.height - 40.0 > size.height {
            tpPoint.y = CGFloat(arc4random() % UInt32(contentImageView.bounds.size.height - 20.0 - size.height)) + 20
        } else {
            tpPoint.y = contentImageView.bounds.size.height/2.0 - size.height/2.0
        }
        return tpPoint
    }
    
    
    /**
     *  视图转image
     *
     *  @param view 目标视图
     *
     *  @return 转换后的image
     */
    func getImageFromView(view: UIView)-> UIImage? {
        if view.bounds.size.width == 0 || view.bounds.size.height == 0 {
            return nil
        } else {
            let orgSize = view.bounds.size
            UIGraphicsBeginImageContextWithOptions(orgSize, true, UIScreen.mainScreen().scale)
            view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resultImage
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if contentImageView.image != nil {
            let contentImageSize = self.getImageSize(contentImageView.image)
            contentImageView.frame = CGRect(x: 0, y: 0, width: contentImageSize.width, height: contentImageSize.height)
        } else {
            contentImageView.frame = CGRectZero
        }
        
        contentImageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0)
    }
    
    
    
}




