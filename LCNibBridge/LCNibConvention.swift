//
//  LCNibConvention.swift
//  LCNibBridge
//
//  Created by 刘通超 on 16/5/25.
//  Copyright © 2016年 刘通超. All rights reserved.
//

import UIKit

public protocol LCNibConvention : NSObjectProtocol {
     //类方法
     static func lc_nibId_class() -> String
     static func lc_nib_class() -> UINib
    
    //实例方法
    
    func lc_nibId_instance() -> String
    func lc_nib_instance() -> UINib
}

extension UIView : LCNibConvention {
    
    //MARK: LCNibConvention
    public func lc_nibId_instance() -> String {
        let className = NSStringFromClass(self.classForCoder)
        if className.contains(".") {
            return className.components(separatedBy: ".").last!
        }else{
            return className
        }
        
    }

    public func lc_nib_instance() -> UINib {
        return UINib.init(nibName: self.lc_nibId_instance(), bundle: Bundle.main)
    }
    
    
    public static func lc_nibId_class() -> String {
        let className = NSStringFromClass(self)
        if className.contains(".") {
            return className.components(separatedBy: ".").last!
        }else{
            return className
        }
    }
    
    public static func lc_nib_class() -> UINib {
        return UINib.init(nibName: self.lc_nibId_class(), bundle: nil)
    }
    
    //MARK:获取nib 对象
    
    func lc_instantiateFromNib()-> UIView?{
        return self.lc_instantiateFromNibBundle(nil, owner: nil)
    }
    
    func lc_instantiateFromNibBundle(_ bundle:Bundle? , owner:AnyObject?) -> UIView? {
        
        let views = self.lc_nib_instance().instantiate(withOwner: owner, options: nil)
        for view in views {
            if (view as AnyObject).isMember(of: self.classForCoder) {
                return view as? UIView
            }
        }

        assert(false, "Exepect file:\(self.lc_nibId_instance()).xib")
        return nil
    }
    
    
}
