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
        addChild(childVc: HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChild(childVc:MessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChild(childVc:DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChild(childVc:ProfileViewController(), title: "我", imageName: "tabbar_profile")

    }
    
    private func addChild(childVc: UIViewController, title : String, imageName : String) {
        // 1.设置子控制器的属性
              childVc.title = title
              childVc.tabBarItem.image = UIImage(named: imageName)
              childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
              // 2.包装导航栏控制器
              let childNav = UINavigationController(rootViewController: childVc)
              
              // 3.添加控制器
              addChild(childNav)
    }

}
