//
//  FirstViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit
import CoreImage

class FirstViewController: UIViewController {
    
    @IBOutlet weak var BarcodeImageView: UIImageView!   //二维码
    
    @IBOutlet weak var BarcodeTextField: UITextField!
    
    @IBOutlet weak var createBarcodeBtn: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "二维码"

        //设置导航栏右侧按钮
        let rightItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(rightBtnAction))
        self.navigationItem.rightBarButtonItem = rightItem
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: 生成二维码
    @IBAction func createBarcodeAction(sender: UIButton) {

        BarcodeImageView.image = createQRForString("www.baidu.com", qrImage: UIImage(named: "rabbit"), color: UIColor.blueColor())
    }
    
    
    
    //TODO: 右键按钮方法
    func rightBtnAction() {
        
        
        
    }


    
    /*****************************生成二维码*************************************/
    /**
     创建二维码图片
     
     - parameter qrString: 内容
     - parameter qrImage:  logo图片
     - parameter color:    二维码颜色
     
     - returns: 二维码图片
     */
    func createQRForString(qrString: String?, qrImage: UIImage?, color: UIColor?) -> UIImage?{
        if let sureQRString = qrString {
            let stringData = sureQRString.dataUsingEncoding(NSUTF8StringEncoding,
                                                            allowLossyConversion: false)
            // 创建一个二维码的滤镜
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")!
            qrFilter.setValue(stringData, forKey: "inputMessage")
            qrFilter.setValue("H", forKey: "inputCorrectionLevel")
            let qrCIImage = qrFilter.outputImage
            // 创建一个颜色滤镜,设置二维码验证
            let colorFilter = CIFilter(name: "CIFalseColor")!
            colorFilter.setDefaults()
            colorFilter.setValue(qrCIImage, forKey: "inputImage")
            if let col = color {
                colorFilter.setValue(CIColor(color: col), forKey: "inputColor0")
            } else {
                colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
            }
            colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            
            
            // 返回二维码image
            let codeImage = UIImage(CIImage: colorFilter.outputImage!
                .imageByApplyingTransform(CGAffineTransformMakeScale(5, 5)))
            // 通常,二维码都是定制的,中间都会放想要表达意思的图片
            if let iconImage = qrImage {
                let rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height)
                UIGraphicsBeginImageContext(rect.size)
                
                codeImage.drawInRect(rect)
                let avatarSize = CGSizeMake(rect.size.width * 0.25, rect.size.height * 0.25)
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.drawInRect(CGRectMake(x, y, avatarSize.width, avatarSize.height))
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                return resultImage
            }
            return codeImage
        }
        return nil
    }

    
    
/******************************************************************************/

}
