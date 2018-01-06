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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var didTapAddIcon: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnCapture: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    
    var captureSession = AVCaptureSession()
    @IBOutlet weak var imgMini: UIImageView!
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?
    var imgViewIcon: UIImageView?
    
    private var originalCenter: CGPoint?
    var center = CGPoint(x: 150, y: 150)
    private var dragStart: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLastestImage()
        setupCamera()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addIconToCamera()
    }
    
    func setupCamera() {
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
    
    func setupLastestImage() {
        let photoLibrary = PhotoLibrary()
        let lastestPhoto = photoLibrary.getLastestPhoto()
        self.imgMini.image = lastestPhoto
    }
    
    @IBAction func actionCameraCapture(_ sender: AnyObject) {
        saveToCamera()
    }
    
    @IBAction func didTapSetting(_ sender: Any) {
        let settingViewController = Utilities.getViewController(identifier: SettingViewController.ClassName)
        self.present(settingViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddIcon(_ sender: Any) {
        
    }
    
    func addIconToCamera() {
        imgViewIcon?.removeFromSuperview()
        let nameCard = UserDefaultHelper.getCardName()
        let typeCard = UserDefaultHelper.getCardType()
        let frontImg = Utilities.showCard(cardName: CardName(rawValue: nameCard)!, cardType: CardType(rawValue: typeCard)!)
        imgViewIcon = IconView(image: frontImg)
        imgViewIcon?.frame = CGRect(x: 150, y: 150, width: 70, height: 100)
        imgViewIcon?.isUserInteractionEnabled = true
        self.viewCamera.addSubview(imgViewIcon!)
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
        
        self.viewCamera.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
        captureSession.startRunning()
        self.view.addSubview(btnSetting)
        
    }
    
    func saveToCamera() {
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (CMSampleBuffer, Error) in
                if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(CMSampleBuffer) {
                    
                    if let cameraImage = UIImage(data: imageData) {
                        let bgimgview = UIImageView(image: cameraImage) // Create the view holding the image
                        
                        let heightInPoints = cameraImage.size.height
                        let widthInPoints = cameraImage.size.width
                        bgimgview.frame = CGRect(x: 0, y: 0, width: widthInPoints, height: heightInPoints)
                        
                        if let icon = self.imgViewIcon {
                            bgimgview.addSubview(icon) // Add the front image on top of the background
                            let imgOutPut = UIImage(view: bgimgview)
                            UIImageWriteToSavedPhotosAlbum(imgOutPut, nil, nil, nil)
                            self.imgMini.image = imgOutPut
                        }
                        
                        
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



