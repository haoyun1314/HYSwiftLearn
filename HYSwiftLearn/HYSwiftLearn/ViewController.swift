//
//  ViewController.swift
//  HYSwiftLearn
//
//  Created by 范浩云 on 2019/12/23.
//  Copyright © 2019 范浩云. All rights reserved.
//

import UIKit
import Foundation



// 1.定义结构体
// 在swift中结构体或者类在实例化时,必须保证所有的属性有初始化值.如果没有编译不会通过
// 如果自定义构造函数,那么默认的构造函数会被覆盖掉,如果不希望被覆盖,必须明确的实现该构造函数
// 如果给结构体扩充方法,则必须在方法的前面加mutating
struct Location {
    var x : Double
    var y : Double
    
    init () {
        x = 0
        y = 0
    }
    
    init (x : Double, y : Double) {
        self.x = x
        self.y = y
    }
    
    init (xyStr : String) {
        let xyArray = xyStr.split(separator:",")
        self.x = Double(xyArray.first!)!
        self.y = Double(xyArray.last!)!
    }
    
    mutating func moveH(x : Double) {
        self.x += x
    }
    
    mutating func moveV(y : Double) {
        self.y += y
    }
}

// 2.创建结构体实例
// let location = Location(x: 100, y: 100)
//let location = Location()
//let location1 = Location(x: 100, y: 100)
//let location2 = Location(xyStr: "100,100")


// 3.给系统的结构体扩充方法
extension CGPoint {
    mutating func moveH(x : CGFloat) {
        self.x += x
    }
    
    mutating func moveV(y : CGFloat) {
        self.y += y
    }
}





// 1.定义枚举类型
enum Direction {
    case East
    case West
    case North
    case South
}



// 2.给枚举类型指定值
enum Sex : Int {
    case Man = 0
    case Weman = 1
}



//// 1.定义结构体,用于描述位置信息
//struct Location {
//    var x : Double
//    var y : Double
//}

// 2.定义坐标点
 let center = Location(x: 100, y: 100)
 let testPoint = Location(x: 80, y: 70)







class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
//      TODO:Swift初体验
        // 2.定义一个标识符时必须制定该标识符时变量还是常量
        // 定义标识符的格式:let(常量)/var(变量) 标识符名称 : 数据类型 = 赋值
        let age : Int = 20
        // 3.语句结束时,可以不跟;
        // 注意:如果一行中有多条语句,则依然需要跟;,但是不建议该写法
        // 4.打印内容时,不再使用NSLog,而是使用print(打印内容)
        print(age)
//      TODO:02-变量和常量
        let age1 : Int = 30
        print(age1)

        var height : Double = 1.78
        height = 1.88
        
        print(height)
        
        // 2.使用注意:
        //  1> 指向的对象不可以修改(指针指向了一个对象,不能再指向另外一个对象了).
        //    可以通过指针获取对象本身,之后修改内部的属性
        
        //  2> 建议开发中,显示使用常量,只有确定一个常量需要被修改时,再改成变量(var)
        //    因为常量更加安全,不会被任意的修改
    
        //初始化一个view
        let view :UIView = UIView(frame: CGRect(x:20,y:50,width: 100,height: 100));
        view.backgroundColor = UIColor.red;
        self.view.addSubview(view);
        
//        TODO:基本数据类型
        
       // 整型:Int 浮点型:Double
        let R : Double = 1.0;
        var age3 : Int = 100;
        age3 = 80
         print(R)
         print(age3)
        
// 注意:
//如果一个标识符在定义时有直接复制,那么系统会根据后面赋值的类型来决定前面标识符的类型,这时(:类型)可以省略
//查看标识符的类型:option+鼠标左键(非常常用)
//这种转化方式被称之为:类型推导. 根据后面值的类型,推导出前面标识符的类型
        
        let a =  10;
        let b = 1.34;

        
        print(a)
        print(b)
        // Swift中的基本运算
        //int m = 10
        //double n = 2.55
        //
        //double l = m + n
        // 注意:
        // 1.Swift中没有隐式转化.(不会自动将一个类型转化成另外一个类型)
        // 2.如果想要两个不同的类型进行运算,必须保证类型一致
        // 3.将Int转成Double类型: Double(int的标识符) 将Double转成Int Int(Double的标识符)

        let m = 10
        let n = 22.5

        let x1 = Double(m) + n
        let x = m + Int(n + 0.5)
        print(x1)
        print(x)
        
//        TODO:条件语句

        // 新增Bool类型
        // 取值:true/false
        // if分支
        // 1.可以不跟()
        // 2.在判断句中必须有真假(没有非0即真)
        let c : Int = 1;
        
        let flag = c != 0
//     if (flag) {
//            print("c不等于0")
//        } else {
//            print("c等于0")
//        }

        if flag {
            print("a不等于0")
        } else {
            print("a等于0")
        }
//
        
        let score = 87
        if score < 60 {
            print("不及格")
        } else if score <= 70 {
            print("及格")
        } else if score <= 90 {
            print("良好")
        } else {
            print("优秀")
        }
        
        
        let  age4 = 17
        
        let string = age4 > 18 ? "可以去上网":"睡觉"
        print(string)
      
        // 取出较大的值

        let m1 = 20
        let n1 = 23
        
        let restult = m1 > n1
        
        func onLine(age:Int) -> Bool
        {
            guard age > 100 else
            {
                print("不能上网,回家去")
                     return false;
            }
            print("留下来上网吧")
            return true
        }

        let  boolOn  =  onLine(age : 100)
        
        print(boolOn)
        
//        TODO:sitch
        
        // switch的基本用法
        // 1>switch后面的()可以省略
        // 2>case中语句结束后不需要跟break
        // 3>在case中定义局部变量不需要跟{}
        // 4>如果想要case穿透,则在case语句结束时跟:fallthrough
        
        let sex = 0;
        switch sex {
        case 0:
            print("0")
        case 1:
            print("1")
        default:
            print("其它")
        }
    
        // Switch判断浮点型
        let w = 3.14
        switch w {
        case 3.14:
            print("π")
        default:
            print("非π")
        }
      
        
        // 根据判断字符串
        // swift中的字符串不需要跟@,直接写""
        let opration = "*"

        let m2 = 10
        let n2 = 20

        switch opration {
            case "+":
            print(m2 + n2)
            case "-":
            print(m2 - n2)
            case "*":
            print(m2 * n2)
            case "/":
            print(m2 / n2)
        default:
            print("不识别的操作符")
        }
        
        // 判断区间
        // 0..<10 : [0, 10)
        // 0...10 : [0, 10]
          
        // 判断区间
        // 0..<10 : [0, 10)
        // 0...10 : [0, 10]
        
        let score1 = 92
        switch score1 {
        case 0..<60:
            print("不及格")
        case 60..<70:
            print("及格")
        case 70..<90:
            print("良好")
        case 90...100:
            print("优秀")
        default:
            print("不合理的分数")
        }
        
        
//        TODO:for循环
        // for循环
        // for循环后面不跟()
        // for循环的第一种写法
        for i  in 0..<10
        {
            print(i)
        }
        
        for i in 0...10
        {
            print(i)
        }
        
        // 如果for中使用不到i,可以用_代替i

        for _ in 0...20
        {
            print("h")
        }
        
        // while用法跟OC基本一致
        // 1>while的判断句必须有正确的真假,没有非0即真
        // 2>while后面的()可以省略
        var k = 0
        while k<5 {
            k+=1
            print(k)
        }
       
        var n6 = 0
        repeat {
            n6+=1
            print(n6)
        } while n6 < 20
        
//        TODO:字符串
        
//        let kStrng = "Hello"
        
        let kstring1 : String
        
        kstring1 = "Hello"
        
        for c in kstring1
        {
            print(c);
        }

//        字符串拼接
        let kage = 18;
        let kname = "why"
        let kheight = 1.88
        // 如果字符串中出现了变量:\(标识符的名称)
        let info = "My name is \(kname), age is \(kage), height is \(kheight)"
        
        print(info)
        
        // 3.字符串的格式化
        // 03:04
        let min = 3
        let second = 4
        var time = "\(min):\(second)"
        time = String(format: "%02d:%02d", arguments: [min, second])
        print(time)
        // 4.字符串的截取
        let url = "www.520it.com"
        let url1 = (url as NSString).substring(to: 3)
        let url2 = (url as NSString).substring(from: 10);
        let rangSgring = NSRange(location: 1, length: 5)
        let url3 = (url as NSString).substring(with: rangSgring)
        print(url1,url2,url3)
        
//        TODO:数组
        /********************** 数组定义 **************************/
        // 数组:Array表示数据
        // let修饰的标识符是不可变数组(元素确定后不能修改)
        // var修饰的标识符是可变数组(可以添加和删除元素)
        // 注意:
        // 1>定义数组是使用[],并且不需要加@
        // 2>通常情况下数组是一个泛型集合,所有通常会指定数组中可以存放哪些元素
        
        // 不可变数组写法一:定义一个数组,里面存放的都是字符串
        let names : Array<String> = ["aaa","bbb","cc"]
        // 不可变数组写法二:定义一个数组,里面存放的都是字符串
        let name1 : [String] = ["a","b","c"]
        
            // 不可变数组写法二:定义一个数组,里面存放的都是字符串
        let names2 = ["why", "lmj", "lnj", "yz"]
        // 不可以添加元素
        
        
        // 数组中存放多种数据类型的写法
        let  kArray : [Any] = ["a","b",1,1.0]
        
        print(kArray)

        
        
        // 可变数组
        // 创建可变数组方式一:
        var karray1 : [String] = Array()
        // 常见可变数组方式二:
        var karray2 = [String]()

        /********************** 数组操作 **************************/
        // 添加元素:通过append方法
        karray1.append("wwww.baidu.com")
        
        
        print(karray1)
        
        // 删除元素
//        let removeString = karray1.remove(at: 0);
        
        
        // 修改元素
        karray1[0] = "H"
        karray1.append("w")
        
        print(karray1)
        
      
        // 获取数组中的值
        let str = karray1[0]
        
        
        // 获取数组中的元素个数
        let count = karray1.count
        
        /********************** 数组遍历 **************************/

        // 遍历方式一:

        for i  in 0..<karray1.count {
            print(i);
        }
        
        
        // 遍历方式二:forin

        for item in karray1 {
            print(item)
        }
        
        
        // 遍历方式三:区间遍历
        for item in karray1[0..<1]
        {
            print(item)
        }
        
        /********************** 合并 **************************/
        // 1.类型相同的合并
        let names5 = ["lmj", "lnj"]
        let names6 = ["yz", "why"]
        let names7 = names5 + names6

      
        // 2.不同类型的合并:不能相加
        var array5 = ["why", 18] as [Any]
        let array6 = [1.88, 60.5]
        // let array7 = array5 + array6
        for item in array6 {
            array5.append(item)
        }
        
        print(array5)
        // 注意:不建议数组中存放多种元素
        
        
//        TODO:字典的运用
        
//        DictionaryT
     
        
        //字面量
//        responseMessages变量的类型被推断为[Int: String]。字典的键类型是Int，而字典的值类型是String。
//        若要创建没有键值对的字典，请使用空字典文字([:])。
        let responseMessages = [200: "OK",
        403: "Access forbidden",
        404: "File not found",
        500: "Internal server error"]
        
        print(responseMessages);
        
        var hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
        print(hues["Coral"])
        // Prints "Optional(16)"
        
        
//        当您为一个键赋值并且该键已经存在时，字典会覆盖现有的值。如果字典不包含键，则键和值将作为新的键-值对添加。
//        这里，键“Coral”的值从16更新为18，并为键“Cerise”添加一个新的键-值对。
        //没有这个键值默认为空
         print(hues["Cerise"])
          // Prints "nil"
        
        //添加了一个键值对
        hues["Cerise"] = 300
        print(hues["Cerise"])
       //Prints "Optional(300)"
        print(hues)
                   
//        If you assign nil as the value for the given key, the dictionary removes that key and its associated value.
//        In the following example, the key-value pair for the key "Aquamarine" is removed from the dictionary by assigning nil to the key-based subscript.
        hues["Aquamarine"] = nil
        print(hues)
    // Prints "["Coral": 18, "Heliotrope": 296, "Cerise": 330]
                
           let httpResponseCodes = [200, 403, 301]
           for code in httpResponseCodes {
               if let message = responseMessages[code] {
                   print("Response \(code): \(message)")
               } else {
                   print("Unknown response \(code)")
               }
           }
        
        
//        TODO:函数
        self.about();
        self.about1();
        let getString =  self.readMessage()
        print(getString)
        self.callPhone(phoneNum: "你好么");
        // (Int, Int) -> Int
        var mathFunction : (Int, Int) -> Int = sumTwoInts
        print(mathFunction(20, 10))
        
        
        func multiplyTwoInts(num1 : Int, num2 : Int) -> Int {
            return num1 * num2
        }
        mathFunction = multiplyTwoInts
        print(mathFunction(40, 10))
        
        
//        / 3.将函数作为方法的返回值
        var km = -8

        func stepForward(num : Int) -> Int {
            return num + 1
        }

        func stepBackward(num : Int) -> Int {
            return num - 1
        }

    
//        var stepFunc : (Int) -> Int
//        if m < 0 {
//            stepFunc = stepForward
//        } else {
//            stepFunc = stepBackward
//        }
//
        func getStepFunc(num : Int) -> (Int) -> Int {
            return num < 0 ? stepForward : stepBackward
        }

        let stepFunc = getStepFunc(num: 100)
        
        let currentInt : Int = stepFunc(10)
        
        print(currentInt)
        
        

            //let count = getNumberCount(nums)
            //count.0
            //count.1

            
        //    TODO:枚举
            
                var kd1 = Direction.East
                kd1 = Direction.West
                // let d : Direction = .East
                let ksex = Sex(rawValue: 0)
        
        print(kd1);
        print(ksex ?? 19)
        
            
        
        print(center)
        print(testPoint)
        
//        inRange(point: testPoint)
        
        print(inRange(point: testPoint))
        
        

        // 4.系统结构体创建方式补充
        var point = CGPoint()
        point.x = 100
        point.y = 100
        let size = CGSize(width: 50, height: 50)
        let rect = CGRect(x: 10, y: 10, width: 100, height: 100)
        let range = NSRange(location: 5, length: 10)
        
        print(size)
        print(rect)
        print(range)
        
        
        
        // 1.创建Student对象
        let stu = Student()
        stu.name = "why"
        stu.age = 10
        stu.mathScore = 100
        stu.chineseScore = 90
        print(stu.mathScore)
        // 2.计算该学生的平均成绩
        // print(stu.getAverageScore())
        print(stu.averageScore)
        //stu.averageScore = 98
        print(stu.chineseScore)

        // 3.设置学生的课程数
        Student.courseCount = 2


}
    
    
    // 3.写一个方法用于进行判断
    func inRange(point : Location) -> Bool {
        let disX = point.x - center.x
        let disY = point.y - center.y
        let dis = sqrt(pow(disX, 2) + pow(disY, 2))
        return dis < 200
    }

    
    
    // 2.将函数作为方法的参数进行传递
    func printResult(num1 : Int, num2 : Int, mathFunc : (Int, Int) -> Int) {
        print(mathFunc(num1, num2))
    }
    // 1.定义一个函数
    func sumTwoInts(num1 : Int, num2 : Int) -> Int {
        return num1 + num2
    }

    
    // 1.没有参数没有返回值的函数
    func about() -> Void {
        print("iPhone6 Plus")
    }

    func about1() -> Void {
        print("iPhone6s Plus")
    }

    // 2.没有参数有返回值的函数
    func readMessage() -> String {
        return "吃饭了吗?"
    }

    // 3.有参数,没有返回值的函数
    func callPhone(phoneNum : String) {
        print("打电话给:\(phoneNum)")
    }

    // 4.有参数有返回值的函数
    func sum(num1 : Int, num2 : Int) -> Int {
        return num1 + num2
    }

    // 5.有参数有多个返回值的函数
    let nums = [1, 3, 6, 8, 12, 11, 22, 24]

    func getNumberCount(nums : [Int]) -> (Int, Int) {
        var oddCount = 0
        var evenCount = 0
        
        for num in nums {
            if num % 2 == 0 {
                oddCount+1
            } else {
                evenCount+1
            }
        }
        
        return (oddCount, evenCount)
    }


}




class Student {
    // 1.存储属性
    var name : String = ""
    var age : Int = 0
    var mathScore : Double = 0
    var chineseScore : Double = 0
    
    // 2.提供了函数,可以获取平均成绩
    /*
    func getAverageScore() -> Double {
        return (mathScore + chineseScore) * 0.5
    }
    */
    // 3.通过计算属性获取平均成绩
    /*
     1.如果一个计算属性只有get方法,那么该属性称之为只读属性
        如果只有get方法,那么get{}可以省略
     2.如果有写set方法,在set方法中有一个newValue常量,用于保存外界传入的值
        也可以给newValue起一个新的名字,在set后面跟上(newScore)
    */
    /*
    var averageScore : Double {
        get {
            return (mathScore + chineseScore) * 0.5
        }
        
        set (newScore) {
            chineseScore = newScore * 2 - mathScore
        }
    }
    */
    
    var averageScore : Double {
        return (mathScore + chineseScore) * 0.5
    }
    // 4.类属性:和整个类相关的属性,并且是通过类进行访问的
    static var courseCount : Int = 0
}





/*
 1.自定义构造函数时会覆盖原有的构造函数
    如果不希望覆盖,则可以明确的将原来的构造函数写出
*/

class Person {
    var name : String = ""
    var age : Int = 0
    
    init() {
        
    }
    
    init(name : String, age : Int) {
        self.name = name
        self.age = age
    }
    
    init(dict : [String : AnyObject]) {
        if let name = dict["name"] as? String {
            self.name = name
        }
        
        if let age = dict["age"] as? Int {
            self.age = age
        }
    }
    
    
    
  
}





class Person1 : NSObject {
    var name : String = ""
    var age : Int = 0
    
    init(dict : [String : AnyObject]) {
        super.init()
        self.setValuesForKeys(dict)
    }
    
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}





class Person2 {
    var name : String = ""
    var age : Int = 0
    
    func readBook() {
        print("人在读书")
    }
}


class Student2 : Person2 {
    var sno : Int = 0
    
    // 在swift中如果对父类的方法不满意,可以对父类方法进行重写,但是在重写时,必须前面加override
    override func readBook() {
        print("学生在读书学习")
    }
}






// 特性一: 继承
class kPerson {
    var name : String = ""
    var age : Int = 0
    
    func study() {
        print("人在学习")
    }
    
    required init() {
        
    }
    
    init(name : String, age : Int) {
        self.name = name
        self.age = age
    }
}

class kStudent : kPerson {
    var sno : Int = 0
    
    init(name : String, age : Int, sno : Int) {
        self.sno = sno
        super.init(name: name, age: age)
    }
    
    // 方法的重写:在swift中如果对父类的方法不满意,可以对父类的方法进行重写.但是必须在前面加上override
    override func study() {
        print("学生在学习")
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

/*
let stu = Student(name: "lmj", age: 19)
stu.name = "why"
stu.age = 18
stu.study()
*/



// 2.方法的重载
// 方法的重载有两层含义: 1.参数的类型不同 2.参数的个数不同
class MathTool {
    func sum(num1 : Int, num2 : Int) -> Int {
        return num1 + num2
    }
    
    func sum(num1 : Int, num2 : Int, num3 : Int) -> Int {
        return num1 + num2 + num3
    }
    
    func sum(num1 : Double, num2 : Double) -> Double {
        return num1 + num2
    }
}




// 3.多态
func stutyInNight(p : Person) {
    
    
}



//
//
//// 1.定义协议
//protocol SportProtocol : CrazySportProtocol {
//    func playBasketball()
//    func playFallball()
//}
//
//// 2.遵守协议
//// Swift中遵守协议:1.如果有继承自父类,则在父类后面跟, 写上协议 2.如果没有继承,直接写 : 写上协议
//// 注意:在swift中默认遵守一个协议后,协议中的方法都必须实现,如果没有实现则会报错误
//class Person {
//    var name : String = ""
//    var age : Int = 0
//
//    func running() {
//        print("跑步")
//    }
//}
//
//extension Person : SportProtocol {
//    func playBasketball() {
//        print("玩篮球")
//    }
//
//    func playFallball() {
//        print("玩足球")
//    }
//
//    func jumping() {
//        print("蹦极")
//    }
//}
//
//// 3.协议之间的继承
//protocol CrazySportProtocol {
//    func jumping()
//}
//





//
//
//protocol BuyTicketDelegate : class {
//    func buyTicket()
//}
//
//class Person {
//    weak var delegate : BuyTicketDelegate?
//    func gotoBeijing() {
//        delegate?.buyTicket()
//    }
//}
//
//
//class YellowCattle : BuyTicketDelegate {
//    func buyTicket() {
//        print("黄牛帮你买了一张票")
//    }
//}
//
//let yellowCattle = YellowCattle()
//let person = Person()
//person.delegate = yellowCattle

//person.gotoBeijing()
