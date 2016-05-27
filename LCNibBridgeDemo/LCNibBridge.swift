//
//  LCNibBridge.swift
//  LCNibBridge
//
//  Created by 刘通超 on 16/5/25.
//  Copyright © 2016年 刘通超. All rights reserved.
//

import UIKit

//MARK: 桥接协议
public protocol LCNibBridge {
    func LC_NibBridgeUsefull()->Bool
}

extension UIView{

    public override class func initialize(){
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            //做方法替换
            
            let originalSelector = #selector(UIView.awakeAfterUsingCoder(_:))
            let swizzledSelector = #selector(self.hackedAwakeAfterUsingCoder(_:))
            
            let originalMethod = class_getInstanceMethod(NSClassFromString(self.lc_nibId_class()), originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
        
    }
    
    func hackedAwakeAfterUsingCoder(decoder:NSCoder) -> AnyObject? {
        
        if self.respondsToSelector(NSSelectorFromString("LC_NibBridgeUsefull")){//首先确定类遵守了LCNibBridge 协议
            
            //通过往类里边添加方法来实现对类的标记
            for index in 0...Int.max-1 {
                //通过一个for循环来解决多次调用
                let isLoading = class_getInstanceMethod(self.classForCoder,NSSelectorFromString("LC_NibBridgeIsLoading\(index)"))
                let isLoadover = class_getInstanceMethod(self.classForCoder,NSSelectorFromString("LC_NibBridgeIsLoadover\(index)"))
                
                if isLoadover == nil && isLoading == nil {
                    print(self.lc_nibId_instance()+"\(index)")
                    //标记该类正在桥接
                    class_addMethod(self.classForCoder, NSSelectorFromString("LC_NibBridgeIsLoading\(index)"), nil, nil)
    
                    return self.instantiateRealViewFromPlaceholder(self)
                }else if isLoading != nil && isLoadover == nil {
                    //标记该类已经桥接完毕
                    class_addMethod(self.classForCoder, NSSelectorFromString("LC_NibBridgeIsLoadover\(index)"), nil, nil)

                    return self;
                }
            }
        }
        return self
    }


    
    func instantiateRealViewFromPlaceholder(placeholdView:UIView) -> UIView? {
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
