//
//  WordView.swift
//  NinePictureDemo
//
//  Created by XiaLuo on 16/8/29.
//  Copyright © 2016年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

class WordView: UIView {
    
    let btnWidth: CGFloat = 40*PROPORTION_BASIC6P
    let btnHorSpace = (WIDTH-40*PROPORTION_BASIC6P*6+10)/7
    let btnLeft = (WIDTH-40*PROPORTION_BASIC6P*6+10)/7-5
    let tfBgVHeight: CGFloat = 50*PROPORTION_BASIC6P
    
    var imgVBgV = UIView()
    var tf = UITextField()
    var lastBtn = UIButton()
    
    init(frame: CGRect, imgVBgView: UIView) {
        super.init(frame: frame)
        
        imgVBgV = imgVBgView
        
        initBottomView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化下方按钮
    private func initBottomView() {
        
        let btnVerSpace: CGFloat = (frame.height-btnWidth*2-tfBgVHeight+30)/4
        let tfTop: CGFloat = btnVerSpace-10
        let btnTop: CGFloat = btnVerSpace-15
        
        let tfBgV = UIView.init(frame: CGRectMake(btnLeft, tfTop, WIDTH-2*btnLeft, tfBgVHeight))
        tfBgV.layer.cornerRadius = 8
        tfBgV.layer.borderWidth = 1
        tfBgV.layer.borderColor = UIColor.init(rgba: "#bcbcbc").CGColor
        addSubview(tfBgV)
        
        tf = CustomTextField.init(frame: CGRectMake(10, 0, tfBgV.frame.width-10-80*PROPORTION_BASIC6P, tfBgVHeight))
        tf.font = UIFont.systemFontOfSize(15)
        tf.placeholder = "请输入文字，最多输入9个"
        tfBgV.addSubview(tf)
        
        let productBtn = CustomButton.init(frame: CGRectMake(tfBgV.frame.width-80*PROPORTION_BASIC6P, 0, 80*PROPORTION_BASIC6P, tfBgVHeight))
        productBtn.backgroundColor = UIColor.init(rgba: "#bcbcbc")
        productBtn.layer.cornerRadius = 8
        productBtn.setTitle("生成", forState: .Normal)
        productBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        productBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        productBtn.addTarget(self, action: #selector(WordView.productBtnBtnAction(_:)), forControlEvents: .TouchUpInside)
        tfBgV.addSubview(productBtn)
        
        for i in 0...1 {
            for j in 0...5 {
                let btn = UIButton.init(frame: CGRectMake(btnLeft+(btnWidth+btnHorSpace)*CGFloat(j), tfTop+tfBgVHeight+btnTop+(btnWidth+btnVerSpace)*CGFloat(i), btnWidth, btnWidth))
                btn.backgroundColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
                if i==0 && j==0 {
                    lastBtn = btn
                    lastBtn.layer.cornerRadius = 3
                    lastBtn.layer.borderColor = UIColor.init(rgba: "#666666").CGColor
                    lastBtn.layer.borderWidth = 2
                }
                btn.tag = i*5+j
                btn.addTarget(self, action: #selector(WordView.colorBtnsAction(_:)), forControlEvents: .TouchUpInside)
                addSubview(btn)
            }
        }
    }

    
    //MARK: - 功能详细按钮的方法
    func colorBtnsAction(btn: UIButton) {
        
        lastBtn.layer.cornerRadius = 0
        lastBtn.layer.borderWidth = 0
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.init(rgba: "#666666").CGColor
        btn.layer.borderWidth = 2
        lastBtn = btn
    }
    
    //MARK: - 生成按钮的方法
    func productBtnBtnAction(btn: UIButton) {
        imgArray = saveImg.separateImageAndDescripetion(byX: 3, andY: 3, descripetion: tf.text, textColor: lastBtn.backgroundColor)!
        for i in 0..<imgVBgV.subviews.count {
            (imgVBgV.viewWithTag(100+i) as! UIImageView).image = imgArray[i]
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
