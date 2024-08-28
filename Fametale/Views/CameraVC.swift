//
//  CameraVC.swift
//  Fametale
//
//  Created by Callsoft on 03/07/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import SwiftyCam


@available(iOS 10.2, *)
class CameraVC: SwiftyCamViewController,SwiftyCamViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var camPreview: UIView!
    //MARK:- VARIABLES
    //MARK:
    
    var captureSession = AVCaptureSession()
    
    let movieOutput = AVCaptureMovieFileOutput()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    
    var timer:Timer?
    
    var secondsCount = 0
    var count = 60
    
    var picker = UIImagePickerController()
    
    var DidTappedGallary =  false
    
    var video_url:URL?
    
   
    var cameraView = UIImageView()
    
    
 
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var toggle = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        //picker.delegate =  self
        
        
        
        //SWIFTY CAM
        cameraDelegate = self
        maximumVideoDuration = 60.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        
    }
    
     //SWIFTY CAM METHOD
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //captureButton.delegate = self
    }

    //SWIFTY CAM METHOD
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        //captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            //self.flashButton.alpha = 0.0
//            self.flipCameraButton.alpha = 0.0
        })
    }

    //SWIFTY CAM METHOD
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        //captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
//            self.flashButton.alpha = 1.0
//            self.flipCameraButton.alpha = 1.0
        })
    }

    //SWIFTY CAM METHOD
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        
        
        let videoRecorded = url as URL
                    let vc  = storyboard?.instantiateViewController(withIdentifier: "PlayVideoVC") as! PlayVideoVC
                    vc.videoURL = videoRecorded
                    timer?.invalidate()
                    timer =  nil
                    self.navigationController?.pushViewController(vc, animated: true)
        
//        let newVC = VideoViewController(videoURL: url)
//        self.present(newVC, animated: true, completion: nil)
    }
    
     //SWIFTY CAM METHOD
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    //SWIFTY CAM METHOD
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
            
        }
        
        tabBarController?.tabBar.isHidden =  false
         secondsCount = 0
        
        lblTimer.text = "00:0\(secondsCount)"
        
        if DidTappedGallary ==  true {

            let vc  = storyboard?.instantiateViewController(withIdentifier: "PlayVideoVC") as! PlayVideoVC
            vc.videoURL = video_url
            self.navigationController?.pushViewController(vc, animated: true)
            DidTappedGallary = false
            
        }
        
       
    }
    
    
    
    
    
    //ONE MINUTE TIMER
    
    func countDownTimet(){
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        startCapture()
    }
    
    
    @objc func update() {
        if(count > 0) {
            if secondsCount<10{
              lblTimer.text = "00:0\(secondsCount)"
            }else{
            lblTimer.text = "00:\(secondsCount)"
            }
            secondsCount = secondsCount + 1
            
            count = count - 1
            print(count)
        }
        else{
            print("TIMERCOUNT")
            print(count)
            timer?.invalidate()
            timer = nil
            stopRecording()
            
        }
    }
    
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialSetup(){
        if setupSession() {
            setupPreview()
            startSession()
            
        }
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview.alignmentRect(forFrame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        //  previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
    }
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.mediaTypes = ["public.movie",kUTTypeMovie as String]
        self.present(picker, animated: true, completion: nil)
    }
    
    
    //MARK: PICKERVIEW DELAGTE
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
     
        
        if (info[UIImagePickerControllerMediaURL] as? URL) != nil {
            
            video_url = (info[UIImagePickerControllerMediaURL] as! URL)
            
            DidTappedGallary =  true
        
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK:- Setup Camera
    
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)
        //let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: camera!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)
        //let microphone = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone!)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    
    func setupCaptureMode(_ mode: Int) {
        // Video Mode
        
    }
    
    //MARK:- Camera Session
    func startSession() {
        
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    func startCapture() {
        
        startRecording()
        
    }
    
    //EDIT 1: I FORGOT THIS AT FIRST
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    
    func startRecording() {
        
        if movieOutput.isRecording == false {
            print("Recording Start")
            
            let connection = movieOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            //EDIT2: And I forgot this
            outputURL = tempURL()
            print("Aman")
            print(outputURL)
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
        }
        else {
            stopRecording()
        }
        
    }
    
    func stopRecording() {
        
        if movieOutput.isRecording == true {
            print("end Recording")
            movieOutput.stopRecording()
            print(outputURL)
            
            timer?.invalidate()
            timer = nil
            
            
            
        }
        
    }
    
    
    @IBAction func btnCameraToggelTapped(_ sender: Any) {
        switchCamera()
    
//            captureSession.beginConfiguration()
//
//            //Remove existing input
//            guard let currentCameraInput: AVCaptureInput = captureSession.inputs.first as? AVCaptureInput else {
//                return
//            }
//
//            captureSession.removeInput(currentCameraInput)
//
//            //Get new input
//            var newCamera: AVCaptureDevice! = nil
//            if let input = currentCameraInput as? AVCaptureDeviceInput {
//                if (input.device.position == .back) {
//                    newCamera = cameraWithPosition(position: .front)
//                } else {
//                    newCamera = cameraWithPosition(position: .back)
//                }
//            }
//
//            //Add input to session
//            var err: NSError?
//            var newVideoInput: AVCaptureDeviceInput!
//            do {
//                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
//            } catch let err1 as NSError {
//                err = err1
//                newVideoInput = nil
//            }
//
//            if newVideoInput == nil || err != nil {
//                print("Error creating capture device input: \(err?.localizedDescription)")
//            } else {
//                captureSession.addInput(newVideoInput)
//            }
//
//
//            captureSession.commitConfiguration()
   
    

        
    }
    
    

   

    //MARK:- DELEGATES OF AVFOUNDATION KIT
    //MARK:
    
//    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
//
//    }
//
//    override func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//
//        if (error != nil) {
//
//            print("Error recording movie: \(error!.localizedDescription)")
//
//        } else {
//
//            let videoRecorded = outputURL! as URL
//            let vc  = storyboard?.instantiateViewController(withIdentifier: "PlayVideoVC") as! PlayVideoVC
//            vc.videoURL = videoRecorded
//            timer?.invalidate()
//            timer =  nil
//            self.navigationController?.pushViewController(vc, animated: true)
//
//
//        }
//    }

    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnRecordTapped(_ sender: Any) {
        
        video_url = nil
    
         if movieOutput.isRecording == false {
          
             countDownTimet()
            
         }else{
            
             stopRecording()
        }
        
    }
    
    @IBAction func btnGallaryTapped(_ sender: Any) {
        
        openGallary()
        
    }
    
}
