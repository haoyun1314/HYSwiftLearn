//
//  HYCameraManager.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/11/20.
//  Copyright © 2020 范浩云. All rights reserved.
//拍照流程：
// 1.创建会话
// 2.创建输入设备
// 3.创建输入
// 4.创建输出设备
// 5.创建输出
// 6.连接输入与会话
// 7.预览画面
///////////

//

import UIKit
import AVFoundation





class HYCameraManager: NSObject,AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate
{
    

    let  DeviceIsPad: Bool = (UI_USER_INTERFACE_IDIOM() == .pad)
    
    
    typealias DidCapturePhotoBlock = (_ imge:UIImage?) -> ()

    public enum CameraDirection
    {
        case CameraDirectionPortrait
        case CameraDirectionLandscapeLeft
        case CameraDirectionLandscapeRight
    }
    
    var isCheckBright : Bool = false;
    ///
    fileprivate var preview : UIView!;
    ///
    fileprivate let sessionQueue =  DispatchQueue.init(label: "session queue")
    ///
    fileprivate let scanQueue = DispatchQueue.init(label:"scanQueue")
    //会话
    public var session = AVCaptureSession()
    //预览view
    public var previewLayer = AVCaptureVideoPreviewLayer()
    //输入设备
    public var inputDevice : AVCaptureDeviceInput!
    //视频输出
    public var videoDataOutput : AVCaptureVideoDataOutput!
    //IOS10之前的拍照API图片输出
    public var stillImageOutput : AVCaptureStillImageOutput!
    //IOS10以上的拍照API图片输出
    public var photoImageOutput : AVCapturePhotoOutput!
    
    public var photoSetting : AVCapturePhotoSettings!
    
    var brightBlock:(() -> (Int))?
    
    var finishRunBlock:(()->())?
    
    var capturegGetPhotoBlock:DidCapturePhotoBlock?

    var preScaleNum : CGFloat = 0
    
    var scaleNum  : CGFloat = 0
    
    public var direction:CameraDirection    = .CameraDirectionPortrait
    
    var isSearchPic : Bool = false;
    
    var CaptureOK : Bool = false;

    var preivewRect : CGRect = CGRect.zero
    var isFrontCamera : Bool = false;

    

    
    //指定构造函数
    override init() {
        super.init()
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
  
    }
    
    
    
    
////    永远不会内联
//    @inline(never) func test() {
//
//    }
//
////
//    @inline(__always) func aa()
//    {
//
//    }
    
    
    
    
    

    
    
    func configureWithParentLayer(parent:UIView,preivewRect:CGRect,
                                  orientation:AVCaptureVideoOrientation,
                                  isFrontCamera:Bool) {
        
        self.preivewRect = preivewRect
        self.isFrontCamera = isFrontCamera
        self.addSession()
        self.addVideoInputFrontCamera(position: AVCaptureDevice.Position.back)
        self.addImageOutput()
        self.addCaptureVideo()
        self.addVideoPreviewLayerWithRect(preivewRect)
        self.previewLayer.connection?.videoOrientation = orientation
        self.preview = parent;
        preview.layer.addSublayer(self.previewLayer)
        
    }


    func addLayerToParentView(_ aParentView: UIView) {
        self.preview = aParentView
        aParentView.layer.addSublayer(self.previewLayer)
    }

    
    /**
     *  session
     */
    func addSession(){
        let tmpSession: AVCaptureSession = AVCaptureSession.init();
        if DeviceIsPad {
            if tmpSession.canSetSessionPreset(AVCaptureSession.Preset.photo)
            {
                tmpSession.sessionPreset = AVCaptureSession.Preset.photo
            }
        }
        else
        {
            if tmpSession.canSetSessionPreset(AVCaptureSession.Preset.high) {
                tmpSession.sessionPreset = AVCaptureSession.Preset.high
            }
        }
        self.session = tmpSession
    }
        
    /**
     *  相机的实时预览页面
     *
     *  @param previewRect 预览页面的frame
     */
    
    func addVideoPreviewLayerWithRect(_ previewRect: CGRect)  {
        
        let preview = AVCaptureVideoPreviewLayer.init(session:self.session)
        preview.backgroundColor = UIColor.red.cgColor
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.connection?.videoOrientation = .portrait;
        preview.frame = .init(origin: previewRect.origin, size: previewRect.size)
        self.previewLayer = preview;
    }
        /**
         *  添加输入设备
         *
         *  @param front 前或后摄像头
         */
    func addVideoInputFrontCamera(position: AVCaptureDevice.Position)
    {
        var backCamera: AVCaptureDevice?
        if #available(iOS 10.0, *) {
                backCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType(rawValue:AVMediaType.video.rawValue), position:position)
        }
        else
        {
            let devices = AVCaptureDevice.devices(for: AVMediaType(rawValue: AVMediaType.video.rawValue))
            for device  in devices
            {
                if device.position == position {
                    backCamera = device;
                    break;
                }
            }
        }
        
        
        do {
            if let videoDevice = backCamera
            {
                let backFacingCameraDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                if session.canAddInput(backFacingCameraDeviceInput)
                 {
                    session.addInput(backFacingCameraDeviceInput)
                    self.inputDevice = backFacingCameraDeviceInput
                }
                else
                {
                    print("[SwiftyCam]: Could not add video device input to the session")
                }
            }
            
        } catch {
            let error:Error? = nil
            print("Unexpected error: \(String(describing: error)).")
        }
        
    }
       
    
    /**
    *  添加输出设备
    1.6、重复使用照片设置
     
    每个AVCapturePhotoSettings实例只能被一次拍摄使用，否则uniqueID会与之前的拍摄设置的uniqueID相同，导致-capturePhotoWithSettings:delegate:方法异常 NSInvalidArg umentException 。

    第一次创建：+ (instancetype)photoSettingsWithFormat:(nullable NSDictionary<NSString *, id> *)format;
     
     第二次重复使用：
    我们可以使用下述方法创建一个新的AVCapturePhotoSettings，来实现重复使用特定的设置组合的需求。新创建的实例的uniqueID属性具有新的唯一值，但会复制photoSettings参数中所有其他属性的值。
    + (instancetype)photoSettingsFromPhotoSettings:(AVCapturePhotoSettings *)photoSettings;
     
    2、AVCapturePhotoSettings 的唯一标识
    @property(readonly) int64_t uniqueID;
    创建AVCapturePhotoSettings 实例会自动为此属性分配唯一值。

    使用此属性可跟踪照片拍摄请求。在AVCapturePhotoOutput的协议方法都包含一个AVCaptureResolvedPhotoSettings实例，其uniqueID属性与用于请求拍摄时创建的AVCapturePhotoSettings实例的uniqueID值相匹配。
    */
    
    
//    addStillImageOutput
    
    
    func addImageOutput() {
        
        if #available(iOS 10.0, *)
        {
            let tmpOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
            if #available(iOS 11.0, *)
            {
                let setDic = ["AVVideoCodecKey":AVVideoCodecType.jpeg];
                self.photoSetting = AVCapturePhotoSettings.init(format: setDic)
            }
            else
            {
                let setDic = ["AVVideoCodecKey":AVVideoCodecJPEG]
                self.photoSetting = AVCapturePhotoSettings.init(format: setDic)
                
            }
            tmpOutput.photoSettingsForSceneMonitoring = self.photoSetting;
            if self.session.canAddOutput(tmpOutput)
            {
                self.session.addOutput(tmpOutput)
            }
            
            self.photoImageOutput = tmpOutput
            
        }
        else
        {

            let tmpOutput =  AVCaptureStillImageOutput.init()
            let outputSettings = ["AVVideoCodecKey":AVVideoCodecJPEG]
            tmpOutput.outputSettings = outputSettings
            if self.session.canAddOutput(tmpOutput) {
                self.session.addOutput(tmpOutput)
            }
            self.stillImageOutput = tmpOutput
        }
        
    }
    
    
    
    
    /**
    1. 判断是否有手电筒 [device hasTorch]
    2.self.isSearchPic是否是前置摄像头
    */
    
    
    func addCaptureVideo()
    {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if (device?.hasTorch) != nil
        {
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(self,queue:self.scanQueue)
            videoDataOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): Int(kCVPixelFormatType_32BGRA)]
            
            if session.canAddOutput(videoDataOutput) {
                    session.addOutput(videoDataOutput)
            }
        }
        
    }
    
    
    func findVideoConnection() -> AVCaptureConnection?{
        if #available(iOS 10.0, *)
        {
            if let connction = self.photoImageOutput.connection(with: AVMediaType.video)
            {
                return connction
            }
            else
            {
                return nil
            }
        }
        else
        {
            
            var videoConnection: AVCaptureConnection?
            
            for   connect:AVCaptureConnection  in self.stillImageOutput.connections  {
                for port:AVCaptureInput.Port in connect.inputPorts {
                    if port.mediaType == AVMediaType.video {
                        videoConnection = connect
                        videoConnection?.videoOrientation = self.getVideoOrientation()
                        break
                    }
                }
                if videoConnection != nil {
                    break
                }
            }
            return videoConnection
           }
    }
    
    
    
    func takePicture(block:@escaping DidCapturePhotoBlock){
        
        self.capturegGetPhotoBlock = block;
        if #available(iOS 10.0, *)
        {
            let videoConnection = self.findVideoConnection();
            if videoConnection != nil
            {
                print("获取videoConnection失败")
                return;
            }
            
            if #available(iOS 11.0, *)
            {
                let setDic = ["AVVideoCodecKey":AVVideoCodecType.jpeg];
                self.photoSetting = AVCapturePhotoSettings.init(format: setDic)
            }
            else
            {
                let setDic = ["AVVideoCodecKey":AVVideoCodecJPEG]
                self.photoSetting = AVCapturePhotoSettings.init(format: setDic)
                
            }
            self.photoImageOutput.photoSettingsForSceneMonitoring = self.photoSetting
            videoConnection?.videoOrientation = self.getVideoOrientation()
            videoConnection?.videoScaleAndCropFactor = self.scaleNum
            self.photoImageOutput.capturePhoto(with:self.photoSetting, delegate:self)
            
        }
        else
        {
            let videoConnection = self.findVideoConnection();
            if videoConnection != nil
            {
                print("获取videoConnection失败")
                return;
            }
            videoConnection?.videoScaleAndCropFactor = self.scaleNum
            
            self.stillImageOutput.captureStillImageAsynchronously(from:videoConnection!) { (imageDataSampleBuffer: CMSampleBuffer?, error: Error?) in
                if error == nil && imageDataSampleBuffer != nil
                {
                      if  let  imageData : Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
                      {
                        let image:UIImage = UIImage.init(data:imageData)!
                        block(image)
                      }
                      else
                      {
                        block(nil)
                      }
                }
                else
                {
                    
                }
            
            }

        }
        
    }
    
    
    
    func getVideoOrientation() -> AVCaptureVideoOrientation {
        switch self.direction
        {
        case CameraDirection.CameraDirectionPortrait:
            return AVCaptureVideoOrientation.portrait;
        case CameraDirection.CameraDirectionLandscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft;
        case CameraDirection.CameraDirectionLandscapeRight:
            return AVCaptureVideoOrientation.landscapeRight;
        default:
            return AVCaptureVideoOrientation.portrait;
            break;
        }
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        
        print("AVCaptureConnection")
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        
        print("运行")
    }
    
    
    
//    #pragma mark--图片输出
    /**
     ios11开始我们就可以使用HIEF(HEIC)格式来存储图片和视频了.这种格式体积小速度快(硬解码)
     使用苹果的 iPhone 或 iPad 拍摄照片,该照片将以 .HEIC 扩展名保存在「照片」文件当中。由于 HEIC 是一种容器格式，所以它可以存储以 HEVC 格式编码的声音和图像。
     
     例如，你在 iPhone 上拍摄照片时启用了 Live Photo，则会得到一个 .HEIC 文件，这个文件中会包含多张照片和录制的声音文件——组成 Live Photo 的所有内容。
     
     HEIF优于JPEG图像格式
     高效率图像格式在各方面均优于 JPEG，通过使用更现代的压缩算法，它可以将相同数量的数据大小压缩到 JPEG 图像文件的 50% 左右。随着手机 Camera 的不断升级，照片的细节也日益增加。通过将照片存储为 HEIF 格式而不非 JPEG，可以让文件大小减半，几乎可以在同一部手机上存储以前 2 倍的照片数量。如果一些云服务也支持 HEIF 文件，则上传到在线服务的速度也会更快，并且使用更少的存储空间。在 iPhone 上，这意味着您的照片应该会以以前两倍的速度上传到 iCloud 照片库。
     
     HEIC唯一缺点：兼容性
     目前使用 HEIF 或 HEIC 照片唯一的缺点就是兼容性问题。现在的软件只要能够查看图片，那它肯定就可以读取 JPEG 图像，但如果你拍摄了以 HEIF 或 HEIC 扩展名结尾的图片，并不是在所有地方和软件中都可以正确识别
     */
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?)
    {
        
        if error != nil
        {
            //这个就是HEIF(HEIC)的文件数据,直接保存即可
            let dataImg:Data = photo.fileDataRepresentation()!
            if let image:UIImage = UIImage.init(data: dataImg),let getImgBlock:DidCapturePhotoBlock = self.capturegGetPhotoBlock
            {
                getImgBlock(image)
            }
            
        }else
        {
            NSLog("获取图片失败");
        }
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
        if error != nil
        {
            //这个就是HEIF(HEIC)的文件数据,直接保存即可
            let dataImg:Data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)!
            if let image:UIImage = UIImage.init(data: dataImg),let getImgBlock:DidCapturePhotoBlock = self.capturegGetPhotoBlock
            {
                getImgBlock(image)
            }
            
        }else
        {
            NSLog("获取图片失败");
        }
        
    }

    func sessionStartRunning() {
        self.sessionQueue.async {
            if !self.session.isRunning
            {
                self.session .startRunning()
            }
        }
    }
    
    
    func sessionStopRunning()  {
        self.sessionQueue.async {
            if self.session.isRunning
            {
                self.session.stopRunning()
            }
        }
    }

    
    
  
        
        
//    }


    //TODO:获取相机权限
//    + (void)authorizeCameraWithCompletion:(void(^)(BOOL granted,BOOL firstTime))completion;
//    {
//        if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
//        {
//            AVAuthorizationStatus permission =
//            [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//            switch (permission) {
//                case AVAuthorizationStatusAuthorized:
//                    completion(YES,NO);
//                    break;
//                case AVAuthorizationStatusDenied:
//                case AVAuthorizationStatusRestricted:
//                    completion(NO,NO);
//                    break;
//                case AVAuthorizationStatusNotDetermined:
//                {
//                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
//                                             completionHandler:^(BOOL granted) {
//                                                 if (completion) {
//                                                     dispatch_async(dispatch_get_main_queue(), ^{
//                                                         completion(granted,YES);
//                                                     });
//                                                 }
//                                             }];
//
//                }
//                    break;
//            }
//        } else {
//            //iOS7以前默认都会授权
//            completion(YES,NO);
//        }
//    }
    
    
    
    
    
    
    
/*
    
    /**
     //TODO:  切换前后摄像头
     *
     *  @param isFrontCamera YES:前摄像头  NO:后摄像头
     */
    
    
    func switchCamera(isFrontCamera:Bool)
    {
        if self.inputDevice != nil {
            return
        }
        self.session.beginConfiguration()
        let device = self.inputDevice.device
        NotificationCenter.default.removeObserver(session, name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: device)
        self.session.removeInput(self.inputDevice)
        if isFrontCamera {
            self.addVideoInputFrontCamera(position: AVCaptureDevice.Position.back)
        }
        else
        {
            self.addVideoInputFrontCamera(position: AVCaptureDevice.Position.front)
        }
        self.session.commitConfiguration()
    }
    
    
    func pinchCameraViewWithScalNum(scale:CGFloat){
        self.scaleNum = scale

        if self.scaleNum < 1.0 {
            self.scaleNum = 1.0
        }
        else if self.scaleNum>3.0
        {
            self.scaleNum = 3.0
        }
        self.preScaleNum = scale;
        self.doPinch()
    }
    
    
    
    
    
    
    func doPinch()
    {
        let videoConnection: AVCaptureConnection = self.findVideoConnection()!
        if videoConnection != nil
        {
            let  maxScale:CGFloat = videoConnection.videoMaxScaleAndCropFactor;
            
            //videoScaleAndCropFactor这个属性取值范围是1.0-videoMaxScaleAndCropFactor。iOS5+才可以用
            if (self.scaleNum > maxScale) {
                self.scaleNum = maxScale;
            }
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.025)
            let affTrasform:CGAffineTransform = CGAffineTransform.init(scaleX:self.scaleNum,y:self.scaleNum)
            self.previewLayer.setAffineTransform(affTrasform)
            CATransaction.commit()
        }
        else
        {
            
        }
        
    }
    
    
    
    
    
//    /**
//    //TODO: 拉近拉远镜头
//     *
//     *  @param scale 拉伸倍数
//     */
//    - (void)pinchCameraViewWithScalNum:(CGFloat)scale
//    {
//        _scaleNum = scale;
//        if (_scaleNum < MIN_PINCH_SCALE_NUM) {
//            _scaleNum = MIN_PINCH_SCALE_NUM;
//        } else if (_scaleNum > MAX_PINCH_SCALE_NUM) {
//            _scaleNum = MAX_PINCH_SCALE_NUM;
//        }
//        [self doPinch];
//        _preScaleNum = scale;
//    }

    
    
    
//    - (void)switchCamera:(BOOL)isFrontCamera
//    {
//        if (!_inputDevice) {
//            return;
//        }
//        [_session beginConfiguration];
//
//         AVCaptureDevice *device = [_inputDevice device];
//
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:device];
//
//        [_session removeInput:_inputDevice];
//
//        [self addVideoInputFrontCamera:isFrontCamera];
//
//        [_session commitConfiguration];
//    }

    
    
   
//
//    /**
//     *  拍照
//     */
//    - (void)takePicture:(DidCapturePhotoBlock)block
//    {
//
//        [[JZBPerformanceOptimizeMonitor sharedManager] takeNote_camera_takePhoto_start];
//        self.capturegGetPhotoBlock = block;
//
//        if (@available(iOS 10.0, *))
//        {
//            AVCaptureConnection *videoConnection = [self findVideoConnection];
//             if (!videoConnection)
//             {
//                 [ZYBNlog logWithEventType:kEventTypeClick labe:@"videoConnectionError" params:@{}];
//                  return;
//              }
//            if (@available(iOS 11.0, *))
//            {
//                NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
//                self.photoSetting  = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
//            }
//            else
//            {
//                NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecJPEG};
//                self.photoSetting  = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
//            }
//
//
//            if (self.photoSetting ==nil) {
//                [ZYBNlog logWithEventType:kEventTypeClick labe:@"photoSettingError" params:@{}];
//                return;
//            }
//
//
//            [self.imageOutput setPhotoSettingsForSceneMonitoring:self.photoSetting];
//            //必须保持self.photoSetting.uniqueID是唯一的负责会报异常
//            NSLog(@"self.photoSetting = %lld",self.photoSetting.uniqueID);
//            [videoConnection setVideoOrientation:[self getVideoOrientation]];
//            [videoConnection setVideoScaleAndCropFactor:_scaleNum];
//            [self.imageOutput capturePhotoWithSettings:self.photoSetting delegate:self];
//        }
//        else
//        {
//            AVCaptureConnection *videoConnection = [self findVideoConnection];
//               [videoConnection setVideoScaleAndCropFactor:_scaleNum];
//                       if (!videoConnection) {return;}
//                       @try {
//
//                           NSLog(@"%@",[NSThread currentThread]);
//
//
//                           [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
//                                                                          completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//
//                                                                              if (!error && imageDataSampleBuffer) {
//
//                                                                                  NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                                                                                  UIImage *image = [[UIImage alloc] initWithData:imageData];
//
//
//                                                       [[JZBPerformanceOptimizeMonitor sharedManager] takeNote_camera_takePhotoOK:YES andException:nil];
//                                                                                  if (block) {
//                                                                                      block(image);
//                                                                                  }
//                                                                              }
//
//                                                                          }];
//                       }
//                       @catch (NSException *exception) {
//                           [[JZBPerformanceOptimizeMonitor sharedManager] takeNote_camera_takePhotoOK:NO andException:exception];
//                       }
//
//        }
//    }
//
//
    
    
    
    
//    - (AVCaptureVideoOrientation)getVideoOrientation
//    {
//        switch (self.direction) {
//            case CameraDirectionPortrait:
//                return AVCaptureVideoOrientationPortrait;
//            case CameraDirectionLandscapeLeft:
//                return AVCaptureVideoOrientationLandscapeRight;
//            case CameraDirectionLandscapeRight:
//                return AVCaptureVideoOrientationLandscapeLeft;
//            default:
//                return AVCaptureVideoOrientationPortrait;
//                break;
//        }
//    }
//
    
    
    
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        
    }
    
*/
    
    
    
    
    
    

    



    
    
}
    
    
 
