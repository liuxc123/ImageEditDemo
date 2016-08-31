//
//  SecondViewController.swift
//  ImageEditDemo
//
//  Created by NaoNao on 16/8/26.
//  Copyright © 2016年 NaoNao. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.navigationItem.title = "9格切图"
        
        clipAction()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func clipAction() {
        
        var backgroundImage = UIImage(named: "rabbit")

        
        backgroundImage = backgroundImage?.resizableImageWithCapInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), resizingMode: .Stretch)
        
        let svRect = UIImageView(image: backgroundImage)
        svRect.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
        
        self.view.addSubview(svRect)
        
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
