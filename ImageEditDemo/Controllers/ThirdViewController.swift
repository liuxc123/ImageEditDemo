//
//  ThirdViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITextFieldDelegate {
    
    
    var curFont: UIFont!
    var textColor: UIColor = UIColor.blackColor()
    var constant: CGFloat = 10
    var showImage: UIImage?
    
    @IBOutlet weak var imageBackView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var completeBtn: UIButton!

    @IBOutlet weak var bottomView: UIView!
    
    var showImageView: PasterImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "大字报"
        textField.delegate = self
        curFont = textField.font
        
        showImageView = PasterImageView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
        showImageView.image = UIImage(named: "dzb")
        imageBackView.addSubview(showImageView)
        showImage = UIImage(named: "dzb")
        
        let rightItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(saveAction(_:)))
        self.navigationItem.rightBarButtonItem = rightItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //TODO: 生成方法
    @IBAction func completeAction(sender: UIButton) {
        self.view.endEditing(true)
    }
    
    
    
    //MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(textField: UITextField) {
        calFontSize()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: - 计算字体大小, 重新布局
    func calFontSize() {
        let font = UIFont.systemFontOfSize(0)
        var cFont = font.pointSize
        var tSize = self.textSize(cFont, string: nil)
        
        while !isBeyond(tSize) && cFont < MAX_FONT_SIZE {
            cFont += 1
            tSize = self.textSize(cFont, string: nil)
        }
        
        cFont -= 1
        curFont = self.curFont?.fontWithSize(cFont)
        
        drawShowImageView()
    }
    
    func isBeyond(size: CGSize) -> Bool {
        let ost: CGFloat = constant * 2
        return size.height + ost > showImageView.frame.size.height
    }
    
    //计算字体文本大小
    func textSize(font: CGFloat, string: String?) -> CGSize {
        let text = self.textField.text
        
        let cW = showImageView.frame.size.width - constant * 2
        
        let tH = (text! as NSString).boundingRectWithSize(CGSize(width: cW, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: self.curFont!.fontWithSize(font)], context: nil).size
        
        return tH
    }
    
    //重新绘制展示图片
    func drawShowImageView() {
        
        let tH = self.textSize(curFont.pointSize, string: nil)
        let offset = (showImageView.frame.size.height - tH.height) / 2.0
        //重新绘制图片
        showImageView.font = curFont
        showImageView.textColor = textColor
        showImageView.title = textField.text!
        showImageView.top = offset
        showImageView.constant = constant
        showImageView.drawTextWithImage(showImage, title: textField.text!, font: curFont, color: textColor)
    }
    
    //保存大字报
    func saveAction(sender: UIBarButtonItem) {
        let resultImage = showImageView.image
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
