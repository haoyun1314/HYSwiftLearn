//
//  HomeViewController.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/5/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit




struct Stack<Element> {
    var  items  = [Element]()
    mutating func push(_ item: Element){
        items.append(item)
    }
    mutating func poo()->Element
    {
        return items.removeLast()
    }
}

///
//TODO:扩展通用类型
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}




class HomeViewController: UITableViewController {
    
    override func viewDidLoad() {
        self.aaa();
        
    }

 
    
    
    
//TODO:泛型函数====================
    ///泛型
    func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
        
        var result = [Item]()
        for _ in 0..<numberOfTimes {
            result.append(item)
        }
        return result
    }
    
    
    ///该swapTwoInts(_:_:)功能交换原值b为a，和原来的值a进入b。您可以调用此函数来交换两个Int变量中的值：
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func swapTwoStrings(_ a: inout String, _ b: inout String) {
        let temporaryA = a
        a = b
        b = temporaryA
    }

    func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    
/*笔记  在所有这三个功能，类型的a和b必须相同。如果a和b不是同一类型，则无法交换它们的值。Swift是一种类型安全的语言，并且不允许（例如）类型String变量和类型变量Double彼此交换值。尝试这样做会导致编译时错误。
*/
    
    
    func swapTwoValues<T>(_ a: inout T ,_ b: inout T){
        let tempA = a
        a = b;
        b = tempA;
    }
    
    
//TODO通用类型
//    在Swift中，structure和enumeration是值类型(value type)
//    class是引用类型(reference type)。
//    默认情况下，实例方法中是不可以修改值类型的属性，使用mutating后可修改属性的值
    
//    在这种情况下，Element在三个地方用作占位符：
//
//   1. 要创建一个名为的属性items，该属性将使用一个类型为空的值数组进行初始化Element
//   2.  要指定该push(_:)方法具有一个名为的单个参数item，该参数必须为类型Element
//   3. 指定pop()方法返回的值将是类型的值Element

    struct IntStack {
        var items = [Int]()
        mutating func push(_ item: Int) {
            items.append(item)
        }
        mutating func pop() -> Int {
            return items.removeLast()
        }
    }
    

//TODO:类型约束
    
    

 

    
    func aaa() {
        var a = 10
        var b = 20
        b = 20
        let itemArra:Array = self.makeArray(repeating:1, numberOfTimes: 8);
        self.swapTwoInts(&a, &b)
        print(itemArra);
        print("a is now \(a), and b is now \(b)")
        
        var c = "great"
        var d = "love"
        self.swapTwoValues(&c, &d);
        print("a is now \(c),and d is now \(d)")
        
        var k = "jjjjj"
        var L = "LLLLLL"
        swap(&k,&L)
        print("k is now \(k),and l is now \(L)")
        
        
        var stack:IntStack = IntStack();
        stack.push(1);
        stack.push(2);
        print(stack)
        
        var stackOfStrings = Stack<String>()
        stackOfStrings.push("uno")
        stackOfStrings.push("dos")
        stackOfStrings.push("tres")
        stackOfStrings.push("cuatro")
        print(stackOfStrings)
        print(stackOfStrings.poo())
            
        if let topItem = stackOfStrings.topItem {///可选绑定
            print(topItem)
        }

        
    }
        
    
    
    
  
    
    
}

 



