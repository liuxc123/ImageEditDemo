//
//  FirstViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit
import CoreImage
import PEPhotoCropEditor

class FirstViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, PECropViewControllerDelegate {
    
    @IBOutlet weak var BarcodeImageView: UIImageView!   //二维码
    
    @IBOutlet weak var BarcodeTextField: UITextField!
    
    @IBOutlet weak var createBarcodeBtn: UIButton!
    
    var logoImage: UIImage?
    var barcodeColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "二维码"

        //设置导航栏右侧按钮
        let rightItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(rightBtnAction))
        let addItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(addPicAction))
        self.navigationItem.rightBarButtonItems = [rightItem, addItem]
        
        initEditPasterView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     *   键盘编辑层
     */
    func initEditPasterView() {
        let inputAccessoryView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
        inputAccessoryView.backgroundColor  = UIColor.clearColor()
        BarcodeTextField.inputAccessoryView = inputAccessoryView
        
        //选择颜色
        inputAccessoryView.inPutColorView.selectColorBlock = {[unowned self] color in
            self.barcodeColor = color
            self.createBarcodeAction(self.createBarcodeBtn)
        }
        //完成操作
        inputAccessoryView.completeBlock = {[unowned self] in
            self.BarcodeTextField.resignFirstResponder()
        }
    }
    
    //TODO: 生成二维码
    @IBAction func createBarcodeAction(sender: UIButton) {
        BarcodeImageView.image = createQRForString(BarcodeTextField.text, qrImage: logoImage, color: barcodeColor)
    }
    
    
    
    //TODO: 右键按钮方法
    func rightBtnAction() {
        let resultImage = BarcodeImageView.image
        
        if resultImage != nil {
            // 存储到自己的相册
            UIImageWriteToSavedPhotosAlbum(resultImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }


    // 图片存储后的情况提醒方法
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        
        if didFinishSavingWithError != nil {
            
            let alert = UIAlertView(title: "", message: "保存失败", delegate: self, cancelButtonTitle: nil)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*NSEC_PER_SEC)), dispatch_get_main_queue(), {
                alert.dismissWithClickedButtonIndex(0, animated: false)
                
            })
            alert.show()
            print("Error")
            return
        }
        else {
            let alert = UIAlertView(title: "", message: "已存入手机相册", delegate: self, cancelButtonTitle: nil)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1*NSEC_PER_SEC)), dispatch_get_main_queue(), {
                alert.dismissWithClickedButtonIndex(0, animated: false)
                
            })
            
            alert.show()
            print("OK")
        }
        
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
    
    //TODO: 添加背景图片
    func addPicAction() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册","相机")
        actionSheet.showInView(self.view)
        
    }
    
    //MARK: - UIActionSheet Delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if buttonIndex == 1 {
            
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                picker.allowsEditing = false
                self.presentViewController(picker, animated: true, completion: nil)
            }else{
                print("此设备不支持相册")
            }
            
        }else if buttonIndex == 2 {
            
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = UIImagePickerControllerSourceType.Camera
                picker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
                self.presentViewController(picker, animated: true, completion: nil)
            }else{
                print("此设备不支持相机")
            }
            
        }else{
            print("取消操作")
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //进入编辑界面
        let cropVC = PECropViewController()
        cropVC.image = image
        cropVC.delegate = self
        cropVC.cropAspectRatio = 1
        let navigationController = UINavigationController(rootViewController: cropVC)
        picker.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    //MARK: - PECropViewControllerDelegate
    func cropViewControllerDidCancel(controller: PECropViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        
        logoImage = croppedImage!
        
        //生成二维码
        createBarcodeAction(createBarcodeBtn)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
