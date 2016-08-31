//
//  ImagesBgView.swift
//  NinePictureDemo
//
//  Created by XiaLuo on 16/8/29.
//  Copyright © 2016年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

let imgVSpace: CGFloat = 5
let imgVleft: CGFloat = 45*PROPORTION_BASIC6P
let imgVWidth: CGFloat = (WIDTH-45*PROPORTION_BASIC6P*2-5*2)/3
let color = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)

class ImagesBgView: UIView {
    
    var imgVBgVH = NSLayoutConstraint()
    
    init(frame: CGRect, imgVBgVHeight: NSLayoutConstraint) {
        super.init(frame: frame)
        
        initImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 初始化imageView
    private func initImageView() {
        imgVBgVH.constant = 3*imgVWidth+2*imgVSpace
        saveImg = UIImage.createImageWithColor(color)
        imgArray = saveImg.separateImage(byX: 3, andY: 3)!
        for i in 0...2 {
            for j in 0...2 {
                let imgV = UIImageView.init(frame: CGRectMake(imgVleft+(imgVWidth+imgVSpace)*CGFloat(j), (imgVWidth+imgVSpace)*CGFloat(i), imgVWidth, imgVWidth))
                imgV.image = imgArray[i*3+j]
                imgV.tag = 100+i*3+j
                addSubview(imgV)
            }
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
