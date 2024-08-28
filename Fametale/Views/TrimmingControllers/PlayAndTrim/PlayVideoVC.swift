//
//  PlayVideoVC.swift
//  VideoRecordingDemo
//
//  Created by Callsoft on 19/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import PryntTrimmerView



class PlayVideoVC: UIViewController {
    
    // OUTLETS
    
    @IBOutlet weak var trimmerView: TrimmerView!
    @IBOutlet weak var playerView: UIView!
    
    
    // VARIABLES
    
    var avPlayer: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?
    var videoURL: URL!
    var asset:AVAsset?
    
    var VideoData =  Data()
    var videoImage =  UIImage()
    var imagedata =  Data()
    var isHandleMove = false
    var videoDuration = Float()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.black
        trimmerView.positionBarColor = UIColor.white
        
        load1Asset()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden =  true
    }
    
    
    //MARK: METHODS
    
    func load1Asset() {
        
        let url: URL = videoURL
        
        asset = AVAsset(url: url)
        
        print("ASSET")
        print(asset!)
        print("ASSET")
        
        trimmerView.delegate = self
        trimmerView.asset = asset
        
        addVideoPlayer()
        
        findAssetsDuration()
        
    }
    
    
    
    
    func findAssetsDuration(){
        
        let asset = AVAsset(url: videoURL)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        videoDuration = length
    }
    
    func addVideoPlayer() {
        
        let playerItem = AVPlayerItem(asset: asset!)
        avPlayer = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayVideoVC.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: avPlayer)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width + 40, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        playerView.layer.addSublayer(layer)
        
        
        
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        
        if let startTime = trimmerView.startTime {
            
            avPlayer?.seek(to: startTime)
        }
        
    }
    
    func startPlaybackTimeChecker() {
        
        stopPlaybackTimeChecker()
        
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                                        selector:
            #selector(self.onPlaybackTimeChecker), userInfo: nil, repeats: true)
    }
    
    
    
    func stopPlaybackTimeChecker() {
        
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
        
    }
    
    @objc func onPlaybackTimeChecker() {
        
        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = avPlayer else {
            return
        }
        
        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)
        
        if playBackTime >= endTime {
            avPlayer?.seek(to: startTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            trimmerView.seek(to: startTime)
        }
        
    }
    
    
    
    //MARK: ACTIONS
    
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnnextTapped(_ sender: Any) {
        
        
        if videoURL != nil{
        
        if isHandleMove == true{
//            videoURL = nil
//            VideoData.removeAll()
            
              cropVideo(sourceURL: videoURL, startTime: Double((trimmerView.startTime?.seconds)!), endTime: (trimmerView.endTime?.seconds)!)
   
        }else{
//            videoURL = nil
//            VideoData.removeAll()
            isHandleMove = true
            cropVideo(sourceURL: videoURL, startTime: 0.00, endTime: Double(videoDuration), completion: nil)
            
        }
        }else{
            print("kuch nai hai")
        }
    }
    
    
   
    
}


extension PlayVideoVC : TrimmerViewDelegate {
    

    func positionBarStoppedMoving(_ playerTime: CMTime) {
        
        isHandleMove = true
        avPlayer?.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        avPlayer?.play()
        startPlaybackTimeChecker()
    
//        cropVideo(sourceURL: videoURL, startTime: Double((trimmerView.startTime?.seconds)!), endTime: (trimmerView.endTime?.seconds)!)
        
        
    }
    
    
    func didChangePositionBar(_ playerTime: CMTime) {
        
        stopPlaybackTimeChecker()
        avPlayer?.pause()
        avPlayer?.seek(to: playerTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        let duration = (trimmerView.endTime! - trimmerView.startTime!).seconds
        print(duration)
        
    }
    
    func cropVideo(sourceURL: URL, startTime: Double, endTime: Double, completion: ((_ outputUrl: URL) -> Void)? = nil){
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let asset = AVAsset(url: sourceURL)
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        videoDuration = length
        print("video length: \(length) seconds")
        
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(sourceURL.lastPathComponent)")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        try? fileManager.removeItem(at: outputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: 1000),end: CMTime(seconds: endTime, preferredTimescale: 1000))
        
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                print("exported at \(outputURL)")
                
                completion?(outputURL)
                
                do {
                    
                     self.VideoData = try Data(contentsOf: outputURL)
                    print("VIDEO DATA")
                    print(self.VideoData)
                    print("VIDEO DATA")
                    
                } catch {
                    
                    print("Unable to load data: \(error)")
                    
                }
                
      
                self.videoImage = self.fetchFirstFrameOf(videoPath: outputURL)!
                print("VIDEO IMAGE")
             
                
                self.avPlayer?.pause()
                
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPostVC") as! VideoPostVC
                    vc.videoImage = self.videoImage
                    vc.videoData = self.VideoData
                    print(vc.videoImage)
                    
                    vc.videoURL = outputURL

                    self.navigationController?.pushViewController(vc, animated: true)
                }
         

            case .failed:
                print("failed \(exportSession.error.debugDescription)")
            case .cancelled:
                print("cancelled \(exportSession.error.debugDescription)")
            default: break
            }
        }
    }
    
    // MARK: METHODS FOR FINDING FIRST FRAME OF IMAGE
    
    func fetchFirstFrameOf(videoPath urlString: URL) -> UIImage? {
        
        let asset = AVURLAsset(url: urlString)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        if let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) {
            return UIImage(cgImage: imageRef)
        } else {
            return nil
        }
    }
    
    
    
    
}

