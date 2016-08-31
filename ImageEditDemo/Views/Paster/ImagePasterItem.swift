//
//  ImagePasterItem.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/30.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class ImagePasterItem: PasterItem {
    
    var imageView: UIImageView!

    override init(frame: CGRect, myPaster: MyPaster) {
        super.init(frame: frame, myPaster: myPaster)
         initialMyImagePasterItemView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialMyImagePasterItemView() {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(imageView)
    }
    
    override var paster: Paster! {
        didSet{
            if paster is ImagePaster {
                imageView.image = (paster as! ImagePaster).image
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height)
    }
    

}
