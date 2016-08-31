//
//  SecondViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

var imgArray = [UIImage]()
var saveImg = UIImage()

class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var functionBgV: UIView!
    
    @IBOutlet weak var imgVBgV: UIView!
    
    @IBOutlet weak var imgVBgVH: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.navigationItem.title = "9格切图"
        
        imgVBgV.addSubview(imagesBgView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        functionBgV.addSubview(backgroundView)
    }
    
    //MARK: - 保存按钮的方法
    @IBAction func saveAction(sender: UIBarButtonItem) {
        savePictureNext()
    }
    
    //MARK: - 功能按钮的方法
    @IBAction func functionBtnsAction(sender: UIButton) {
        
        barView.frame.size.width = sender.frame.width
        barView.center.x = sender.center.x
        
        for view in functionBgV.subviews {
            view.removeFromSuperview()
        }
        
        switch sender.tag {
        case 1:
            functionBgV.addSubview(backgroundView)
        case 2:
            functionBgV.addSubview(wordView)
            
        case 3:
            break
            
        default:
            break
        }
    }
    
    lazy var imagesBgView: ImagesBgView = {
        self.imgVBgVH.constant = 3*imgVWidth+2*imgVSpace
        let _imagesBgView = ImagesBgView(frame: self.imgVBgV.bounds, imgVBgVHeight: self.imgVBgVH)
        return _imagesBgView
    }()
    
    lazy var backgroundView: BackgroundView = {
        let _backgroundView = BackgroundView(frame: self.functionBgV.bounds, imgVBgView: self.imagesBgView)
        return _backgroundView
    }()
    
    lazy var wordView: WordView = {
        let _wordView = WordView(frame: self.functionBgV.bounds, imgVBgView: self.imagesBgView)
        return _wordView
    }()
    
    //MARK: - 保存图片到相册
    func savePictureNext() {
        if imgArray.count > 0 {
            let image = imgArray[0]
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(SecondViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            print(error)
            return
        } else {
            imgArray.removeAtIndex(0)
            if imgArray.count == 0 {
                let alertVc = UIAlertController.init(title: "", message: "图片保存已保存至相册！", preferredStyle: .Alert)
                presentViewController(alertVc, animated: true, completion: {
                    gDelay(time: 1, task: {
                        alertVc.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            }
            print("image is saved")
        }
        savePictureNext()
    }
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
