//
//  MainViewController.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/5/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 1.获取json文件路径
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
               print("没有获取到对应的文件路径")
                     return
        }
         guard let jsonDataA = NSData(contentsOfFile: jsonPath) else
         {
                  print("没有获取到jsonData文件中数据")
                  return
         }
        

        
        guard let anyObject = try?JSONSerialization.jsonObject(with: jsonDataA as Data, options: .mutableContainers) else{
            return;
        }
        guard let dictArray = anyObject as? [[String : AnyObject]] else {
                  return
        }
        
        // 4.遍历字典,获取对应的信息
               for dict in dictArray {
                   // 4.1.获取控制器的对应的字符串
                   guard let vcName = dict["vcName"] as? String else {
                       continue
                   }
                   
                   // 4.2.获取控制器显示的title
                   guard let title = dict["title"] as? String else {
                       continue
                   }
                   
                   // 4.3.获取控制器显示的图标名称
                   guard let imageName = dict["imageName"] as? String else {
                       continue
                   }
                   // 4.4.添加子控制器
                addChild(childVcName:vcName, title: title, imageName: imageName)
               }
        
        
    }
    
   
    
    
    override func select(_ sender: Any?) {
        
        
    }
}

extension MainViewController
{
     private func addChild(childVcName: String, title : String, imageName : String) {
            
            // 0.获取命名空间
                guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
                    print("没有获取命名空间")
                    return
                }
                
                // 1.根据字符串获取对应的Class
                guard let ChildVcClass = NSClassFromString(nameSpace + "." + childVcName) else {
                    print("没有获取到字符串对应的Class")
                    return
                }
                
                // 2.将对应的AnyObject转成控制器的类型
                guard let childVcType = ChildVcClass as? UIViewController.Type else {
                    print("没有获取对应控制器的类型")
                    return
                }
            
            
            // 3.创建对应的控制器对象
                  let childVc = childVcType.init()
                  
                  // 4.设置子控制器的属性
                  childVc.title = title
                  childVc.tabBarItem.image = UIImage(named: imageName)
                  childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
                  
                  // 5.包装导航栏控制器
                  let childNav = UINavigationController(rootViewController: childVc)
                  // 6.添加控制器
                  addChild(childNav)
    }
}

extension MainViewController : UITabBarControllerDelegate
{

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "发布"
        {
            
//            let vc = PresentViewController()
//            let navigationModalController = UINavigationController(rootViewController: PresentViewController)
//            present(navigationModalController, animated: true)
            
            let vc = CamptureViewController()
            let navigationModalController = UINavigationController(rootViewController: vc)
            navigationModalController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            navigationModalController.navigationBar.isHidden = true
            present(navigationModalController, animated: true)
            
            print("发布")
//            let camptureVC = Cam()
//            let childNav = UINavigationController(rootViewController: camptureVC)
            
        }
    }


}



