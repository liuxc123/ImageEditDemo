//
//  ThirdViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "大字报"
        
        let img = UIImage(named: "rabbit")
        let imgV = UIImageView(frame: CGRect(x: 0, y: 100, width: 200, height: 70))
        imgV.backgroundColor = UIColor.redColor()
        imgV.image = img
        self.view.addSubview(imgV)
        
        let imgF = imgV.image?.CGImage
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        CGContextRotateCTM(context, 45 * CGFloat(M_PI / 180))
        CGContextDrawImage(context, CGRect(x: 0, y: 100, width: 200, height: 70), imgF)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
