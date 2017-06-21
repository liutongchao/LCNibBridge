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

    open override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        
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

    
    func instantiateRealView(_ placeholdView:UIView) -> UIView? {
        //从xib中加载真正的视图
        let realView = placeholdView.lc_instantiateFromNib()
        //迁移View的所有属性
        realView?.tag = placeholdView.tag
        realView?.frame = placeholdView.frame
        realView?.bounds = placeholdView.bounds
        realView?.isHidden = placeholdView.isHidden
        realView?.clipsToBounds = placeholdView.clipsToBounds
        realView?.autoresizingMask = placeholdView.autoresizingMask
        realView?.isUserInteractionEnabled = placeholdView.isUserInteractionEnabled
        realView?.translatesAutoresizingMaskIntoConstraints = placeholdView.translatesAutoresizingMaskIntoConstraints
    
        if placeholdView.constraints.count > 0{
            if realView != nil {
                for constraint in placeholdView.constraints {
                    var newConstraint: NSLayoutConstraint?
                    if constraint.secondItem == nil {
                        
                        newConstraint = NSLayoutConstraint.init(item: realView!, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: nil, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant)
                        
                    }else if(constraint.firstItem === constraint.secondItem){
                        
                        newConstraint = NSLayoutConstraint.init(item: realView!,
                                                                attribute: constraint.firstAttribute,
                                                                relatedBy: constraint.relation,
                                                                toItem: realView!,
                                                                attribute: constraint.secondAttribute,
                                                                multiplier: constraint.multiplier,
                                                                constant: constraint.constant)
                        
                    }
                    
                    if newConstraint != nil {
                        newConstraint?.shouldBeArchived = constraint.shouldBeArchived
                        newConstraint?.priority = constraint.priority
                        let version = UIDevice.current.systemVersion as NSString
                        
                        if version.floatValue >= 7.0 {
                            newConstraint?.identifier = constraint.identifier
                        }
                        realView?.addConstraint(newConstraint!)
                    }
        
                }

            }
        }
        
        return realView
    }
}
