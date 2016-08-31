//
//  UIViewExtension.swift
//  Faya
//
//  Created by 夏落 on 16/8/23.
//  Copyright © 2016年 Codans. All rights reserved.
//

import UIKit

extension UIView {
    
    //MARK: - 寻找当前View所在的控制器UIViewController
    public func getInvoker() -> UIViewController {
        var responder: UIResponder!
        var nextResponder = superview?.nextResponder()
        repeat {
            responder = nextResponder
            nextResponder = nextResponder?.nextResponder()
        } while !(responder.isKindOfClass(UIViewController))
        return responder as! UIViewController
    }

}
