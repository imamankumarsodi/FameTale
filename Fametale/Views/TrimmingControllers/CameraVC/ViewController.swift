/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


import UIKit
import SwiftyCam

class ViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    
    var picker = UIImagePickerController()
    var DidTappedGallary =  false
    var video_url:URL?
    var IsStartrecording = false
    var timer:Timer?
    var secondsCount = 0
    var count = 60
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        cameraDelegate = self
        maximumVideoDuration = 60.0
        shouldUseDeviceOrientation = true
        allowAutoRotate = true
        audioEnabled = true
        picker.delegate =  self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        count = 60
        IsStartrecording = false
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
    }
    
    
    @objc func update() {
        if(count > 0) {
            secondsCount = secondsCount + 1
            if secondsCount<10{
                lblTimer.text = "00:0\(secondsCount)"
            }else{
                lblTimer.text = "00:\(secondsCount)"
            }
            
            
            count = count - 1
            print(count)
        }
        else{
            print("TIMERCOUNT")
            print(count)
            timer?.invalidate()
            timer = nil
            stopVideoRecording()
      
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //MARK: SWIFTY CAMERA DELEGATE
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        //let newVC = PhotoViewController(image: photo)
        //self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        
        print("RECORDING KHATAM HO GAYI H")
        let vc  =  storyboard?.instantiateViewController(withIdentifier: "PlayVideoVC") as! PlayVideoVC
        vc.videoURL = url
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFailToRecordVideo error: Error) {
        print(error)
    }
    
    
    
    @IBAction func cameraSwitchTapped(_ sender: Any) {
        
        
        switchCamera()
        
        
    }
    
    @IBAction func galaryTapped(_ sender: Any) {
        
        DidTappedGallary =  true
        
        openGallary()
        
    }
    
    
    
    //MARK: PICKERVIEW DELAGTE
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if (info[UIImagePickerControllerMediaURL] as? URL) != nil {
            
            video_url = (info[UIImagePickerControllerMediaURL] as! URL)
        
           print(video_url)
           print("VIDEO URL")
            
        }
        
        dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.mediaTypes = ["public.movie",kUTTypeMovie as String]
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func btnvideorecordingTapped(_ sender: Any) {
        
        if IsStartrecording ==  false {
            IsStartrecording = true

            countDownTimet()
            startVideoRecording()
            
        }else{
            
            IsStartrecording = false
            timer?.invalidate()
            timer = nil
            
            stopVideoRecording()
            
            
        }
    }
    
    
    
    
    
}

