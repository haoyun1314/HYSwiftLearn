//
//  HYCustomCamptureVC.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/12/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit
import AVFoundation

class HYCustomCamptureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //获取权限=
        
        let status : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status
        {
        case .authorized:
            self.createCamera()
            break
        case .notDetermined:
            // not yet determined--还没有询问是否获取权限
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                }
                
                DispatchQueue.main.async
                {
                    self.createCamera()
                }
                
            })
        default:
            ""
        }
    }
    
    
    func createCamera()  {
        //已获取权限
        let rect : CGRect = self.view.bounds
        let cameraManger :HYCameraManager = HYCameraManager.init()
        cameraManger.configureWithParentLayer(parent:self.view, preivewRect:rect, orientation: AVCaptureVideoOrientation.portrait, isFrontCamera:true)
        cameraManger.sessionStartRunning()
    }
    
    
    
    
}



