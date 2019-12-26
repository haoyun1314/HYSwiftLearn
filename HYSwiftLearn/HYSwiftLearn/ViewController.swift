//
//  ViewController.swift
//  HYSwiftLearn
//
//  Created by 范浩云 on 2019/12/23.
//  Copyright © 2019 范浩云. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red;
        
        print(student.name)
        student.sayHello()
       //student.getScore() //不能访问
    }

}



/*
     封装: 通常把隐藏属性,方法和方法实现细节的过程称为封装
     1.隐藏属性和方法
     使访问控制修饰符将类和其他属性方法封装起来, 常用的有: public, internal, private
     public:   从外部模块和本模块都能访问;
     internal: 只有本模块能访问;
     private:  只有本文件可以访问, 本模块的其他文件不能访问;
*/


public class Student {
    
      public var name : String
      internal var age : Int
      private var score : Int
    
    init(name : String,age : Int,score : Int) {
        self.name = name;
        self.age   = age;
        self.score = score;
    }

    public func sayHello()
    {
        print("Hello!")

    }
    private func getScore()
    {
           print("我的分数是: \(score)")
    }
}

let student = Student.init(name: "中国", age: 10, score: 100)






