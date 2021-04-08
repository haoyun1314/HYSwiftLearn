//
//  CamptureViewController.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/5/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit
import AVFoundation


class CamptureViewController: HYSwiftCameraVC {
 
    var backButton     :UIButton!
    var camptureButton : SwiftCamBtn!
    var flashButton    : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setUI()
        shouldPrompToAppSettings = true
        cameraDelegate = self;
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        flashMode = .auto
        camptureButton.buttonEnabled = false
    }

    override var prefersStatusBarHidden: Bool
        {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        camptureButton.delegate = self;
    }

    func swiftyCamSessionDidStartRunning(_ swiftyCam: HYSwiftCameraVC) {
        print("Session did start running")
        camptureButton.buttonEnabled = true
    }
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: HYSwiftCameraVC) {
        print("Session did stop running")
        camptureButton.buttonEnabled = false
    }
    

}




// UI Animations
extension CamptureViewController {
    
    fileprivate func hideButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 0.0
//            self.flipCameraButton.alpha = 0.0
        }
    }
    
    fileprivate func showButtons() {
        UIView.animate(withDuration: 0.25) {
            self.flashButton.alpha = 1.0
//            self.flipCameraButton.alpha = 1.0
        }
    }
    
    fileprivate func focusAnimationAt(_ point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }) { (success) in
                focusView.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func toggleFlashAnimation() {
        if flashMode == .auto{
            flashMode = .on
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControl.State())
        }else if flashMode == .on{
            flashMode = .off
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControl.State())
        }else if flashMode == .off{
            flashMode = .auto
            flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        }
    }
}





extension CamptureViewController
{
    func setUI ()
    {
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
        let W : NSInteger = NSInteger((self.view.frame.size.width - 80.0)/2)
        let H : NSInteger = NSInteger((self.view.frame.size.height - 100))
        camptureButton = SwiftCamBtn.init(frame:CGRect.init(x:W, y: H, width: 80, height: 80))
        camptureButton.backgroundColor = UIColor.clear
        camptureButton.buttonEnabled = true;
        camptureButton.delegate = self
        self.view.addSubview(camptureButton)
        
                        
        flashButton = UIButton.init(frame:CGRect.init(x:(camptureButton.frame.origin.x+80+20), y:(camptureButton.frame.origin.y+40-15), width:18, height: 30))
        flashButton.setImage(#imageLiteral(resourceName: "flashauto"), for: UIControl.State())
        flashButton.addTarget(self, action: #selector(toggleFlashAnimation), for: UIControl.Event.touchUpInside)
        self.view.addSubview(flashButton)
                        
    }
}




 //MARK:HYSwiftyCamViewControllerDelegate

extension CamptureViewController : HYSwiftyCamViewControllerDelegate
{
        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didTake photo: UIImage) {
    //        let newVC = PhotoViewController(image: photo)
    //        self.present(newVC, animated: true, completion: nil)
        }
    

        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didBeginRecordingVideo camera: HYSwiftCameraVC.CameraSelection) {
            print("Did Begin Recording")
            camptureButton.growButton()
            hideButtons()
        }

        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFinishRecordingVideo camera: HYSwiftCameraVC.CameraSelection) {
            print("Did finish Recording")
            camptureButton.shrinkButton()
            showButtons()
        }

        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFinishProcessVideoAt url: URL) {
    //        let newVC = VideoViewController(videoURL: url)
    //        self.present(newVC, animated: true, completion: nil)
        }

        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFocusAtPoint point: CGPoint) {
            print("Did focus at point: \(point)")
            focusAnimationAt(point)
        }
        
        func swiftyCamDidFailToConfigure(_ swiftyCam: HYSwiftCameraVC) {
            let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
            let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }

        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didChangeZoomLevel zoom: CGFloat) {
            print("Zoom level did change. Level: \(zoom)")
            print(zoom)
        }

        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didSwitchCameras camera: HYSwiftCameraVC.CameraSelection) {
            print("Camera did change to \(camera.rawValue)")
            print(camera)
        }
        
        func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFailToRecordVideo error: Error) {
            print(error)
        }
            
}


extension CamptureViewController
{
    @objc func btnClick() {
         self.dismiss(animated:true) {
             print("返回")
         }
     }
     
}
