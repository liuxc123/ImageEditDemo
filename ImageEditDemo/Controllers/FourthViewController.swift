//
//  FourthViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit
import PEPhotoCropEditor

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

class FourthViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, PECropViewControllerDelegate {

    @IBOutlet weak var accessoryBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    var myPaster: MyPaster!
    var imagePasterNum: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialNav()
        initWork()
    }
    
    func initWork() {
        myPaster = MyPaster(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 40))
        myPaster.backgroundColor = UIColor.lightGrayColor()
        myPaster.deleteIcon = UIImage(named: "paster_delete")
        myPaster.sizeIcon = UIImage(named: "paster_size")
        myPaster.rotateIcon = UIImage(named: "paster_rotate")
        self.contentView.addSubview(myPaster)
    }

    func initialNav() {
        self.title = "贴图"
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(savePicAction))
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(addPicAction))
        
        self.navigationItem.rightBarButtonItems = [rightItem, addItem]
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    //MARK: - 添加饰品方法
    @IBAction func addAccessoryAction(sender: UIButton) {
        let imagePaster = ImagePaster()
        imagePaster.size = CGSize(width: 100, height: 100)
        
        imagePaster.image = UIImage(named: "paster_\(imagePasterNum)")
        imagePasterNum += 1
        if imagePasterNum >= 4 {
            imagePasterNum = 0
        }
        myPaster.addPaster(imagePaster)
    }
    
    //MARK: - 添加文字方法
    @IBAction func addTextAction(sender: UIButton) {
        
        let textPaster = TextPaster()
        textPaster.size = CGSize(width: 200, height: 100)
        textPaster.text = "请输入文字"
        myPaster.addPaster(textPaster)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //TODO: 添加背景图片
    func addPicAction() {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册","相机")
        actionSheet.showInView(self.view)
      
    }

    //TODO: 保存图片
    func savePicAction() {

        let resultImage = myPaster.pasterImage
        
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
        let navigationController = UINavigationController(rootViewController: cropVC)
        picker.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    //MARK: - PECropViewControllerDelegate
    func cropViewControllerDidCancel(controller: PECropViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {

        myPaster.originImage = croppedImage!
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
