//
//  ProfileVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation
import Contacts
import ContactsUI
import FBSDKCoreKit
import FBSDKLoginKit



class ProfileVC: UIViewController {
    
    //MARK:- OUTLETS
    //MARK:
    
    @IBOutlet weak var lblFollowers: UILabel!
    
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblFameTaleUser: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tblVideos: UITableView!
    
    @IBOutlet weak var lblVideoCounts: UILabel!
    @IBOutlet weak var lblBio: UILabel!
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
    var contacts = [CNContact]()
    var contactStore = CNContactStore()
    
    var isComingfromComment =  false
    var contactArray = [String]()
    var nameArray = [String]()
    var stringArray1 = ""
    var stringArray2 = ""
    var isComing = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
        
        ScreeNNameClass.shareScreenInstance.screenName = "ProfileVC"
        NotificationCenter.default.addObserver(self,selector:#selector(ProfileVC.reloadHomeApi(_:)),name:NSNotification.Name(rawValue: "PROFILENOTIFYRELOAD"),object: nil)
        viewUserProfile()

        let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(TemArray!)
        
        let temdict  =  TemArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        print("USERID AAGAYAI ")
        
        imgUserProfile.layer.masksToBounds = false
        imgUserProfile.clipsToBounds = true
        
        
        self.tblVideos.register(UINib(nibName:"VideosCell",bundle:nil), forCellReuseIdentifier: "VideosCell")
        
        if isComingfromComment ==  true {
            
        }
        
        
        
    }
    
    func getContacts(){
        
        
        var contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch:[CNKeyDescriptor] = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                    print(results)
                    
                    for contact in results {
                        
                        var number: CNPhoneNumber!
                        if contact.phoneNumbers.count > 0 {
                            
                            //(contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
                            number = contact.phoneNumbers[0].value as! CNPhoneNumber
                            let numberString = number?.stringValue
                            let nameString = contact.givenName + " " + contact.familyName
                            self.contactArray.append(numberString!)
                            self.nameArray.append(nameString)
                            
                            
                            
                        }
                    }
                    
                    
                    
                    
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        
        
        
        stringArray1 = nameArray.flatMap{ $0 }.joined(separator: ",")
        stringArray2 = contactArray.flatMap{ $0 }.joined(separator: ",")
        print(stringArray1)
        print(stringArray2)
        
        getContactList()
    }
    
    
    //MARK:- WEB SERVICES
    //MARK:
    
    
    
    
    func getContactList(){
        
        
        print(stringArray2)
        
        let Passdict = ["namelist": stringArray1,"contactlist": stringArray2] as [String : Any]
        
        print(Passdict)
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            WebserviceConnection.requestPOSTURL("contactlist", params: Passdict as [String : AnyObject], headers:nil, success: { (responseJson) in
                
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    print(responseJson)
                    let contactArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyContactsVC") as! MyContactsVC
                  
                    vc.contacArray = contactArray as! [Any]
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                    
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
    
    
    
    
    
    func viewUserProfile(){
        
        
        let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        print(temArray!)
        
        let temdict  =  temArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        nameUser = temdict?.value(forKey: "name") as? String ?? ""
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("users/\(userID!)/\(userID!)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    let  userDict =  responseJson["data"].dictionary ?? [:]
                    self.nameUser = userDict["name"]?.string ?? ""
                    self.imageUser = userDict["image"]?.string ?? ""
                    self.avg_ratingUser = userDict["avg_rating"]?.string ?? ""
                    print(self.avg_ratingUser)
                    let image = userDict["image"]?.string ?? ""
//                    self.lblVideoCounts.text = "\(userDict["list_video_count"]?.string ?? "") Videos"
//                    self.lblWowCounts.text = "\(userDict["wow_video_count"]?.string ?? "") Wow"
                    self.lblUserName.text = userDict["name"]?.string ?? ""
                    self.lblFameTaleUser.text = userDict["username"]?.string ?? ""
                    self.lblDateOfBirth.text = userDict["dob"]?.string ?? ""
                    self.lblFollowers.text = "\(userDict["followers"]?.string ?? "") Followers"
                    self.lblFollowing.text = "\(userDict["following"]?.string ?? "") Following"
                    self.lblBio.text = userDict["bio"]?.string ?? ""
                    self.imgUserProfile.sd_setImage(with: URL(string: image as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
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
        
        
        let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        
        let temdict  =  temArray?.object(at: 0) as? NSDictionary
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
//            self.viewWow.backgroundColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 161.0/255.0, alpha: 1.0)
//            self.viewVideos.backgroundColor = .white
            
            WebserviceConnection.requestGETURL("wowVideo/\(userID!)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    
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
        
        
        let temArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
        
        
        let temdict  =  temArray?.object(at: 0) as? NSDictionary
        print(temdict!)
        
        let userID =  temdict?.value(forKey: "user_id") as? String
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
//            self.viewWow.backgroundColor = .white
//            self.viewVideos.backgroundColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 161.0/255.0, alpha: 1.0)
            
            WebserviceConnection.requestGETURL("videolistbyuser/\(userID!)", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    print(responseJson)
                    
                    print("WOW SUCCESS")
                    
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
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            
            
            let selctedIndex = UserDefaults.standard.value(forKey: "SelectedIndexPath") as? IndexPath
            
            let indexPath = IndexPath(row: (selctedIndex?.row)!, section: 0)
            
            self.tblVideos.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
        }
        
    }
    
    
    
    //MARK:- TABLE BUTTON ACTIONS
    //MARK:
    
    
    
    
    
    
    
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
    //MARK:- ACTIONS
    //MARK:
    
    
    @objc func reloadHomeApi(_ notification: Notification){
        tagIndex = 2
        userVideoListing()
    }

    @IBAction func btnFollowerFollowingList(_ sender: UIButton) {
        
        if sender.tag == 1{
            print("btn1 print hua")
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewMessageVC") as? NewMessageVC
            vc?.isComing = "FOLLOWER"
            let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
            print(TemArray!)
            let temdict  =  TemArray?.object(at: 0) as? NSDictionary
            print(temdict!)
            userID =  temdict?.value(forKey: "user_id") as? String ?? ""
            print(userID)
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewMessageVC") as? NewMessageVC
            vc?.isComing = "FOLLOWING"
            let TemArray  = UserDefaults.standard.value(forKey: "USERINFO") as? NSArray
            print(TemArray!)
            let temdict  =  TemArray?.object(at: 0) as? NSDictionary
            print(temdict!)
            userID =  temdict?.value(forKey: "user_id") as? String ?? ""
            print(userID)
            vc?.userID = userID
            self.navigationController?.pushViewController(vc!, animated: true)
        }
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

        }else{
            
            showFriends()
            
//            var fbRequestFriends: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/{friend-list-id}", parameters: [AnyHashable : Any]())
//            
//            fbRequestFriends.start { (connection, result, error) in
//                if error == nil && result != nil {
//                    print("Request Friends result : \(result!)")
//                } else {
//                    print("Error \(error)")
//                }
//            }
            
//            getContacts()
            
        }
        
        
    }
    
    
    
    
    
    
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        if isComing == "NOTI"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }else{
           self.navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func btnContactsTappd(_ sender: Any) {
        
        
        
        // permissionsForContact()
        //        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchTopVC") as? SearchTopVC
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnEditProfileTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    //MARK:- CONTACT PICKER DELEGATE
    //MARK:-
    func showFriends(){
        
        let parameters = ["fields":"name,picture,type(normal),gender"]
        FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: parameters).start { (connection, user, request_error) in
            if request_error != nil{
                print("Error hai: \(request_error!)")
            }else{
                
                print(user)
            }
        }
        
    }
    
    func permissionsForContact(){
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        
                        let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                        let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                            
                            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
                            let request = CNContactFetchRequest(keysToFetch: keys)
                            
                            do {
                                try self.contactStore.enumerateContacts(with: request) {
                                    (contact, stop) in
                                    // Array containing all unified contacts from everywhere
                                    self.contacts.append(contact)
                                    print("Aman")
                                    let number = (contact.phoneNumbers[0].value as! CNPhoneNumber).value(forKey: "digits") as! String
                                    print("*************")
                                    print(number)
                                    print("*************")
                                    
                                    print(contact)
                                }
                                
                            }
                            catch {
                                print("unable to fetch contacts")
                            }
                            
                            
                        }
                        
                        alertController.addAction(dismissAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
            break
        default:
            
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            do {
                try self.contactStore.enumerateContacts(with: request) {
                    (contact, stop) in
                    // Array containing all unified contacts from everywhere
                    self.contacts.append(contact)
                    print("Aman")
                    
                    
                    print("*************")
                    
                    print("*************")
                    print(contact)
                }
                
            }
            catch {
                print("unable to fetch contacts")
            }
            
            
            //            let contactPicker = CNContactPickerViewController()
            //            contactPicker.delegate = self
            //            self.present(contactPicker, animated: true, completion: nil)
            
            break
        }
        
    }
    
}


extension ProfileVC:CNContactPickerDelegate{
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try self.contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                let number = (contact.phoneNumbers[0].value ).value(forKey: "digits") as? String ?? ""
                print(contact)
                self.contacts.append(contact)
                print("Aman")
                //print(self.contacts)
            }
            
        }
        catch {
            print("unable to fetch contacts")
        }
        
        print(contact)
        let name = contact.givenName + " " + contact.familyName
        let number = (contact.phoneNumbers[0].value ).value(forKey: "digits") as? String ?? ""
        let messaage =  "\(name) \n\(number)"
        
        
    }
}



//MARK:- EXTENTION OF CLASS
//MARK:
extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    
    
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
                
                cell.btnOtherProfileTapped.tag = indexPath.row
                cell.btnOtherProfileTapped.addTarget(self, action:#selector(btnOtherProfileTapped(_:)), for:.touchUpInside)
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
                
                cell.btnOtherProfileTapped.tag = indexPath.row
                cell.btnOtherProfileTapped.addTarget(self, action:#selector(btnOtherProfileTapped(_:)), for:.touchUpInside)
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
    
}

