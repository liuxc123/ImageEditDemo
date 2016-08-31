//
//  textImageView.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/28.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class textImageView: UIImageView {
    
    let context = UIGraphicsGetCurrentContext()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let ytextView = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        ytextView.backgroundColor = UIColor.orangeColor()
        ytextView.text = "请输入"
        ytextView.textAlignment = .Center
        ytextView.font = UIFont.systemFontOfSize(16)
        self.addSubview(ytextView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
