//
//  ViewController.swift
//  CustomCamera
//
//  Created by Adarsh V C on 06/10/16.
//  Copyright © 2016 FAYA Corporation. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
  
  @IBOutlet weak var didTapAddIcon: UIButton!
  @IBOutlet weak var viewZ: UIView!
  @IBOutlet weak var imgVieww: UIImageView!
  @IBOutlet weak var btnCapture: UIButton!
  
  var captureSession = AVCaptureSession()
  let stillImageOutput = AVCaptureStillImageOutput()
  var previewLayer : AVCaptureVideoPreviewLayer?
  
  var captureDevice : AVCaptureDevice?
  var imgViewIcon: UIImageView?
  
  private var originalCenter: CGPoint?
  var center = CGPoint(x: 150, y: 150)
  private var dragStart: CGPoint?
  
  @IBAction func ádasd(_ sender: Any) {
    self.captureSession.stopRunning()
    self.previewLayer?.removeFromSuperlayer()
    
    self.previewLayer = nil
    captureSession.removeOutput(stillImageOutput)
    self.viewZ.isHidden = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.isNavigationBarHidden = true
    captureSession.sessionPreset = AVCaptureSessionPresetHigh
    
    if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
      // Loop through all the capture devices on this phone
      for device in devices {
        // Make sure this particular device supports video
        if (device.hasMediaType(AVMediaTypeVideo)) {
          // Finally check the position and confirm we've got the back camera
          if(device.position == AVCaptureDevicePosition.front) {
            captureDevice = device
            if captureDevice != nil {
              print("Capture device found")
              beginSession()
            }
          }
        }
      }
    }
  }
  
  @IBAction func actionCameraCapture(_ sender: AnyObject) {
    saveToCamera()
  }
  
  @IBAction func didTapSetting(_ sender: Any) {
    
  }
  
  @IBAction func didTapAddIcon(_ sender: Any) {
    let frontimg = UIImage(named: "baby")
    imgViewIcon = IconView(image: frontimg)
    imgViewIcon?.frame = CGRect(x: 150, y: 150, width: 50, height: 50)
    imgViewIcon?.isUserInteractionEnabled = true
    self.viewZ.addSubview(imgViewIcon!)
  }
  
  
  func beginSession() {
    
    do {
      try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
      stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
      
      if captureSession.canAddOutput(stillImageOutput) {
        captureSession.addOutput(stillImageOutput)
      }
      
    }
    catch {
      print("error: \(error.localizedDescription)")
    }
    
    guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else {
      print("no preview layer")
      return
    }
    
    self.viewZ.layer.addSublayer(previewLayer)
    previewLayer.frame = self.view.layer.frame
    captureSession.startRunning()
    
    //        self.view.addSubview(navigationBar)
    //        self.view.addSubview(imgOverlay)
    self.view.addSubview(btnCapture)
    
  }
  
  func saveToCamera() {
    
    if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
      
      stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
        if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
          
          if let cameraImage = UIImage(data: imageData) {
            //                        let bgimg = UIImage(named: "ImgCameraCaptureBtn") // The image used as a background
            let bgimgview = UIImageView(image: cameraImage) // Create the view holding the image
            bgimgview.frame = CGRect(x: 0, y: 0, width: 500, height: 500) // The size of the background image
            
            let frontimg = UIImage(named: "ImgOverlay")
            let frontimgview = UIImageView(image: frontimg)
            frontimgview.frame = CGRect(x: 150, y: 300, width: 150, height: 100) // The size and position of the front image
            
            //                        self.view.layer.contents = bgimgview.CGImage
            bgimgview.addSubview(frontimgview) // Add the front image on top of the background
            let imgg = UIImage(view: bgimgview)
            self.imgVieww.image = imgg
            
            
            //                        UIImageWriteToSavedPhotosAlbum(imgg, nil, nil, nil)
          }
        }
      })
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in:UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }
}

extension CGPoint {
  static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
  static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }
}

