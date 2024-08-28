//
//  Home1VC.swift
//  Fametale
//
//  Created by Callsoft on 09/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class Home1VC: UIViewController {
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var tblVideos: UITableView!
    
    //MARK:- VARIABLES
    //MARK:
    let gradient = Gradient.singletonGradientObj
    let WebserviceConnection = AlmofireWrapper()
    var videoId = ""
    var userID = ""
    var index = Int()
    var videoDataModelArray = [VideoDataModel]()
    var apiName = ""
    var id = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        
        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        userID =  temdict?.value(forKey: "user_id") as? String ?? ""
        
        self.tblVideos.register(UINib(nibName:"VideosCell",bundle:nil), forCellReuseIdentifier: "VideosCell")
        postsAcordingToTagsOrCategories(apiName:apiName,id:id)
    }
    
    // TODO : Web services implementations
    
    func postsAcordingToTagsOrCategories(apiName:String,id:String){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("\(self.apiName)/\(id)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    
                    if self.videoDataModelArray.count > 0{
                        
                        self.videoDataModelArray.removeAll()
                        
                    }
                    
                    print(responseJson)
                    
                    let  dataArray =  responseJson["data"].arrayObject as? NSArray ?? []
                    for index in 0..<dataArray.count{
                        
                        let dataDict = dataArray.object(at: index) as? NSDictionary ?? [:]
                        
                        let view_count = dataDict.value(forKey: "view_count") as? String ?? ""
                        let name = dataDict.value(forKey: "name") as? String ?? ""
                        let avg_rating = dataDict.value(forKey: "avg_rating") as? String ?? ""
                        let image = dataDict.value(forKey: "image") as? String ?? ""
                        let thumbnail = dataDict.value(forKey: "thumbnail") as? String ?? ""
                        let description = dataDict.value(forKey: "description") as? String ?? ""
                        let userId = dataDict.value(forKey: "userId") as? String ?? ""
                        let videoId = dataDict.value(forKey: "videoId") as? String ?? ""
                        let username = dataDict.value(forKey: "username") as? String ?? ""
                        let video_name = dataDict.value(forKey: "video_name") as? String ?? ""
                        let created_at = dataDict.value(forKey: "created_at") as? String ?? ""
                        
                        let videoDataModelItem = VideoDataModel(view_count: view_count, name: name, avg_rating: avg_rating, image: image, thumbnail: thumbnail, description: description, userId: userId, videoId: videoId, username: username, video_name: video_name, created_at: created_at)
                        
                        self.videoDataModelArray.append(videoDataModelItem)
                        
                    }
                    
                    self.tblVideos.dataSource = self
                    self.tblVideos.delegate = self
                    self.tblVideos.reloadData()
                    
                    
                    
                    
                    print("SUCCESS")
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("Failure")
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
                }
                
                
            },failure: { (Error) in
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    func viewCountAPI(){
        
        
        videoId = videoDataModelArray[index].videoId ?? ""
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            WebserviceConnection.requestGETURL("view_count/\(videoId)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    
                    
                    if self.videoDataModelArray.count != 0{
                        let videoUrl = self.videoDataModelArray[self.index].video_name ?? ""
                        
                        print(videoUrl)
                        
                        let view_count = Int(self.videoDataModelArray[self.index].view_count ?? "0")
                        
                        let indexPath = IndexPath(row: self.index, section: 0)
                        
                        guard let cell = self.tblVideos.cellForRow(at: indexPath) as? VideosCell else {
                            
                            return
                        }
                        
                        
                        
                        cell.lblViewCounts.text = "\(view_count! + 1)"
                        
                        self.videoDataModelArray[self.index].view_count = "\(view_count! + 1)"
                        
                        self.tblVideos.reloadRows(at: [indexPath], with: .none )
                        
                        let avPlayerViewController = AVPlayerViewController()
                        var avPlayer:AVPlayer? = nil
                        let url = URL(string: videoUrl)
                        avPlayer = AVPlayer.init(url: url!)
                        avPlayerViewController.player = avPlayer
                        print("downloadUrl obtained and set")
                        self.present(avPlayerViewController, animated: true) { () -> Void in
                            avPlayerViewController.player?.play()
                        }
                        
                        
                    }
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("Failure")
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong!", style: AlertStyle.error)
                    
                }
                
                
            },failure: { (Error) in
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                Indicator.shared.hideProgressView()
                
                
            })
            
            
        }else{
            
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            Indicator.shared.hideProgressView()
            
        }
        
        
        
    }
    
    
    
    
    //MARK:- Actions
    //MARK:
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func buttonRateVideoPressed(_ sender: AnyObject) {
        
        videoId = videoDataModelArray[sender.tag!].videoId ?? ""
        let nameUser = videoDataModelArray[sender.tag!].name ?? ""
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "VideoRateAndCommnetVC") as! VideoRateAndCommnetVC
        vc.videoId = videoId
        vc.name = nameUser
        self.present(vc, animated: true, completion: nil)
    }
    @objc func buttonCommentPressed(_ sender: AnyObject) {
        videoId = videoDataModelArray[sender.tag!].videoId ?? ""
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.videoId = videoId
        self.present(vc, animated: true, completion: nil)
    }
    @objc func buttonSharePressed(_ sender: AnyObject) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ShareScreenVC") as! ShareScreenVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func btnOtherProfileTapped(_ sender: AnyObject) {
        
        
        let otherUserID = videoDataModelArray[sender.tag!].userId ?? ""
        
        if userID != otherUserID{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
            vc.userID = otherUserID
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
    
    
    
}
//MARK:- EXTENTION OF CLASS
//MARK:
extension Home1VC:UITableViewDelegate,UITableViewDataSource{
    
    
    //TODO:-TABLEVIEW DELEGATES
    //TODO:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return videoDataModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : VideosCell = tblVideos.dequeueReusableCell(withIdentifier: "VideosCell", for: indexPath) as! VideosCell
        
        if videoDataModelArray.count != 0{
            
            cell.lbltime.text = videoDataModelArray[indexPath.row].created_at ?? ""
            cell.lblName.text = videoDataModelArray[indexPath.row].name ?? ""
            cell.lblUserName.text = videoDataModelArray[indexPath.row].username ?? ""
            cell.lblViewCounts.text = "\(videoDataModelArray[indexPath.row].view_count ?? "") views"
            cell.imgViewProfilePic.sd_setImage(with: URL(string: videoDataModelArray[indexPath.row].image ?? ""), placeholderImage: UIImage(named: "user_signup"))
            cell.imgViewProfilePic.layer.masksToBounds = false
            cell.imgViewProfilePic.clipsToBounds = true
            cell.lblVideoDescription.text = videoDataModelArray[indexPath.row].description ?? ""
            cell.viewRating.rating = Float(videoDataModelArray[indexPath.row].avg_rating ?? "0") ?? 0.0
            cell.lblAvgRatings.text = videoDataModelArray[indexPath.row].avg_rating ?? "0"
            cell.imgVideo.sd_setImage(with: URL(string: videoDataModelArray[indexPath.row].thumbnail ?? ""), placeholderImage: UIImage(named: ""))
            
            cell.btnOtherProfileTapped.tag = indexPath.row
            cell.btnOtherProfileTapped.addTarget(self, action:#selector(btnOtherProfileTapped(_:)), for:.touchUpInside)
            cell.btnRatingRef.tag = indexPath.row
            cell.btnRatingRef.addTarget(self, action:#selector(buttonRateVideoPressed(_:)), for:.touchUpInside)
            
            cell.btnCommentRef.tag = indexPath.row
            cell.btnCommentRef.addTarget(self, action:#selector(buttonCommentPressed(_:)), for:.touchUpInside)
            
            
        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        viewCountAPI()
        
        
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
