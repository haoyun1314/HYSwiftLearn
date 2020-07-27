//
//  CamptureViewController.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/5/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit

class CamptureViewController: UIViewController {
 
    var backButton:UIButton!
    
    var camptureButton : SwiftCamBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setU()
    }
    
}



extension CamptureViewController
{
    func setU () {
        
        //返回btn
        self.view.backgroundColor = UIColor.yellow
        let button:UIButton = UIButton.init(type:UIButton.ButtonType.custom)
        button.frame = CGRect.init(x: 16, y: 36, width: 80, height: 30)
        button.setTitle("返回", for: UIControl.State.normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button .addTarget(self, action:#selector(btnClick), for: UIControl.Event.touchUpInside)
        backButton = button;
        self.view.addSubview(button)
        
        
        //拍摄按钮
        
        camptureButton = SwiftCamBtn.init(type:UIButton.ButtonType.custom)
        let W : NSInteger = NSInteger((self.view.frame.size.width - 80.0)/2)
        let H : NSInteger = NSInteger((self.view.frame.size.height - 100))
        camptureButton.frame = CGRect.init(x:W, y: H, width: 80, height: 80)
        camptureButton.setTitle("拍摄", for: UIControl.State.normal)
        camptureButton.backgroundColor = UIColor.lightGray
        camptureButton.layer.cornerRadius = 40
        camptureButton.layer.masksToBounds = true
        camptureButton.buttonEnabled = true;
        camptureButton.delegate = self
        camptureButton .addTarget(self, action:#selector(camptureBtnClick), for: UIControl.Event.touchUpInside)
        self.view.addSubview(camptureButton)
                
    }
}

extension CamptureViewController : CamButtonDelegate
{
    
    @objc func btnClick() {
         self.dismiss(animated:true) {
             print("返回")
         }
     }
    
    @objc func camptureBtnClick() {
//         self.dismiss(animated:true) {
//             print("返回")
//         }
     }
    
    
    func buttonWasTapped() {
        print("buttonWasTapped")
    }
    
    func buttonDidBeginLongPress() {
        print("buttonDidBeginLongPress")
        
    }
    
    func buttonDidEndLongPress() {
        print("buttonDidEndLongPress")
        
    }
    
    func longPressDidReachMaximumDuration() {
        print("longPressDidReachMaximumDuration")
        
    }
    
    func setMaxiumVideoDuration() -> Double {
        return 10;
    }
     
}
