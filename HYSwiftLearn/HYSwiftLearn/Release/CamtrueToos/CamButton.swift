//
//  CamButton.swift
//  HYSwiftLearn
//
//  Created by fanhaoyun on 2020/5/18.
//  Copyright © 2020 范浩云. All rights reserved.
//

import UIKit

public protocol CamButtonDelegate : class
{
         
     func buttonWasTapped()
     
     
     func buttonDidBeginLongPress()
     

     func buttonDidEndLongPress()
     
     
     func longPressDidReachMaximumDuration()
     
     
     func setMaxiumVideoDuration() -> Double
}

open class CamButton: UIButton
{

    public weak var delegate: CamButtonDelegate?
    
    public var buttonEnabled = true
    
    fileprivate var timer : Timer?

    public override init(frame: CGRect)
    {
        super.init(frame: frame)
         createGestureRecognizers()
    }
    

    required public init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        createGestureRecognizers()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func Tap() {
        guard buttonEnabled == true else {
            return
        }
       delegate?.buttonWasTapped()
    }
    
    @objc fileprivate func LongPress(_ sender:UILongPressGestureRecognizer!)  {
          guard buttonEnabled == true else {
              return
          }
          
          switch sender.state {
          case .began:
              delegate?.buttonDidBeginLongPress()
              startTimer()
          case .cancelled, .ended, .failed:
                invalidateTimer()
              delegate?.buttonDidEndLongPress()
          default:
              break
          }
      }
    
    
    @objc fileprivate func timerFinished() {
        invalidateTimer()
        delegate?.longPressDidReachMaximumDuration()
    }
    
    
    fileprivate func startTimer() {
          if let duration = delegate?.setMaxiumVideoDuration() {
              //Check if duration is set, and greater than zero
              if duration != 0.0 && duration > 0.0 {
                  timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector:  #selector(CamButton.timerFinished), userInfo: nil, repeats: false)
              }
          }
      }
      
      // End timer if UILongPressGestureRecognizer is ended before time has ended
      
      fileprivate func invalidateTimer() {
          timer?.invalidate()
          timer = nil
      }
    
    
    fileprivate func createGestureRecognizers() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CamButton.Tap))
           let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(CamButton.LongPress))
           self.addGestureRecognizer(tapGesture)
           self.addGestureRecognizer(longGesture)
       }

}
