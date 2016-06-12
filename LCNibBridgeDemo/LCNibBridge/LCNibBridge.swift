//
//  LCNibBridge.swift
//  LCNibBridge
//
//  Created by 刘通超 on 16/5/25.
//  Copyright © 2016年 刘通超. All rights reserved.
//

import UIKit

//MARK: 桥接协议
@objc
public protocol LCNibBridge {
}

extension UIView{

    public override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        
        if class_conformsToProtocol(self.classForCoder, LCNibBridge.self) {
            let version = class_getVersion(self.classForCoder)
            
            if version == 0 {
                //标记该类正在桥接
                
                print(self.classForCoder)
                class_setVersion(self.classForCoder, 1)
                return self.instantiateRealView(self)
            }
            //标记该类已经桥接完毕
            class_setVersion(self.classForCoder, 0)
            return self
            
        }
        
        return self
        
    }

    
    func instantiateRealView(placeholdView:UIView) -> UIView? {
        //从xib中加载真正的视图
        let realView = placeholdView.lc_instantiateFromNib()
        //迁移View的所有属性
        realView?.tag = placeholdView.tag;
        realView?.frame = placeholdView.frame;
        realView?.bounds = placeholdView.bounds;
        realView?.hidden = placeholdView.hidden;
        realView?.clipsToBounds = placeholdView.clipsToBounds;
        realView?.autoresizingMask = placeholdView.autoresizingMask;
        realView?.userInteractionEnabled = placeholdView.userInteractionEnabled;
        realView?.translatesAutoresizingMaskIntoConstraints = placeholdView.translatesAutoresizingMaskIntoConstraints;
        if realView != nil {
            for constraint in placeholdView.constraints {
                if (constraint.secondItem == nil) {
                    constraint.setValue(realView, forKey: "firstItem")
                    realView?.addConstraint(constraint)
                }else if (constraint.firstItem.isEqual(constraint.secondItem)){
                    constraint.setValue(realView, forKey: "firstItem")
                    constraint.setValue(realView, forKey: "secondItem")
                    realView?.addConstraint(constraint)
                }
            }
        }
        
        return realView
    }
}
