//
//  HYOrientation.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/8/11.
//  Copyright © 2020 范浩云. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreMotion

class HYOrientation{
    var shouldUseDeviceOrientation: Bool  = false
    
    fileprivate var deviceOrientation : UIDeviceOrientation?

    fileprivate let coreMotionManager = CMMotionManager()
    
    init() {
        coreMotionManager.accelerometerUpdateInterval = 0.1
    }
    
    func start() {
        self.deviceOrientation = UIDevice.current.orientation
        
        coreMotionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else {
                return
            }
            self?.handleAccelerometerUpdate(data: data)
        }
        
    }
    
    func stop() {
         self.coreMotionManager.stopAccelerometerUpdates()
         self.deviceOrientation = nil
     }
    
    
    private func handleAccelerometerUpdate(data: CMAccelerometerData){
         if(abs(data.acceleration.y) < abs(data.acceleration.x)){
             if(data.acceleration.x > 0){
                 deviceOrientation = UIDeviceOrientation.landscapeRight
             } else {
                 deviceOrientation = UIDeviceOrientation.landscapeLeft
             }
         } else{
             if(data.acceleration.y > 0){
                 deviceOrientation = UIDeviceOrientation.portraitUpsideDown
             } else {
                 deviceOrientation = UIDeviceOrientation.portrait
             }
         }
     }
    
    
    func getPreviewLayerOrientation() -> AVCaptureVideoOrientation {
         // Depends on layout orientation, not device orientation
         switch UIApplication.shared.statusBarOrientation {
         case .portrait, .unknown:
             return AVCaptureVideoOrientation.portrait
         case .landscapeLeft:
             return AVCaptureVideoOrientation.landscapeLeft
         case .landscapeRight:
             return AVCaptureVideoOrientation.landscapeRight
         case .portraitUpsideDown:
             return AVCaptureVideoOrientation.portraitUpsideDown
         @unknown default:
             return AVCaptureVideoOrientation.portrait
        }
     }
     
     func getVideoOrientation() -> AVCaptureVideoOrientation? {
         guard shouldUseDeviceOrientation, let deviceOrientation = self.deviceOrientation else { return nil }
         
         switch deviceOrientation {
         case .landscapeLeft:
             return .landscapeRight
         case .landscapeRight:
             return .landscapeLeft
         case .portraitUpsideDown:
             return .portraitUpsideDown
         default:
             return .portrait
         }
     }
    
    
    func getImageOrientation(forCamera: HYSwiftCameraVC.CameraSelection) -> UIImage.Orientation {
           guard shouldUseDeviceOrientation, let deviceOrientation = self.deviceOrientation else { return forCamera == .rear ? .right : .leftMirrored }
           
           switch deviceOrientation {
           case .landscapeLeft:
               return forCamera == .rear ? .up : .downMirrored
           case .landscapeRight:
               return forCamera == .rear ? .down : .upMirrored
           case .portraitUpsideDown:
               return forCamera == .rear ? .left : .rightMirrored
           default:
               return forCamera == .rear ? .right : .leftMirrored
           }
       }

}
