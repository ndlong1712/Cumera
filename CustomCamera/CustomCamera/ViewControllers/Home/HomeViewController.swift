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
import KDCircularProgress

let CRMsgCaptureSuccess = "captureSuccess"
let CRMsgCaptureError = "captureError"
let CRTutorial = "tutorial"
let youtubeURL = "https://www.youtube.com/channel/UCPG9BazSiVtfTGfvNFLxZmg"

enum CurrentOrientation: Int {
    case portrait = 0
    case left = 1
    case right = 2
    case upsideDown = 3
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewBot: UIView!
    @IBOutlet weak var didTapAddIcon: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var imgMini: UIImageView!
    @IBOutlet weak var btnAds: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    
    var captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    var imgViewIcon: IconView?
    var progress: KDCircularProgress!
    
    var originalCenter: CGPoint?
    var dragStart: CGPoint?
    var center = CGPoint(x: 150, y: 150)
    var isCapturing = false
    var currentDegree:CGFloat = 0
    var currentOrientation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupProgressBar()
//        setupLastestImage()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addIconToCamera()
    }
    
    func deviceDidRotate() {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft{
            if currentOrientation == CurrentOrientation.portrait.rawValue {
                self.rotateIcon(degree: CGFloat.pi/2)
            } else if currentOrientation == CurrentOrientation.right.rawValue {
                self.rotateIcon(degree: CGFloat.pi)
            } else if currentOrientation == CurrentOrientation.upsideDown.rawValue {
                self.rotateIcon(degree: -CGFloat.pi/2)
            }
            currentOrientation = CurrentOrientation.left.rawValue
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            if currentOrientation == CurrentOrientation.portrait.rawValue {
                self.rotateIcon(degree: -CGFloat.pi/2)
            } else if currentOrientation == CurrentOrientation.left.rawValue {
                self.rotateIcon(degree: CGFloat.pi)
            } else if currentOrientation == CurrentOrientation.upsideDown.rawValue {
                self.rotateIcon(degree: CGFloat.pi/2)
            }
            currentOrientation = CurrentOrientation.right.rawValue
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            if currentOrientation == CurrentOrientation.portrait.rawValue {
                self.rotateIcon(degree: -CGFloat.pi)
            } else if currentOrientation == CurrentOrientation.right.rawValue {
                self.rotateIcon(degree: -CGFloat.pi/2)
            } else if currentOrientation == CurrentOrientation.left.rawValue {
                self.rotateIcon(degree: CGFloat.pi/2)
            }
            currentOrientation = CurrentOrientation.upsideDown.rawValue
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portrait{
            if currentOrientation == CurrentOrientation.left.rawValue {
                self.rotateIcon(degree: -CGFloat.pi/2)
            } else if currentOrientation == CurrentOrientation.right.rawValue {
                self.rotateIcon(degree: CGFloat.pi/2)
            } else if currentOrientation == CurrentOrientation.upsideDown.rawValue {
                self.rotateIcon(degree: -CGFloat.pi)
            }
            currentOrientation = CurrentOrientation.portrait.rawValue
        }
        
        
    }
    
    func rotateIcon(degree: CGFloat)  {
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotationAnimation.fromValue = from
//        rotationAnimation.toValue = to
//        rotationAnimation.duration = 0.5
//        rotationAnimation.isRemovedOnCompletion = false
//        rotationAnimation.fillMode = kCAFillModeForwards
//        self.imgViewIcon?.layer.add(rotationAnimation, forKey: nil)
        UIView.animate(withDuration: 0.5) {
          self.imgViewIcon?.transform = (self.imgViewIcon?.transform.rotated(by: degree))!
        }
        
    }
    
    func setupProgressBar() {
        let widthProgres = self.viewBot.frame.height * 0.7
        let x = self.viewBot.frame.width/2 - widthProgres/2
        let y = self.viewBot.frame.height/2 - widthProgres/2
        progress = KDCircularProgress(frame: CGRect(x: x, y: y, width: widthProgres, height: widthProgres))
        progress.startAngle = -90
        progress.progressThickness = 0.2
        progress.trackThickness = 0.3
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.trackColor = UIColor.white
        progress.layer.borderWidth = 0.5
        progress.layer.borderColor = UIColor.lightGray.cgColor
        progress.layer.cornerRadius = progress.frame.width/2
        progress.addTapGesture(tapNumber: 1, target: self, action: #selector(actionCameraCapture))
        progress.set(colors: UIColor.blue, UIColor.cyan, UIColor.blue)
        progress.progressInsideFillColor = UIColor.red
        
        viewBot.addSubview(progress)
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        // Constraint center and width
        viewBot.addConstraint(NSLayoutConstraint(item: progress, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthProgres))
        viewBot.addConstraint(NSLayoutConstraint(item: progress, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthProgres))
        viewBot.addConstraint(NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: viewBot, attribute: .centerX, multiplier: 1.0, constant: 0.0));
        viewBot.addConstraint(NSLayoutConstraint(item: progress, attribute: .centerY, relatedBy: .equal, toItem: viewBot, attribute: .centerY, multiplier: 1.0, constant: 0.0));
    }
  
    func setupCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice] {
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevicePosition.back) {
                        captureDevice = device
                        if captureDevice != nil {
                            print("Capture device found")
                            beginSession()
//                            zoomInCamera(value: 1)
                        }
                    }
                }
            }
        }
    }
    
    func setupLastestImage() {
        let photoLibrary = PhotoLibrary()
        let lastestPhoto = photoLibrary.getLastestPhoto()
        self.imgMini.image = lastestPhoto
    }
    
    func actionCameraCapture() {
        if !isCapturing { //prevent multi touch
            isCapturing = true
            let statusCaptureTimer = UserDefaultHelper.getStatusIsCaptureTimer()
            if statusCaptureTimer {
                let timer = UserDefaultHelper.getCaptureTimer()
                progress.animate(fromAngle: 0, toAngle: 360, duration: TimeInterval(timer)) { completed in
                    if completed {
                        print("animation stopped, completed")
                        self.saveToCamera()
                        self.progress.progress = 0
                    } else { // progress fail
                        self.progress.progress = 0
                        self.isCapturing = false
                    }
                }
            } else {
                saveToCamera()
            }
        }
        
    }
    
    @IBAction func didTapSetting(_ sender: Any) {
        let settingViewController = Utilities.getViewController(identifier: SettingViewController.ClassName)
        self.present(settingViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapIntrodution(_ sender: Any) {
        Utilities.showAlert(message: CRTutorial.localized(), okTitle: "OK", cancelTitle: CRCancel.localized(), viewController: self, okAction: {
            Utilities.openUrl(url: youtubeURL)
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapInfo(_ sender: Any) {
        let infoViewController = Utilities.getViewController(identifier: InfoViewController.ClassName)
        self.present(infoViewController, animated: true, completion: nil)
    }
    
    //change icon mode
    @IBAction func didTapAddIcon(_ sender: Any) {
        changeBrightModeIcon(currentMode: (self.imgViewIcon?.brightMode)!, iconView: self.imgViewIcon!)
    }
    
    @IBAction func didTapChangeIconMode(_ sender: Any) {
//        changeBrightModeIcon(currentMode: (self.imgViewIcon?.brightMode)!, iconView: self.imgViewIcon!)
    }
    
    func zoomInCamera(value: CGFloat)  {
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.videoZoomFactor += value
            captureDevice?.unlockForConfiguration()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func zoomOutCamera(value: CGFloat) {
        do {
            try captureDevice?.lockForConfiguration()
            captureDevice?.videoZoomFactor -= value
            captureDevice?.unlockForConfiguration()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func addIconToCamera() {
        imgViewIcon?.removeFromSuperview()
        let nameCard = UserDefaultHelper.getCardName()
        let typeCard = UserDefaultHelper.getCardType()
        let frontImg = Utilities.showCard(cardName: CardName(rawValue: nameCard)!, cardType: CardType(rawValue: typeCard)!)
        imgViewIcon = IconView(image: frontImg)
        imgViewIcon?.delegate = self
        imgViewIcon?.frame = CGRect(x: 150, y: 150, width: 70, height: 100)
        imgViewIcon?.setUpImageView()
        imgViewIcon?.isUserInteractionEnabled = true

        self.view.addSubview(imgViewIcon!)
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
        
        self.viewCamera.layoutIfNeeded()
         previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        self.view.addSubview(btnSetting)
        self.view.addSubview(btnAds)
        self.view.addSubview(btnInfo)
        self.view.addSubview(viewBot)
        
    }
    
    func saveToCamera() {
            if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
                //            zoomOutCamera(value: 1)
                stillImageOutput.isHighResolutionStillImageOutputEnabled = true
                stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                        
                        if let cameraImage = UIImage(data: imageData) {
                            let bgimgview = UIImageView(image: cameraImage) // Create the view holding the image
                            
                            bgimgview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                            
                            if let icon = self.imgViewIcon {
                                let copiedView: UIImageView = icon.copyView()
                                bgimgview.addSubview(copiedView) // Add the front image on top of the background
                                let imgOutPut = UIImage(view: bgimgview)
                                UIImageWriteToSavedPhotosAlbum(imgOutPut, self, #selector(HomeViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
                            }
                            
                        }
                    }
                })
        }
    }
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let er = error {
            // we got back an error!
            Utilities.showAlert(message: er.localizedDescription, okTitle: "OK", cancelTitle: "", viewController: self, okAction: { }, cancelAction: {})
        } else {
            self.imgMini.image = image
        }
        self.isCapturing = false
    }
    
    func changeBrightModeIcon(currentMode: BrightStyle, iconView: IconView) {
        switch currentMode {
        case .Dark:
            iconView.brightMode = .Normal
            break
        case .Normal:
            iconView.brightMode = .Light
            break
        case .Light:
            iconView.brightMode = .Dark
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: IConViewDelegate {
    func didTapOnICon() {
        
        print("Current mode: \(String(describing: self.imgViewIcon?.brightMode))")
        //change Image
    }
}



