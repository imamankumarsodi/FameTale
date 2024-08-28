//
//  OtherProfileVC.swift
//  Fametale
//
//  Created by Callsoft on 12/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

class OtherProfileVC: UIViewController {
    
    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var lblFollowing: UILabel!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var tblVideos: UITableView!
    
    @IBOutlet weak var lblVideoCounts: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var btnFollowRef: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewWow: UIView!
    @IBOutlet weak var viewVideos: UIView!
    @IBOutlet weak var lblWowCounts: UILabel!
    
    //MARK:- VARIABLES
    //MARK:
    
    
    var userID = ""
    var tagIndex:Int = 2
    var nameUser = ""
    var imageUser = ""
    var avg_ratingUser = ""
    let WebserviceConnection  = AlmofireWrapper()
    var videoDataModelArray = [VideoDataModel]()
    var videoId = ""
    var index = Int()
    var otherUserID = ""
    let gradient = Gradient.singletonGradientObj
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
    
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialMethod()
    }
    
    //MARK:- USER DEFINED METHODS
    //MARK:
    func initialMethod(){
        viewUserProfile()
        userVideoListing()
        imgUserProfile.layer.masksToBounds = false
        imgUserProfile.clipsToBounds = true
        
        self.tblVideos.register(UINib(nibName:"VideosCell",bundle:nil), forCellReuseIdentifier: "VideosCell")
        tblVideos.dataSource = self
        tblVideos.delegate = self
        tblVideos.reloadData()
    }
    
    
    
    
    
    
    func viewUserProfile(){
        
        
        let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(temArray!)
        
        let temdict  =  temArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        nameUser = temdict?.value(forKey: "name") as? String ?? ""
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("users/\(self.userID)/\(userID!)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    let  userDict =  responseJson["data"].dictionary ?? [:]
                    
                    
                    let follow_flag = userDict["follow_flag"]?.string ?? ""
                    
                    if follow_flag == "0"{
                        
                        let btnFollowGradient = self.gradient.createBlueGreenGradient(from: self.btnFollowRef.bounds)
                        self.btnFollowRef.layer.insertSublayer(btnFollowGradient, at: 0)
                        self.btnFollowRef.layer.cornerRadius = self.btnFollowRef.frame.size.height/2
                        self.btnFollowRef.layer.masksToBounds = true
                        self.btnFollowRef.setTitleColor(.white, for: .normal)
                        self.btnFollowRef.setTitle("Follow", for: .normal)
                        
                    }else{
                        
                        
                        self.btnFollowRef.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
                        self.btnFollowRef.setTitleColor(.black, for: .normal)
                        self.btnFollowRef.setTitle("Following", for: .normal)
                        
                    }
                    
                    self.nameUser = userDict["name"]?.string ?? ""
                    self.imageUser = userDict["image"]?.string ?? ""
                    self.avg_ratingUser = userDict["avg_rating"]?.string ?? ""
                    print(self.avg_ratingUser)
                    let image = userDict["image"]?.string ?? ""
                    self.lblUserName.text = userDict["username"]?.string ?? ""
                    self.lblHeader.text = userDict["name"]?.string ?? ""
                    self.lblDateOfBirth.text = userDict["dob"]?.string ?? ""
                    self.lblFollowers.text = "\(userDict["followers"]?.string ?? "") Followers"
                    self.lblFollowing.text = "\(userDict["following"]?.string ?? "") Following"
                    self.lblBio.text = userDict["bio"]?.string ?? ""
                    self.imgUserProfile.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    //                    self.lblVideoCounts.text = "\(userDict["list_video_count"]?.string ?? "") Videos"
                    //                    self.lblWowCounts.text = "\(userDict["wow_video_count"]?.string ?? "") Wow"
                    self.userVideoListing()
                    
                    
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
    
    
    
    func wowVideosAPI(){
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("wowVideo/\(self.userID)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    //                    self.viewWow.backgroundColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                    //                    self.viewVideos.backgroundColor = .white
                    
                    if self.videoDataModelArray.count > 0{
                        
                        self.videoDataModelArray.removeAll()
                        
                    }
                    
                    
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
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
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
    
    
    
    func userVideoListing(){
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("videolistbyuser/\(self.userID)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    print("WOW SUCCESS")
                    
                    //                    self.viewWow.backgroundColor = .white
                    //                    self.viewVideos.backgroundColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                    
                    let videoArray = responseJson["data"].arrayObject as? NSArray ?? []
                    let videoCount = videoArray.count as? Int ?? 0
                    self.lblVideoCounts.text = "\(videoCount) Videos"
                    
                    if self.videoDataModelArray.count > 0{
                        
                        self.videoDataModelArray.removeAll()
                        
                    }
                    
                    
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
                    
                    
                    
                }else{
                    
                    print(responseJson)
                    Indicator.shared.hideProgressView()
                    
                    print("WOW Failure")
                    
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
    
    
    
    func followUnfollowAPI(){
        
        let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray ?? []
        print(temArray)
        
        let temdict  =  temArray.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String ?? ""
        let token =  temdict?.value(forKey: "token") as? String ?? ""
        
        
        let Passdict = ["follower_id": userID,"user_id": self.userID,"token":token] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("follow", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    if self.btnFollowRef.titleLabel?.text == "Following"{
                        
                        let btnFollowGradient = self.gradient.createBlueGreenGradient(from: self.btnFollowRef.bounds)
                        self.btnFollowRef.layer.insertSublayer(btnFollowGradient, at: 0)
                        self.btnFollowRef.layer.cornerRadius = self.btnFollowRef.frame.size.height/2
                        self.btnFollowRef.layer.masksToBounds = true
                        self.btnFollowRef.setTitleColor(.white, for: .normal)
                        self.btnFollowRef.setTitle("Follow", for: .normal)
                        
                    }else if self.btnFollowRef.titleLabel?.text == "Follow"{
                        
                        
                        self.btnFollowRef.layer.sublayers?.remove(at: 0)
                        self.btnFollowRef.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
                        self.btnFollowRef.setTitleColor(.black, for: .normal)
                        self.btnFollowRef.setTitle("Following", for: .normal)
                        
                    }
                    
                    
                    let message  = responseJson["message"].stringValue
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.success)
                    
                    
                }else{
                    
                    Indicator.shared.hideProgressView()
                    
                    let message  = responseJson["message"].stringValue
                    
                    _ = SweetAlert().showAlert("FameTale", subTitle: message, style: AlertStyle.error)
                    
                    
                }
                
                
            },failure: { (Error) in
                
                Indicator.shared.hideProgressView()
                
                _ = SweetAlert().showAlert("FameTale", subTitle: "Something went wrong.Please try again!", style: AlertStyle.error)
                
                
            })
            
            
        }else{
            Indicator.shared.hideProgressView()
            _ = SweetAlert().showAlert("FameTale", subTitle: "No interter connection!", style: AlertStyle.error)
            
            
        }
        
        
        
    }
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnFollowerFollowingList(_ sender: UIButton) {
        
        if sender.tag == 1{
            print("btn1 print hua")
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewMessageVC") as? NewMessageVC
            vc?.isComing = "FOLLOWER"
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewMessageVC") as? NewMessageVC
            vc?.isComing = "FOLLOWING"
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    
    @IBAction func btnFollowTapped(_ sender: UIButton) {
        self.followUnfollowAPI()
        
    }
    
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRateProfileTapped(_ sender: Any) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ProfileRatingVC") as! ProfileRatingVC
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnTblHeaderChoiceTapped(_ sender: UIButton) {
        
        tagIndex = sender.tag
        
        if sender.tag == 1{
            
            wowVideosAPI()
            
        }else if sender.tag == 2{
            
            userVideoListing()
            
        }else if sender.tag == 3{
            
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ProfileRatingVC") as! ProfileRatingVC
            vc.userName = self.nameUser
            vc.imgUser = self.imageUser
            vc.ratingNumber = self.avg_ratingUser
            self.present(vc, animated: true, completion: nil)
            
        }
        
        
    }
    
    
}







//MARK:- EXTENTION OF CLASS
//MARK:
extension OtherProfileVC:UITableViewDelegate,UITableViewDataSource{
    
    
    //TODO:-TABLEVIEW DELEGATES
    //TODO:
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videoDataModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tagIndex == 1{
            
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
                
                //                cell.btnOtherProfileTapped.tag = indexPath.row
                //                cell.btnOtherProfileTapped.addTarget(self, action:#selector(btnOtherProfileTapped(_:)), for:.touchUpInside)
                cell.btnRatingRef.tag = indexPath.row
                cell.btnRatingRef.addTarget(self, action:#selector(buttonRateVideoPressed(_:)), for:.touchUpInside)
                
                cell.btnCommentRef.tag = indexPath.row
                cell.btnCommentRef.addTarget(self, action:#selector(buttonCommentPressed(_:)), for:.touchUpInside)
                
                returnCell = cell
            }
            
            
        }else if tagIndex == 2{
            
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
                
                //                cell.btnOtherProfileTapped.tag = indexPath.row
                //                cell.btnOtherProfileTapped.addTarget(self, action:#selector(btnOtherProfileTapped(_:)), for:.touchUpInside)
                cell.btnRatingRef.tag = indexPath.row
                cell.btnRatingRef.addTarget(self, action:#selector(buttonRateVideoPressed(_:)), for:.touchUpInside)
                
                cell.btnCommentRef.tag = indexPath.row
                cell.btnCommentRef.addTarget(self, action:#selector(buttonCommentPressed(_:)), for:.touchUpInside)
                
                returnCell = cell
            }
            
            
        }
        
        return returnCell
        
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
    
    
    
    
    //MARK:- TABLE BUTTON ACTIONS
    //MARK:
    
    
    
    
    
    
    
    @objc func buttonRateVideoPressed(_ sender: AnyObject) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "VideoRateAndCommnetVC") as! VideoRateAndCommnetVC
        vc.videoId = videoId
        vc.name = nameUser
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func buttonCommentPressed(_ sender: AnyObject) {
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.videoId = videoId
        
        let selctedindex =  sender.tag
        
        //let indexPath = IndexPath(row: selctedindex!, section: 0)
        
        UserDefaults.standard.set(selctedindex!, forKey: "SelectedIndexPath")
        
        print(UserDefaults.standard.value(forKey: "SelectedIndexPath"))
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func buttonSharePressed(_ sender: AnyObject) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ShareScreenVC") as! ShareScreenVC
        self.present(vc, animated: true, completion: nil)
    }
    
}

