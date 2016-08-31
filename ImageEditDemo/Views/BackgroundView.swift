//
//  BackgroundView.swift
//  NinePictureDemo
//
//  Created by XiaLuo on 16/8/29.
//  Copyright © 2016年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

class BackgroundView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let btnWidth: CGFloat = 40*PROPORTION_BASIC6P
    let btnHorSpace = (WIDTH-40*PROPORTION_BASIC6P*6+10)/7
    let btnLeft = (WIDTH-40*PROPORTION_BASIC6P*6+10)/7-5
    
    var imgVBgV = UIView()
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
        let btnVerSpace: CGFloat = (frame.height-btnWidth*3+10)/4
        let btnTop: CGFloat = btnVerSpace-5
        for i in 0...2 {
            for j in 0...5 {
                let btn = UIButton.init(frame: CGRectMake(btnLeft+(btnWidth+btnHorSpace)*CGFloat(j), btnTop+(btnWidth+btnVerSpace)*CGFloat(i), btnWidth, btnWidth))
                if i==0 && j==0 {
                    btn.setBackgroundImage(UIImage.init(named: "photo"), forState: .Normal)
                } else if i==0 && j==1 {
                    btn.backgroundColor = color
                    lastBtn = btn
                    lastBtn.layer.cornerRadius = 3
                    lastBtn.layer.borderColor = UIColor.init(rgba: "#666666").CGColor
                    lastBtn.layer.borderWidth = 2
                } else {
                    btn.backgroundColor = UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
                }
                btn.tag = i*5+j
                btn.addTarget(self, action: #selector(SecondViewController.functionBtnsAction(_:)), forControlEvents: .TouchUpInside)
                addSubview(btn)
            }
        }
    }
    
    //MARK: - 功能详细按钮的方法
    func functionBtnsAction(btn: UIButton) {
        
        lastBtn.layer.cornerRadius = 0
        lastBtn.layer.borderWidth = 0
        btn.layer.cornerRadius = 3
        btn.layer.borderColor = UIColor.init(rgba: "#666666").CGColor
        btn.layer.borderWidth = 2
        lastBtn = btn
        
        switch btn.tag {
        case 0:
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .PhotoLibrary
                picker.allowsEditing = true
                getInvoker().presentViewController(picker, animated: true, completion: nil)
            }
        default:
            saveImg = UIImage.createImageWithColor(btn.backgroundColor!)
            imgArray = saveImg.separateImage(byX: 3, andY: 3)!
            for i in 0..<imgVBgV.subviews.count {
                (imgVBgV.viewWithTag(100+i) as! UIImageView).image = imgArray[i]
            }
        }
    }
    
    //MARK: - 获取裁剪后的image
    func getNinePicture(image _image: UIImage) {
        saveImg = _image
        imgArray = _image.separateImage(byX: 3, andY: 3)!
        //imgArray = _image.separateImageAndDescripetion(byX: 3, andY: 3, descripetion: "G20杭州欢迎您！")!
        for i in 0..<imgVBgV.subviews.count {
            (imgVBgV.viewWithTag(100+i) as! UIImageView).image = imgArray[i]
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        getNinePicture(image: image)
        getInvoker().dismissViewControllerAnimated(true, completion: nil)
    }
    
    



    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
