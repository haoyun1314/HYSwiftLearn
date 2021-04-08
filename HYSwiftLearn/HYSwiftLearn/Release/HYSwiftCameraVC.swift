//
//  HYSwiftCameraVC.swift
//  HYSwiftLearn
//
//
/*
语法
一、各个修饰符区别
1，private
private 访问级别所修饰的属性或者方法只能在当前类里访问。
（注意：Swift4 中，extension 里也可以访问 private 的属性。）
原文:Swift - 访问控制（fileprivate，private，internal，public，open）

2，fileprivate
fileprivate 访问级别所修饰的属性或者方法在当前的 Swift 源文件里可以访问。（比如上面样例把 private 改成 fileprivate 就不会报错了）

3，internal（默认访问级别，internal修饰符可写可不写）
internal 访问级别所修饰的属性或方法在源代码所在的整个模块都可以访问。
如果是框架或者库代码，则在整个框架内部都可以访问，框架由外部代码所引用时，则不可以访问。
如果是 App 代码，也是在整个 App 代码，也是在整个 App 内部可以访问。

4，public
可以被任何人访问。但其他 module 中不可以被 override 和继承，而在 module 内可以被 override 和继承。

5，open
可以被任何人使用，包括 override 和继承。

二、5种修饰符访问权限排序
从高到低排序如下：
1
open > public > interal > fileprivate > private
*/


//  Created by fanhaoyun on 2020/8/11.
//  Copyright © 2020 范浩云. All rights reserved.
//
//拍照流程：
// 1.创建会话
// 2.创建输入设备
// 3.创建输入
// 4.创建输出设备
// 5.创建输出
// 6.连接输入与会话
// 7.预览画面
///////////

import UIKit
import AVFoundation

open class HYSwiftCameraVC: UIViewController {

      fileprivate enum SessionSetupResult {
          case success
          case notAuthorized
          case configurationFailed
      }
    
    public enum CameraSelection: String {

        case rear = "rear"
        case front = "front"
    }
    
    
    public enum FlashMode{
        //Return the equivalent AVCaptureDevice.FlashMode
        var AVFlashMode: AVCaptureDevice.FlashMode {
            switch self {
                case .on:
                    return .on
                case .off:
                    return .off
                case .auto:
                    return .auto
            }
        }
        //Flash mode is set to auto
        case auto
        
        //Flash mode is set to on
        case on
        
        //Flash mode is set to off
        case off
    }
    
    
    public enum VideoQuality {

        /// AVCaptureSessionPresetHigh
        case high

        /// AVCaptureSessionPresetMedium
        case medium

        /// AVCaptureSessionPresetLow
        case low

        /// AVCaptureSessionPreset352x288
        case resolution352x288

        /// AVCaptureSessionPreset640x480
        case resolution640x480

        /// AVCaptureSessionPreset1280x720
        case resolution1280x720

        /// AVCaptureSessionPreset1920x1080
        case resolution1920x1080

        /// AVCaptureSessionPreset3840x2160
        case resolution3840x2160

        /// AVCaptureSessionPresetiFrame960x540
        case iframe960x540

        /// AVCaptureSessionPresetiFrame1280x720
        case iframe1280x720
    }
    /// Video capture quality

    public var videoQuality : VideoQuality       = .high

    
    
/// PreviewView for the capture session
    fileprivate var previewLayer                 : HYPreviewView!
    
    /// UIView for front facing flash

    fileprivate var flashView                    : UIView?
    
     /// Specifies the [videoGravity](https://developer.apple.com/reference/avfoundation/avcapturevideopreviewlayer/1386708-videogravity) for the preview layer.
    
    public var videoGravity                   : SwiftyCamVideoGravity = .resizeAspect
    
    /// Public access to Pinch Gesture
    fileprivate(set) public var pinchGesture  : UIPinchGestureRecognizer!

    /// Public access to Pan Gesture
    fileprivate(set) public var panGesture    : UIPanGestureRecognizer!
    
    
    
    // MARK: Private Constant Declarations
    /// Current Capture Session
    public let session                           = AVCaptureSession()
    /// Serial queue used for setting up session
    fileprivate let sessionQueue                 = DispatchQueue(label: "session queue", attributes: [])

    /// Variable to store result of capture session setup

    fileprivate var setupResult                  = SessionSetupResult.success
    
    /// Sets wether the taken photo or video should be oriented according to the device orientation
    
    /// Set whether SwiftyCam should allow background audio from other applications

    public var allowBackgroundAudio              = true
    
    /// Sets whether or not video recordings will record audio
    /// Setting to true will prompt user for access to microphone on View Controller launch.
    public var audioEnabled                   = true
    
    
    /// Returns true if the capture session is currently running

    private(set) public var isSessionRunning     = false
    
    /// Sets whether or not app should display prompt to app settings if audio/video permission is denied
     /// If set to false, delegate function will be called to handle exception
     public var shouldPrompToAppSettings       = true
    
    public weak var cameraDelegate: HYSwiftyCamViewControllerDelegate?

    /// Boolean to store when View Controller is notified session is running

    fileprivate var sessionRunning               = false
    // MARK: Public Get-only Variable Declarations

    /// Returns true if video is currently being recorded

    private(set) public var isVideoRecording      = false
    
    
    fileprivate var orientation                  : HYOrientation = HYOrientation()

    public var shouldUseDeviceOrientation      = false {
        didSet {
            orientation.shouldUseDeviceOrientation = shouldUseDeviceOrientation
        }
    }
  
    /// Returns the CameraSelection corresponding to the currently utilized camera
    private(set) public var currentCamera        = CameraSelection.rear

    
    /// Returns true if the torch (flash) is currently enabled
    fileprivate var isCameraTorchOn              = false
    
    
    /// Video Input variable

    fileprivate var videoDeviceInput             : AVCaptureDeviceInput!
    
    
    /// Video Device variable

    fileprivate var videoDevice                  : AVCaptureDevice?
    
    // Flash Mode
    public var flashMode:FlashMode               = .off
    
    /// Photo File Output variable

    fileprivate var photoFileOutput              : AVCaptureStillImageOutput?
    
    /// Movie File Output variable

    fileprivate var movieFileOutput              : AVCaptureMovieFileOutput?
    
    /// BackgroundID variable for video recording
    fileprivate var backgroundRecordingID        : UIBackgroundTaskIdentifier? = nil
    
    
    /// Video will be recorded to this folder
    public var outputFolder: String           = NSTemporaryDirectory()
    
    
    /// Set default launch camera

    public var defaultCamera                   = CameraSelection.rear
        
    /// Sets whether the capture session should adjust to low light conditions automatically
    ///
    /// Only supported on iPhone 5 and 5C

    public var lowLightBoost                     = true
    
    /// Sets output video codec
    public var videoCodecType: AVVideoCodecType? = nil

    /// Maxiumum video duration if SwiftyCamButton is used
    public var maximumVideoDuration : Double     = 0.0
    
    /// Sets whether Pinch to Zoom is enabled for the capture session
    public var pinchToZoom                       = true

    
    // MARK: Private Variable Declarations

    /// Variable for storing current zoom scale

    fileprivate var zoomScale                    = CGFloat(1.0)
    
    /// Sets the maximum zoom scale allowed during gestures gesture

    public var maxZoomScale                         = CGFloat.greatestFiniteMagnitude
    
    /// Variable for storing initial zoom scale before Pinch to Zoom begins

    fileprivate var beginZoomScale               = CGFloat(1.0)
    
    /// Sets whether Tap to Focus and Tap to Adjust Exposure is enabled for the capture session

    public var tapToFocus                        = true

    /// Pan Translation

    fileprivate var previousPanTranslation       : CGFloat = 0.0
    
    
    /// Sets whether a double tap to switch cameras is supported

    public var doubleTapCameraSwitch            = true
    
    /// Sets whether swipe vertically to zoom is supported

    public var swipeToZoom                     = true
    
    public var swipeToZoomInverted             = false
    /// Sets whether or not View Controller supports auto rotation

    public var allowAutoRotate                = false

    // Flash Mode
//    public var flashMode:FlashMode               = .off
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //初始化预览层
        previewLayer = HYPreviewView(frame: view.frame, videoGravity: videoGravity)
        previewLayer.center = view.center
        view.addSubview(previewLayer)
        view.sendSubviewToBack(previewLayer)
        //添加手势
        addGestureRecognizers()
        //创建session
        previewLayer.session = session
        
        //获取权限=
        let status : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status
        {
        case .authorized:
            //已获取权限
            break
        case .notDetermined:
            // not yet determined--还没有询问是否获取权限
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            
            // already been asked. Denied access--已询问获取权限被拒绝
            setupResult = .notAuthorized
        }
        
        //session配置
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
    }
    
    
    // MARK: ViewDidLayoutSubviews
    /// ViewDidLayoutSubviews() Implementation
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        if(shouldAutorotate)
        {
            layer.videoOrientation = orientation
        } else {
            layer.videoOrientation = .portrait
        }
        previewLayer.frame = self.view.bounds
    }
    
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //设置方向
        if let connection = self.previewLayer?.videoPreviewLayer.connection {
            let currentDevice:UIDevice = UIDevice.current
            let orientation : UIDeviceOrientation = currentDevice.orientation;
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                    
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                
                    break
                    
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                
                    break
                    
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                
                    break
                    
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                
                    break
                }
            }
        }
        
    }
    
    
    
    // MARK: ViewWillAppear--设置session开启和停止通知

    open override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionDidStartRunning), name: .AVCaptureSessionDidStartRunning, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionDidStopRunning), name: .AVCaptureSessionDidStopRunning, object: nil)
    }
    
    
    
    // MARK: ViewDidAppear

    open override func viewDidAppear(_ animated: Bool) {
            
       super.viewDidAppear(animated)
        if shouldUseDeviceOrientation {
                orientation.start()
            }
        //后台音频配置
        setBackgroundAudioPreference()
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                 print("Begin Session")
                // Begin Session
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                DispatchQueue.main.async {
                    self.previewLayer.videoPreviewLayer.connection?.videoOrientation = self.orientation.getPreviewLayerOrientation()
                }

            case .notAuthorized:
                if self.shouldPrompToAppSettings == true {
                    self.promptToAppSettings()
                } else {
                    self.cameraDelegate?.swiftyCamNotAuthorized(self)
                }
            case .configurationFailed:
                // Unknown Error
                DispatchQueue.main.async {
                    self.cameraDelegate?.swiftyCamDidFailToConfigure(self)
                }
            }
        }
}
        
    
    

    
    // MARK: ViewDidDisappear
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

                NotificationCenter.default.removeObserver(self)
               sessionRunning = false

               // If session is running, stop the session
               if self.isSessionRunning == true {
                   self.session.stopRunning()
                   self.isSessionRunning = false
               }

               //Disble flash if it is currently enabled
               disableFlash()

               // Unsubscribe from device rotation notifications
               if shouldUseDeviceOrientation {
                   orientation.stop()
               }
    }
    
    
    // MARK: Public Functions

    /**
    Capture photo from current session
    UIImage will be returned with the SwiftyCamViewControllerDelegate function SwiftyCamDidTakePhoto(photo:)
    */
    
    
    public func takePhoto() {

        guard let device = videoDevice else
        {
            return
        }
        
        if device.hasFlash == true && flashMode != .off /* TODO: Add Support for Retina Flash and add front flash */ {
            changeFlashSettings(device: device, mode: flashMode)
            capturePhotoAsyncronously(completionHandler: { (_) in })
        }else{
            if device.isFlashActive == true {
                changeFlashSettings(device: device, mode: flashMode)
            }
            capturePhotoAsyncronously(completionHandler: { (_) in })
        }
    }
    
    /**

    Begin recording video of current session

    SwiftyCamViewControllerDelegate function SwiftyCamDidBeginRecordingVideo() will be called

    */
    public func startVideoRecording() {
        guard sessionRunning == true else {
               print("[SwiftyCam]: Cannot start video recoding. Capture session is not running")
               return
           }
           guard let movieFileOutput = self.movieFileOutput else {
               return
           }
        
        if currentCamera == .rear && flashMode == .on {
            enableFlash()
        }
        
        if currentCamera == .front && flashMode == .on  {
            flashView = UIView(frame: view.frame)
            flashView?.backgroundColor = UIColor.white
            flashView?.alpha = 0.85
            previewLayer.addSubview(flashView!)
        }

        
        //Must be fetched before on main thread
         let previewOrientation = previewLayer.videoPreviewLayer.connection!.videoOrientation

//        Unowned reference can’t be nil and Weak can.
//        [unowned self] 与 [weak self]

        sessionQueue.async { [unowned self] in
                if !movieFileOutput.isRecording {
                    if UIDevice.current.isMultitaskingSupported {
                        self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                    }

                    // Update the orientation on the movie file output video connection before starting recording.
                    let movieFileOutputConnection = self.movieFileOutput?.connection(with: AVMediaType.video)
                    //flip video output if front facing camera is selected
                    if self.currentCamera == .front {
                        movieFileOutputConnection?.isVideoMirrored = true
                    }
                    movieFileOutputConnection?.videoOrientation = self.orientation.getVideoOrientation() ?? previewOrientation
                    // Start recording to a temporary file.
                    let outputFileName = UUID().uuidString
                    let outputFilePath = (self.outputFolder as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                    
                    movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate:self )
                    self.isVideoRecording = true
                    DispatchQueue.main.async {
                        self.cameraDelegate?.swiftyCam(self, didBeginRecordingVideo: self.currentCamera)
                    }
                }
                else {
                    movieFileOutput.stopRecording()
                }
            }
    }
    
    
    
    /**

    Stop video recording video of current session

    SwiftyCamViewControllerDelegate function SwiftyCamDidFinishRecordingVideo() will be called

    When video has finished processing, the URL to the video location will be returned by SwiftyCamDidFinishProcessingVideoAt(url:)

    */

    public func stopVideoRecording() {
        if self.isVideoRecording == true {
            self.isVideoRecording = false
            movieFileOutput!.stopRecording()
            disableFlash()

            if currentCamera == .front && flashMode == .on && flashView != nil {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.flashView?.alpha = 0.0
                }, completion: { (_) in
                    self.flashView?.removeFromSuperview()
                })
            }
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didFinishRecordingVideo: self.currentCamera)
            }
        }
    }

    /**

    Switch between front and rear camera

    SwiftyCamViewControllerDelegate function SwiftyCamDidSwitchCameras(camera:  will be return the current camera selection

    */

    public func switchCamera() {
        guard isVideoRecording != true else {
            //TODO: Look into switching camera during video recording
            print("[SwiftyCam]: Switching between cameras while recording video is not supported")
            return
        }

        guard session.isRunning == true else {
            return
        }

        switch currentCamera {
        case .front:
            currentCamera = .rear
        case .rear:
            currentCamera = .front
        }

        session.stopRunning()

        sessionQueue.async { [unowned self] in

            // remove and re-add inputs and outputs

            for input in self.session.inputs {
                self.session.removeInput(input )
            }

            self.addInputs()
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didSwitchCameras: self.currentCamera)
            }

            self.session.startRunning()
        }

        // If flash is enabled, disable it as the torch is needed for front facing camera
        disableFlash()
    }
    
  
        
        // MARK: Private Functions

        /// Configure session, add inputs and outputs
        fileprivate func configureSession()
        {
            //获取权限成功
            guard setupResult == .success else {
                return
            }
            // Set default camera---默认后置摄相头
            currentCamera = defaultCamera
            session.beginConfiguration()
            configureVideoPreset()
            addVideoInput()
            addAudioInput()
            configureVideoOutput()
            configurePhotoOutput()
            session.commitConfiguration()
        }
    
        /// Add inputs after changing camera()
        fileprivate func addInputs() {
            session.beginConfiguration()
            configureVideoPreset()
            addVideoInput()
            addAudioInput()
            session.commitConfiguration()
        }
      
     /// Enable or disable flash for photo
    fileprivate func changeFlashSettings(device: AVCaptureDevice, mode: FlashMode) {
            do {
                try device.lockForConfiguration()
                device.flashMode = mode.AVFlashMode
                device.unlockForConfiguration()
            } catch {
                print("[SwiftyCam]: \(error)")
            }
        }

    
    fileprivate func setBackgroundAudioPreference()
    {
        guard allowBackgroundAudio == true else {
            return
        }
        
        guard audioEnabled == true else {
            return
        }
        
        do{
            if #available(iOS 10.0, *)
            {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers, .allowBluetooth, .allowAirPlay, .allowBluetoothA2DP])
                
            } else {
                let options: [AVAudioSession.CategoryOptions] = [.mixWithOthers, .allowBluetooth]
                let category = AVAudioSession.Category.playAndRecord
                let selector = NSSelectorFromString("setCategory:withOptions:error:")
                AVAudioSession.sharedInstance().perform(selector, with: category, with: options)
            }
            try AVAudioSession.sharedInstance().setActive(true)
            session.automaticallyConfiguresApplicationAudioSession = false
        }
        catch {
            print("[SwiftyCam]: Failed to set background audio preference")
            
        }
    }
    
    
    /// Handle Denied App Privacy Settings
    fileprivate func promptToAppSettings() {
        // prompt User with UIAlertView
        DispatchQueue.main.async(execute: { [unowned self] in
            let message = NSLocalizedString("AVCam doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
            let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .default, handler: { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(appSettings)
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
        })
    }

}



//MARK:闪光灯处理常用API
extension HYSwiftCameraVC
{
    
    /// Enable flash
    fileprivate func enableFlash() {
        if self.isCameraTorchOn == false {
            toggleFlash()
        }
    }
    /// Disable flash

    fileprivate func disableFlash() {
        if self.isCameraTorchOn == true {
            toggleFlash()
        }
    }
    
     /// Toggles between enabling and disabling flash
     fileprivate func toggleFlash() {
         guard self.currentCamera == .rear else {
             // Flash is not supported for front facing camera
             return
         }

         let device = AVCaptureDevice.default(for: AVMediaType.video)
         // Check if device has a flash
         if (device?.hasTorch)! {
             do {
                 try device?.lockForConfiguration()
                 if (device?.torchMode == AVCaptureDevice.TorchMode.on)
                 {
                     device?.torchMode = AVCaptureDevice.TorchMode.off
                     self.isCameraTorchOn = false
                 } else {
                     do {
                         try device?.setTorchModeOn(level: 1.0)
                         self.isCameraTorchOn = true
                     } catch {
                         print("[SwiftyCam]: \(error)")
                     }
                 }
                 device?.unlockForConfiguration()
             } catch {
                 print("[SwiftyCam]: \(error)")
             }
         }
     }
     
}









//MARK:Sesssion配置--NotificationCenter
extension HYSwiftCameraVC
{
    /// Called when Notification Center registers session starts running
    @objc private func captureSessionDidStartRunning() {
        sessionRunning = true
        DispatchQueue.main.async {
            self.cameraDelegate?.swiftyCamSessionDidStartRunning(self)
        }
    }
    /// Called when Notification Center registers session stops running

    @objc private func captureSessionDidStopRunning() {
        sessionRunning = false
        DispatchQueue.main.async {
            self.cameraDelegate?.swiftyCamSessionDidStopRunning(self)
        }
    }
}





//MARK:Sesssion配置--
extension HYSwiftCameraVC
{
    /// Configure image quality preset---设置图像的预设分辨率
    fileprivate func configureVideoPreset() {
        if currentCamera == .front
        {
            session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
        }
        else
        {
            if session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality)))
            {
                session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))
            }
            else
            {
                session.sessionPreset = AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: .high))
            }
        }
    }
    
    
      /// Add Video Inputs 添加输入设备
      fileprivate func addVideoInput()
      {
          switch currentCamera
          {
          case .front:
              videoDevice = HYSwiftCameraVC.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .front)
          case .rear:
              videoDevice = HYSwiftCameraVC.deviceWithMediaType(AVMediaType.video.rawValue, preferringPosition: .back)
          }
          if let device = videoDevice
          {
              do {
                  try device.lockForConfiguration()
                  if device.isFocusModeSupported(.continuousAutoFocus)
                  {
                      device.focusMode = .continuousAutoFocus
                      if device.isSmoothAutoFocusSupported {
                          device.isSmoothAutoFocusEnabled = true
                      }
                  }
                  if device.isExposureModeSupported(.continuousAutoExposure) {
                      device.exposureMode = .continuousAutoExposure
                  }

                  if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                      device.whiteBalanceMode = .continuousAutoWhiteBalance
                  }

                  if device.isLowLightBoostSupported && lowLightBoost == true {
                      device.automaticallyEnablesLowLightBoostWhenAvailable = true
                  }

                  device.unlockForConfiguration()
              } catch {
                  print("[SwiftyCam]: Error locking configuration")
              }
          }
        
        
          do {
              if let videoDevice = videoDevice
              {
                  let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                
                  if session.canAddInput(videoDeviceInput)
                   {
                      session.addInput(videoDeviceInput)
                      self.videoDeviceInput = videoDeviceInput
                  }
                  else
                  {
                      print("[SwiftyCam]: Could not add video device input to the session")
                      print(session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: videoInputPresetFromVideoQuality(quality: videoQuality))))
                      setupResult = .configurationFailed
                      session.commitConfiguration()
                      return
                  }
              }
              
          } catch {
              print("[SwiftyCam]: Could not create video device input: \(error)")
              setupResult = .configurationFailed
              return
          }
      }
    
    
    
    
    /// Add Audio Inputs-添加音配输入
    fileprivate func addAudioInput()
    {
        guard audioEnabled == true else {
            return
        }
        do {
            if let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
            {
                let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioDeviceInput)
                {
                    session.addInput(audioDeviceInput)
                }
                else
                {
                    print("[SwiftyCam]: Could not add audio device input to the session")
                }
            } else {
                print("[SwiftyCam]: Could not find an audio device")
            }
            
        } catch {
            print("[SwiftyCam]: Could not create audio device input: \(error)")
        }
       }
       
        
    
    /// Configure Movie Output--添加视频输出
    fileprivate func configureVideoOutput() {
        let movieFileOutput = AVCaptureMovieFileOutput()

        if self.session.canAddOutput(movieFileOutput)
        {
            self.session.addOutput(movieFileOutput)
            if let connection = movieFileOutput.connection(with: AVMediaType.video)
            {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }

                if #available(iOS 11.0, *) {
                    if let videoCodecType = videoCodecType
                    {
                        if movieFileOutput.availableVideoCodecTypes.contains(videoCodecType) == true
                        {
                            // Use the H.264 codec to encode the video.
                            movieFileOutput.setOutputSettings([AVVideoCodecKey: videoCodecType], for: connection)
                        }
                    }
                }
            }
            self.movieFileOutput = movieFileOutput
        }
    }
    
    
    
    /// Configure Photo Output====添加图片输出
    fileprivate func configurePhotoOutput()
    {
        let photoFileOutput = AVCaptureStillImageOutput()
        if self.session.canAddOutput(photoFileOutput)
        {
            photoFileOutput.outputSettings  = [AVVideoCodecKey: AVVideoCodecJPEG]
            self.session.addOutput(photoFileOutput)
            self.photoFileOutput = photoFileOutput
        }
    }
    
    
    
          /// Get Devices

          fileprivate class func deviceWithMediaType(_ mediaType: String, preferringPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
              if #available(iOS 10.0, *) {
                      let avDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType(rawValue: mediaType), position: position)
                      return avDevice
              } else {
                      // Fallback on earlier versions
                      let avDevice = AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType))
                      var avDeviceNum = 0
                      for device in avDevice {
                              print("deviceWithMediaType Position: \(device.position.rawValue)")
                              if device.position == position {
                                      break
                              } else {
                                      avDeviceNum += 1
                              }
                      }

                      return avDevice[avDeviceNum]
              }

              //return AVCaptureDevice.devices(for: AVMediaType(rawValue: mediaType), position: position).first
          }
      
      /**
      Returns an AVCapturePreset from VideoQuality Enumeration

      - Parameter quality: ViewQuality enum

      - Returns: String representing a AVCapturePreset
      */

      fileprivate func videoInputPresetFromVideoQuality(quality: VideoQuality) -> String {
          switch quality {
          case .high: return AVCaptureSession.Preset.high.rawValue
          case .medium: return AVCaptureSession.Preset.medium.rawValue
          case .low: return AVCaptureSession.Preset.low.rawValue
          case .resolution352x288: return AVCaptureSession.Preset.cif352x288.rawValue
          case .resolution640x480: return AVCaptureSession.Preset.vga640x480.rawValue
          case .resolution1280x720: return AVCaptureSession.Preset.hd1280x720.rawValue
          case .resolution1920x1080: return AVCaptureSession.Preset.hd1920x1080.rawValue
          case .iframe960x540: return AVCaptureSession.Preset.iFrame960x540.rawValue
          case .iframe1280x720: return AVCaptureSession.Preset.iFrame1280x720.rawValue
          case .resolution3840x2160:
              if #available(iOS 9.0, *) {
                  return AVCaptureSession.Preset.hd4K3840x2160.rawValue
              }
              else {
                  print("[SwiftyCam]: Resolution 3840x2160 not supported")
                  return AVCaptureSession.Preset.high.rawValue
              }
          }
      }

      
      fileprivate func capturePhotoAsyncronously(completionHandler: @escaping(Bool) -> ()) {

          guard sessionRunning == true else {
              print("[SwiftyCam]: Cannot take photo. Capture session is not running")
              return
          }

          if let videoConnection = photoFileOutput?.connection(with: AVMediaType.video) {

              photoFileOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(sampleBuffer, error) in
                  if (sampleBuffer != nil) {
                      let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                      let image = self.processPhoto(imageData!)

                      // Call delegate and return new image
                      DispatchQueue.main.async {
                          self.cameraDelegate?.swiftyCam(self, didTake: image)
                      }
                      completionHandler(true)
                  } else {
                      completionHandler(false)
                  }
              })
          } else {
              completionHandler(false)
          }
      }
      
      /**
      Returns a UIImage from Image Data.

      - Parameter imageData: Image Data returned from capturing photo from the capture session.

      - Returns: UIImage from the image data, adjusted for proper orientation.
      */

      fileprivate func processPhoto(_ imageData: Data) -> UIImage {
          let dataProvider = CGDataProvider(data: imageData as CFData)
          let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)

          // Set proper orientation for photo
          // If camera is currently set to front camera, flip image

          let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: self.orientation.getImageOrientation(forCamera: self.currentCamera))

          return image
      }
            
}


// MARK: AVCaptureFileOutputRecordingDelegate

extension HYSwiftCameraVC : AVCaptureFileOutputRecordingDelegate {
    /// Process newly captured video and write it to temporary directory
    public func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let currentBackgroundRecordingID = backgroundRecordingID {
            backgroundRecordingID = UIBackgroundTaskIdentifier.invalid

            if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
            }
        }

        if let currentError = error {
            print("[SwiftyCam]: Movie file finishing error: \(currentError)")
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didFailToRecordVideo: currentError)
            }
        } else {
            //Call delegate function with the URL of the outputfile
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didFinishProcessVideoAt: outputFileURL)
            }
        }
        
    }
}



extension HYSwiftCameraVC : CamButtonDelegate {

    /// Sets the maximum duration of the SwiftyCamButton

    public func setMaxiumVideoDuration() -> Double {
        return maximumVideoDuration
    }

    /// Set UITapGesture to take photo

    public func buttonWasTapped() {
        takePhoto()
    }

    /// Set UILongPressGesture start to begin video

    public func buttonDidBeginLongPress() {
        startVideoRecording()
    }

    /// Set UILongPressGesture begin to begin end video


    public func buttonDidEndLongPress() {
        stopVideoRecording()
    }

    /// Called if maximum duration is reached

    public func longPressDidReachMaximumDuration() {
        stopVideoRecording()
    }
}



// Mark: UIGestureRecognizer Declarations-手势扩展
extension HYSwiftCameraVC{
    
    @objc fileprivate func zoomGesture(pinch: UIPinchGestureRecognizer)
    {
        guard pinchToZoom == true && self.currentCamera == .rear else {
                //ignore pinch
                return
            }
            do {
                let captureDevice = AVCaptureDevice.devices().first
                try captureDevice?.lockForConfiguration()

                zoomScale = min(maxZoomScale, max(1.0, min(beginZoomScale * pinch.scale,  captureDevice!.activeFormat.videoMaxZoomFactor)))

                captureDevice?.videoZoomFactor = zoomScale

                // Call Delegate function with current zoom scale
                DispatchQueue.main.async {
                    self.cameraDelegate?.swiftyCam(self, didChangeZoomLevel: self.zoomScale)
                }

                captureDevice?.unlockForConfiguration()

            } catch {
                print("[SwiftyCam]: Error locking configuration")
            }
       
    }
    /// Handle single tap gesture

    @objc fileprivate func singleTapGesture(tap: UITapGestureRecognizer) {
        guard tapToFocus == true else {
            // Ignore taps
            return
        }

        let screenSize = previewLayer!.bounds.size
        let tapPoint = tap.location(in: previewLayer!)
        let x = tapPoint.y / screenSize.height
        let y = 1.0 - tapPoint.x / screenSize.width
        let focusPoint = CGPoint(x: x, y: y)

        if let device = videoDevice {
            do {
                try device.lockForConfiguration()

                if device.isFocusPointOfInterestSupported == true {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                }
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
                device.unlockForConfiguration()
                //Call delegate function and pass in the location of the touch
                DispatchQueue.main.async {
                    self.cameraDelegate?.swiftyCam(self, didFocusAtPoint: tapPoint)
                }
            }
            catch {
                // just ignore
            }
        }
    }

    /// Handle double tap gesture

    @objc fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
        guard doubleTapCameraSwitch == true else {
            return
        }
        switchCamera()
    }

    @objc private func panGesture(pan: UIPanGestureRecognizer) {

        guard swipeToZoom == true && self.currentCamera == .rear else {
            //ignore pan
            return
        }
        
        let currentTranslation    = pan.translation(in: view).y
        let translationDifference = currentTranslation - previousPanTranslation

        do {
            let captureDevice = AVCaptureDevice.devices().first
            try captureDevice?.lockForConfiguration()

            let currentZoom = captureDevice?.videoZoomFactor ?? 0.0

            if swipeToZoomInverted == true {
                zoomScale = min(maxZoomScale, max(1.0, min(currentZoom - (translationDifference / 75),  captureDevice!.activeFormat.videoMaxZoomFactor)))
            } else {
                zoomScale = min(maxZoomScale, max(1.0, min(currentZoom + (translationDifference / 75),  captureDevice!.activeFormat.videoMaxZoomFactor)))

            }

            captureDevice?.videoZoomFactor = zoomScale

            // Call Delegate function with current zoom scale
            DispatchQueue.main.async {
                self.cameraDelegate?.swiftyCam(self, didChangeZoomLevel: self.zoomScale)
            }

            captureDevice?.unlockForConfiguration()

        } catch {
            print("[SwiftyCam]: Error locking configuration")
        }

        if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            previousPanTranslation = 0.0
        } else {
            previousPanTranslation = currentTranslation
        }
    }
    
    
    
    
    fileprivate func addGestureRecognizers()
    {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomGesture(pinch:)))
        pinchGesture.delegate = self
        previewLayer.addGestureRecognizer(pinchGesture)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture(tap:)))
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.delegate = self
        previewLayer.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGesture(tap:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        previewLayer.addGestureRecognizer(doubleTapGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(pan:)))
        panGesture.delegate = self
        previewLayer.addGestureRecognizer(panGesture)
    }
    
    
}



// MARK: UIGestureRecognizerDelegate

extension HYSwiftCameraVC : UIGestureRecognizerDelegate {
    /// Set beginZoomScale when pinch begins
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPinchGestureRecognizer.self) {
            beginZoomScale = zoomScale;
        }
        return true
    }
}
