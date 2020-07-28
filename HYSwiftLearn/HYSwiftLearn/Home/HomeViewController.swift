//
//  HomeViewController.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/5/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    var x = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        self.execute()

    }
    
    func execute()
    {
         let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"];
        func backward(_ s1: String, _ s2: String) -> Bool {
                  return s1 > s2
        }
        var reversedNames = names.sorted(by: backward)
           
        print(names);
        print(reversedNames);
        
        let reversedNames2 = names.sorted(by: {(s1: String, s2: String) -> Bool in return
            s1 > s2} )
        print("短写 reversedNames : \(reversedNames2)")
        
        
        func someFunctionThatTakesAClosure(closure: () -> Void) {
            // 函数体部分
            print("函数体部分");
        }
         // 以下是使用尾随闭包进行函数调用
        someFunctionThatTakesAClosure { }
        
        
        
             
                let digitNames = [
                    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
                    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
                ]
                let numbers = [16, 58, 510]
        //        如上代码创建了一个整型数位和它们英文版本名字相映射的字典。同时还定义了一个准备转换为字符串数组的整型数组。
        //        你现在可以通过传递一个尾随闭包给 numbers 数组的 map(_:) 方法来创建对应的字符串版本数组：
                
                let strings = numbers.map {
                    (number) -> String in
                    var number = number
                    var output = ""
                    repeat {
                        output = digitNames[number % 10]! + output
                        number /= 10
                    } while number > 0
                    return output
                }
                // strings 常量被推断为字符串类型数组，即 [String]
                // 其值为 ["OneSix", "FiveEight", "FiveOneZero"]
                print("strings: \(strings)")
        
        
        
            var completionHandlers: [() -> Void] = []
                
                func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
                    completionHandlers.append(completionHandler)
                }
                
        //        将一个闭包标记为 @escaping 意味着你必须在闭包中显式地引用 self。比如说，在下面的代码中，传递到 someFunctionWithEscapingClosure(_:) 中的闭包是一个逃逸闭包，这意味着它需要显式地引用 self。相对的，传递到 someFunctionWithNonescapingClosure(_:) 中的闭包是一个非逃逸闭包，这意味着它可以隐式引用 self。
                func someFunctionWithNonescapingClosure(closure: () -> Void) {
                    closure()
                }
                
                func doSomething() {
                    someFunctionWithEscapingClosure { self.x = 100 }
                    someFunctionWithNonescapingClosure { x = 200 }
                }
                
                doSomething()
                print("x: \(x)")


    }
}

 
