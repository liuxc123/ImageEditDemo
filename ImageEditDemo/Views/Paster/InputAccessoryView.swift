//
//  InputAccessoryView.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/31.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {

    
    /**
     *  颜色按钮
     */
    var colorBtn: UIButton!
    /**
     *  完成按钮
     */
    var completeBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialButtonView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
     *  初始化创建button
     */
    func initialButtonView() {
        //选择颜色按钮
        colorBtn = UIButton(frame: CGRect(x: 10, y: 5, width: 30, height: self.frame.size.height - 10))
        colorBtn.setTitle("颜色", forState: .Normal)
        colorBtn.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        self.addSubview(colorBtn)
        
        colorBtn.addTarget(self, action: #selector(chooseColorAction(_:)), forControlEvents: .TouchUpInside)
        
        //完成按钮
        completeBtn = UIButton(frame: CGRect(x: SCREEN_WIDTH - 40, y: colorBtn.bounds.origin.y, width: 30, height: colorBtn.bounds.size.height))
        completeBtn.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        completeBtn.setTitle("完成", forState: .Normal)
        self.addSubview(completeBtn)

        completeBtn.addTarget(self, action: #selector(completeAction(_:)), forControlEvents: .TouchUpInside)
    }
    
    
    /**
     完成按钮方法
     */
    func completeAction(sender: UIButton) {
        self.endEditing(true)
    }
    
    /**
     选择颜色按钮方法
     */
    func chooseColorAction(sender: UIButton) {
        
        if sender.selected {
            /**
             选中的
             */
            
            
            
        } else {
            /**
             未选中的
             */
        }
        
        sender.selected = !sender.selected
    }
    
    
    
    
    

    
}

/**
 弹出选择层
 */
class InputColorAccessoryView: UIView {
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     初始化TableView
     */
    func initTableView(){
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 5, width: self.frame.size.width, height: self.frame.size.height - 10), collectionViewLayout: flowLayout)
        collectionView.
    }
    
    
    
}
