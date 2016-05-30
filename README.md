# LCNibBridge
Swift 动态桥接库

#Installation
pod 'LCNibBridge', '~> 1.0.0'

or pod search LCNibBridge to check

#Overview
Design

![Design](https://github.com/liutongchao/LCNibBridge/blob/master/LCNibBridgeDemo/ScreenShot/desig.png)

Runtime

![Runtime](https://github.com/liutongchao/LCNibBridge/blob/master/LCNibBridgeDemo/ScreenShot/run.png)

#How to use

1.Build your view class and its xib file. (Same name required)


![class](https://github.com/liutongchao/LCNibBridge/blob/master/LCNibBridgeDemo/ScreenShot/class.png)


2.Put a placeholder view in target IB (xib or storyboard), Set its class.


![class](https://github.com/liutongchao/LCNibBridge/blob/master/LCNibBridgeDemo/ScreenShot/story.png)

3.Conform to LCNibBridge and implement the method in protocol

![](https://github.com/liutongchao/LCNibBridge/blob/master/LCNibBridgeDemo/ScreenShot/implement.png)

#Tips
>####If you don't want use LCNibBridge in a class , please clean the LCNibBridge protocol and the implement method in protocol

###如果你在天朝，请看我的中文博客
>http://www.jianshu.com/p/9bd3f8fd3381
