//
//  HYHYSwiftCameraVCDelegate.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/8/11.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit
import AVFoundation


public protocol HYSwiftyCamViewControllerDelegate : class {

    
    /**
     HYSwiftCameraVCDelegate function called when when HYSwiftCameraVC session did start running.
     Photos and video capture will be enabled.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC
     */
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: HYSwiftCameraVC)
    
    /**
     HYSwiftCameraVCDelegate function called when when HYSwiftCameraVC session did stops running.
     Photos and video capture will be disabled.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC
     */
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: HYSwiftCameraVC)
    
    /**
     HYSwiftCameraVCDelegate function called when the takePhoto() function is called.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter photo: UIImage captured from the current session
     */
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didTake photo: UIImage)
    
    /**
     HYSwiftCameraVCDelegate function called when HYSwiftCameraVC begins recording video.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter camera: Current camera orientation
     */
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didBeginRecordingVideo camera: HYSwiftCameraVC.CameraSelection)
    
    /**
     HYSwiftCameraVCDelegate function called when HYSwiftCameraVC finishes recording video.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter camera: Current camera orientation
     */
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFinishRecordingVideo camera: HYSwiftCameraVC.CameraSelection)
    
    /**
     HYSwiftCameraVCDelegate function called when HYSwiftCameraVC is done processing video.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter url: URL location of video in temporary directory
     */
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFinishProcessVideoAt url: URL)
    
    
    /**
     HYSwiftCameraVCDelegate function called when HYSwiftCameraVC fails to record a video.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter error: An error object that describes the problem
     */
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFailToRecordVideo error: Error)
    
    /**
     HYSwiftCameraVCDelegate function called when HYSwiftCameraVC switches between front or rear camera.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter camera: Current camera selection
     */
    
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didSwitchCameras camera: HYSwiftCameraVC.CameraSelection)
    
    /**
     HYSwiftCameraVCDelegate function called when HYSwiftCameraVC view is tapped and begins focusing at that point.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter point: Location in view where camera focused
     
     */
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFocusAtPoint point: CGPoint)
    
    /**
     HYSwiftCameraVCDelegate function called when when HYSwiftCameraVC view changes zoom level.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC session
     - Parameter zoom: Current zoom level
     */
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didChangeZoomLevel zoom: CGFloat)
    
    /**
     HYSwiftCameraVCDelegate function called when when HYSwiftCameraVC fails to confiture the session.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC
     */
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: HYSwiftCameraVC)
    
    /**
     HYSwiftCameraVCDelegate function called when when HYSwiftCameraVC does not have access to camera or microphone.
     
     - Parameter swiftyCam: Current HYSwiftCameraVC
     */
    
    func swiftyCamNotAuthorized(_ swiftyCam: HYSwiftCameraVC)
    
    
}

public extension HYSwiftyCamViewControllerDelegate {
    
    func swiftyCamSessionDidStopRunning(_ swiftyCam: HYSwiftCameraVC) {
        // Optional
    }
    
    func swiftyCamSessionDidStartRunning(_ swiftyCam: HYSwiftCameraVC) {
        // Optional
    }
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didTake photo: UIImage) {
        // Optional
    }

    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didBeginRecordingVideo camera: HYSwiftCameraVC.CameraSelection) {
        // Optional
    }

    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFinishRecordingVideo camera: HYSwiftCameraVC.CameraSelection) {
        // Optional
    }

    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFinishProcessVideoAt url: URL) {
        // Optional
    }
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFailToRecordVideo error: Error) {
        // Optional
    }
    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didSwitchCameras camera: HYSwiftCameraVC.CameraSelection) {
        // Optional
    }

    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didFocusAtPoint point: CGPoint) {
        // Optional
    }

    
    func swiftyCam(_ swiftyCam: HYSwiftCameraVC, didChangeZoomLevel zoom: CGFloat) {
        // Optional
    }
    
    func swiftyCamDidFailToConfigure(_ swiftyCam: HYSwiftCameraVC) {
        // Optional
    }
    
    func swiftyCamNotAuthorized(_ swiftyCam: HYSwiftCameraVC) {
        // Optional
    }
}

