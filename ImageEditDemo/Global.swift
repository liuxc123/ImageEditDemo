//
//  Global.swift
//  NinePictureDemo
//
//  Created by XiaLuo on 16/8/29.
//  Copyright © 2016年 Hangzhou Gravity Cyber Info Corp. All rights reserved.
//

import UIKit

let BOUNDS = UIScreen.mainScreen().bounds
let WIDTH = UIScreen.mainScreen().bounds.width
let HEIGHT = UIScreen.mainScreen().bounds.height
let PROPORTION_BASIC6P: CGFloat = WIDTH/414.0

//MARK： - GCD延时
func gDelay(time _time: NSTimeInterval, task:()->Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(_time*Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { 
        task()
    }
}

class Global: NSObject {
    
    

}
