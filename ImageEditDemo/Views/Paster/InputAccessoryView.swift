//
//  InputAccessoryView.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/31.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {
    typealias CompleteBlock = () -> Void

    var completeBlock: CompleteBlock?
    /**
     *  底部View
     */
    var bottomView: UIView!
    /**
     *  颜色按钮
     */
    var colorBtn: UIButton!
    /**
     *  完成按钮
     */
    var completeBtn: UIButton!
    /**
     *  颜色选择层
     */
    lazy var inPutColorView: InputColorAccessoryView = {
        let inPutColorView = InputColorAccessoryView(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: 50))
        return inPutColorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        initialButtonView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     *  初始化创建button
     */
    func initialButtonView() {
        bottomView = UIView(frame: CGRect(x: 0, y: 50, width: self.frame.size.width, height: 50))
        bottomView.backgroundColor = UIColor(red: 230, green: 230, blue: 230, alpha: 1)
        self.addSubview(bottomView)
        
        //选择颜色按钮
        colorBtn = UIButton(frame: CGRect(x: 10, y: 5, width: 50, height: 40))
        colorBtn.setTitle("颜色", forState: .Normal)
        colorBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        bottomView.addSubview(colorBtn)
        
        colorBtn.addTarget(self, action: #selector(chooseColorAction(_:)), forControlEvents: .TouchUpInside)
        
        //完成按钮
        completeBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - 60, y: 5, width: 50, height: 40))
        completeBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        completeBtn.setTitle("完成", forState: .Normal)
        bottomView.addSubview(completeBtn)
        
        completeBtn.addTarget(self, action: #selector(completeAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    /**
     完成按钮方法
     */
    func completeAction(sender: UIButton) {
        self.inPutColorView.frame.origin.y = 50
        self.inPutColorView.removeFromSuperview()
        colorBtn.selected = false
        completeBlock?()
    }
    
    /**
     选择颜色按钮方法
     */
    func chooseColorAction(sender: UIButton) {
        
        if sender.selected {
            /**
             未选中的
             */
            self.bringSubviewToFront(bottomView)
            UIView.animateWithDuration(0.3, animations: { 
                self.inPutColorView.frame.origin.y = 50
                }, completion: { (complete) in
                    self.inPutColorView.removeFromSuperview()
            })
            
           
        } else {
            /**
             选中的
             */
            self.addSubview(self.inPutColorView)
            self.bringSubviewToFront(bottomView)
            UIView.animateWithDuration(0.3, animations: { 
                self.inPutColorView.frame.origin.y = 0
            })
            
        }
        
        sender.selected = !sender.selected
    }
    
    
    
    
    

    
}

/**
 弹出选择层
 */
class InputColorAccessoryView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    typealias SelectorColorBlock = (UIColor) -> Void
    
    var selectColorBlock: SelectorColorBlock?
    /**
     *  绘制箭头参数
     */
    let kMargin: CGFloat = 10               //距离线的间隙
    let kArrorHeight: CGFloat = 10          //箭头高度
    /**
     *  collectionView
     */
    var collectionView: UICollectionView!
    /**
     *  collectionView
     */
    var colorArray = [UIColor]()
    /**
     *  selectColor
     */
    var selectColorNum: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = true
        setColor()
        initTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setColor() {
        let color0 = UIColor.blackColor()
        let color1 = UIColor.darkGrayColor()
        let color2 = UIColor.lightGrayColor()
        let color3 = UIColor.whiteColor()
        let color4 = UIColor.grayColor()
        let color5 = UIColor.redColor()
        let color6 = UIColor.greenColor()
        let color7 = UIColor.blueColor()
        let color8 = UIColor.cyanColor()
        let color9 = UIColor.yellowColor()
        let color10 = UIColor.magentaColor()
        let color11 = UIColor.orangeColor()
        let color12 = UIColor.purpleColor()
        let color13 = UIColor.brownColor()
        
        colorArray = [color0, color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11, color12, color13]
    }
    
    
    
    /**
     初始化TableView
     */
    func initTableView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(self.frame.size.height - 10, self.frame.size.height - 10 - 10)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 5
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 10), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(collectionView)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "ColorCell")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = colorArray[indexPath.item]
        
        if selectColorNum == indexPath.item {
            cell.layer.borderColor = UIColor(red: 0, green: 117, blue: 250, alpha: 1).CGColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
        } else {
            cell.layer.borderColor = UIColor.clearColor().CGColor
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectColorNum = indexPath.item
        selectColorBlock?(colorArray[indexPath.item])
        collectionView.reloadData()
    }
    
    override func drawRect(rect: CGRect) {
        self.drawInContext(UIGraphicsGetCurrentContext()!)
        
        self.layer.shadowOpacity = 0.902
        self.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
    }
    
    func drawInContext(context: CGContextRef) {
        CGContextSetLineWidth(context, 1)
        CGContextSetFillColorWithColor(context, UIColor(red: 230, green: 230, blue: 230, alpha: 1).colorWithAlphaComponent(0.8).CGColor)
        self.getDrawPath(context)
        CGContextFillPath(context)
        CGContextStrokePath(context)
    }
    
    func getDrawPath(context: CGContextRef) {
        let rrect = self.bounds
        let radius: CGFloat = 0
        let minx = CGRectGetMinX(rrect)
        let midx: CGFloat = 35
        let maxx = CGRectGetMaxX(rrect)
        let miny = CGRectGetMinY(rrect)
        let maxy = CGRectGetMaxY(rrect) - kArrorHeight
        
        CGContextMoveToPoint(context, midx + kArrorHeight, maxy)
        CGContextAddLineToPoint(context, midx, maxy + kArrorHeight)
        CGContextAddLineToPoint(context, midx - kArrorHeight, maxy)
        
        CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius)
        CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius)
        CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius)
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius)
        CGContextClosePath(context)
    }
    
}
