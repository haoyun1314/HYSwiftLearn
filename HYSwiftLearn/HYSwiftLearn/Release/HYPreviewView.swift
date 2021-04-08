//
//  HYPreviewView.swift
//  HYSwiftLearn
//
/*
 swift as as!和as?的区别
 
 1.as的使用场合
 1.从派生类转换为基类，向上转类型(upcasting)
 
 class Animal{}
 
 class Dog:Animal{}
 
 let  cat = Dog()
 let dog = cat as Animal
 2.消除二义性，数值类型转换
 
 let num1 = 4 as Int
 let num2 = 5.09 as CGFloat
 3.switch语句中进行模式匹配
 如果不知道一个对象是什么类型，可以通过switch语法检测他的类型，并且尝试在不同类型下使用对应的类型进行相应的处理。
 
 switch animal{
 case let dog as Dog:
 print("如果是Dog类型对象，则做相应处理")
 case let cat as Cat:
 print("如果是Cat类型对象，则做相应处理")
 default: break
 }
 2.as!的使用场合
 向下转型(Downcasting)时使用,由于是强制类型转换，如果转换失败会报runtime运行错误
 
 class Animal{}
 class Cat:Animal{}
 let animal:Animal = Cat()
 let cat = animal as! Cat
 3.as?的使用场合
 as?和as!操作符的转换规则是一样的，只是as?在转换失败之后会返回nil对象，转换成功之后返回一个可选类型(optional)，需要我们拆包使用。
 由于as?转换失败也不会报错，所以对于能够100%确定使用as!能够转换成功的，使用as!,否则使用as?
 
 let animal:Animal = Cat()
 if let cat = animal as? Cat{
 print("这里有猫")
 }else{
 print("这里没有猫")
 }
 */
//  Created by fanhaoyun on 2020/8/11.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit
import AVFoundation

//不同的预览方式
public enum SwiftyCamVideoGravity
{
    case resize
    case resizeAspect
    case resizeAspectFill
}


class HYPreviewView: UIView
{
    private var gravity : SwiftyCamVideoGravity = .resizeAspectFill
    
    init(frame : CGRect ,videoGravity : SwiftyCamVideoGravity) {
        gravity = videoGravity
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //   .as!的使用场合 向下转型(Downcasting)时使用,由于是强制类型转换，如果转换失败会报runtime运行错误
    var videoPreviewLayer: AVCaptureVideoPreviewLayer
    {
        let previewlayer = layer as! AVCaptureVideoPreviewLayer
        switch gravity {
        case .resize:
            previewlayer.videoGravity = AVLayerVideoGravity.resize
        case .resizeAspect:
            previewlayer.videoGravity = AVLayerVideoGravity.resizeAspect
        case .resizeAspectFill:
            previewlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        }
        return previewlayer
    }
    
    var session: AVCaptureSession?
    {
        get
        {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    // MARK: UIView
    override class var layerClass : AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
