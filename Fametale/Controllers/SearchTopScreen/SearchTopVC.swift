//
//  SearchTopVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class SearchTopVC: UIViewController,UISearchBarDelegate {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    
    
    @IBOutlet var tblSearch: UITableView!
    @IBOutlet weak var searchBarRef: UISearchBar!
    @IBOutlet weak var viewCategories: UIView!
    @IBOutlet weak var viewTags: UIView!
    @IBOutlet weak var viewTopProfile: UIView!
    @IBOutlet weak var btnCategoriesRef: UIButton!
    @IBOutlet weak var btnTagsRef: UIButton!
    @IBOutlet weak var btnTopProfileRef: UIButton!
    //   @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK:- VARIABLES
    //MARK:
    
    
    //    var _currentPage: NSInteger = 0
    //    var _page: NSInteger = 0
    //    var selectedScrollIndex = 0
    //    var selectedIndex:Int = 1
    var searchActive = false
    let gradient = Gradient.singletonGradientObj
    var tag = 1
    let WebserviceConnection  = AlmofireWrapper()
    
    var profilesArray = NSArray()
    var searchPeopleArray:NSMutableArray = NSMutableArray()
    var peopleResponseArray:NSMutableArray = NSMutableArray()
    
    
    var tagArray = NSArray()
    var searchTagArray:NSMutableArray = NSMutableArray()
    var tagResponseArray:NSMutableArray = NSMutableArray()
    
    
    var categoryArray = NSArray()
    var searchTopicArray:NSMutableArray = NSMutableArray()
    var topicResponseArray:NSMutableArray = NSMutableArray()
    
    
    var filteredArray:NSArray = NSArray()
    var tempsearchfilteredArray:NSMutableArray = NSMutableArray()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarRef.delegate = self
        topProfileAPI()
    }
    
    
    //MARK:- METHODS
    //MARK:
    //    func animatedScrollSetup(){
    //
    //        self.scrollView.contentSize = CGSize(width: 3*self.view.frame.width,height: self.scrollView.frame.height)
    //        self.addChildViewController((self.storyboard?.instantiateViewController(withIdentifier: "TopTableVC"))! as! TopTableVC)
    //        self.addChildViewController((self.storyboard?.instantiateViewController(withIdentifier: "TagTableVC"))! as! TagTableVC)
    //        self.addChildViewController((self.storyboard?.instantiateViewController(withIdentifier: "CategoryTableVC"))! as! CategoryTableVC)
    //        self.loadScrollView()
    //
    //
    //
    //    }
    //TODO:- Updating UI's
    func changeControlls(btnSeleted:UIButton,selectedView:UIView){
        btnSeleted.setTitleColor(UIColor(red: 74.0/255, green: 192.0/255, blue: 194.0/255, alpha: 1.0), for: .normal)
        
        selectedView.backgroundColor = UIColor(red: 74.0/255, green: 192.0/255, blue: 194.0/255, alpha: 1.0)
        
    }
    
    
    func updatingTopButtonsUI(btnRef1:UIButton,btnRef2: UIButton,viewRef1:UIView,viewRef2:UIView){
        //1--------------------------------------//
        btnRef1.setTitleColor(UIColor(red: 154.0/255, green: 154.0/255, blue: 154.0/255, alpha: 1.0), for: .normal)
        viewRef1.backgroundColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
        
        //2--------------------------------------//
        btnRef2.setTitleColor(UIColor(red: 154.0/255, green: 154.0/255, blue: 154.0/255, alpha: 1.0), for: .normal)
        viewRef2.backgroundColor = UIColor(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1.0)
        
        
    }
    
    
    //TODO:- Web services
    
    func topProfileAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("topprofile", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    if self.searchPeopleArray.count > 0{
                        
                        self.searchPeopleArray.removeAllObjects()
                        self.peopleResponseArray.removeAllObjects()
                    }
                    
                    print(responseJson)
                    print("SUCCESS")
                    self.profilesArray = responseJson["data"].arrayObject as? NSArray ?? []
                    
                    for i in 0..<self.profilesArray.count{
                        
                        let dataDict = self.profilesArray.object(at: i) as? NSDictionary ?? [:]
                        let name = dataDict.value(forKey: "name") as? String ?? ""
                        self.searchPeopleArray.add(name)
                    }
                    
                    self.peopleResponseArray = self.profilesArray.mutableCopy() as? NSMutableArray ?? []
                    print(self.profilesArray)
                    print(self.peopleResponseArray)
                    print(self.searchPeopleArray)
                    self.tblSearch.dataSource = self
                    self.tblSearch.delegate = self
                    self.tblSearch.reloadData()
                    
                    
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
    
    func tagAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("toptags", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    if self.searchTagArray.count > 0{
                        
                        self.searchTagArray.removeAllObjects()
                        self.tagResponseArray.removeAllObjects()
                    }
                    self.tagArray = responseJson["data"].arrayObject as? NSArray ?? []
                    

                    for i in 0..<self.tagArray.count{
                        
                        let dataDict = self.tagArray.object(at: i) as? NSDictionary ?? [:]
                        let name = dataDict.value(forKey: "tag_name") as? String ?? ""
                        self.searchTagArray.add(name)
                    }
                    
                    
                    self.tagResponseArray = self.tagArray.mutableCopy() as? NSMutableArray ?? []
                    print(self.tagArray)
                    print(self.tagResponseArray)
                    print(self.searchTagArray)
       
                    self.tblSearch.dataSource = self
                    self.tblSearch.delegate = self
                    self.tblSearch.reloadData()
                    
                    
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
    
    
    func categoryAPI(){
        
        
        
        
        if InternetConnection.internetshared.isConnectedToNetwork() {
            
            Indicator.shared.showProgressView(self.view)
            
            
            
            WebserviceConnection.requestGETURL("topcateg", success: { (responseJson) in
                
                if responseJson["status"].stringValue == "SUCCESS" {
                    
                    Indicator.shared.hideProgressView()
                    
                    if self.searchTopicArray.count > 0{
                        
                        self.searchTopicArray.removeAllObjects()
                        self.topicResponseArray.removeAllObjects()
                    }
                    self.categoryArray = responseJson["data"].arrayObject as? NSArray ?? []
                    print(self.categoryArray)
                    
                    
                    
                    for i in 0..<self.categoryArray.count{
                        
                        let dataDict = self.categoryArray.object(at: i) as? NSDictionary ?? [:]
                        let name = dataDict.value(forKey: "category_name") as? String ?? ""
                        self.searchTopicArray.add(name)
                    }
                    
                    
                    self.topicResponseArray = self.categoryArray.mutableCopy() as? NSMutableArray ?? []
                    print(self.categoryArray)
                    print(self.topicResponseArray)
                    print(self.searchTopicArray)
                    
                    self.tblSearch.dataSource = self
                    self.tblSearch.delegate = self
                    self.tblSearch.reloadData()
                    
                    
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
    
    
    //TODO:- Scroll Animation
    //    func loadScrollView ()
    //    {
    //        _currentPage=0;
    //        _page = 0;
    //        for index in 0 ..< self.childViewControllers.count
    //        {
    //            self.loadScrollViewWithPage(index);
    //        }
    //    }
    //
    //
    //
    //    func loadScrollViewWithPage(_ page : Int) -> Void
    //    {
    //        if(page < 0)
    //        {
    //            return
    //        }
    //        if page >= self.childViewControllers.count
    //        {
    //            return
    //        }
    //        let viewController: UIViewController? = (self.childViewControllers as NSArray).object(at: page) as? UIViewController
    //        if(viewController == nil)
    //        {
    //            return
    //        }
    //        if(viewController?.view.superview == nil)
    //        {
    //            var frame: CGRect  = self.scrollView.frame
    //            frame.origin.x = self.view.frame.width*CGFloat(page)
    //            frame.origin.y = 0;
    //            viewController?.view.frame = frame;
    //            self.scrollView.addSubview(viewController!.view);
    //        }
    //    }
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    @IBAction func btnNavigationTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTopProfileTapped(_ sender: Any) {
        
        tag = (sender as AnyObject).tag
        
        changeControlls(btnSeleted:btnTopProfileRef,selectedView:viewTopProfile)
        updatingTopButtonsUI(btnRef1:btnTagsRef,btnRef2:btnCategoriesRef,viewRef1:viewTags,viewRef2:viewCategories)
        
        topProfileAPI()
        //        animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0  * self.view.frame.width, y: 0), andScrollView: self.scrollView, andAnimationMargin: 0);
    }
    
    
    @IBAction func btnTagsTapped(_ sender: Any) {
        tag = (sender as AnyObject).tag
        
        changeControlls(btnSeleted:btnTagsRef,selectedView:viewTags)
        updatingTopButtonsUI(btnRef1:btnTopProfileRef,btnRef2:btnCategoriesRef,viewRef1:viewTopProfile,viewRef2:viewCategories)
        
        tagAPI()
        //        animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollView, andAnimationMargin: 0);
    }
    
    @IBAction func btnCategoriesTapped(_ sender: Any) {
        tag = (sender as AnyObject).tag
        
        changeControlls(btnSeleted:btnCategoriesRef,selectedView:viewCategories)
        updatingTopButtonsUI(btnRef1:btnTopProfileRef,btnRef2:btnTagsRef,viewRef1:viewTopProfile,viewRef2:viewTags)
        
        categoryAPI()
        //        animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollView, andAnimationMargin: 0);
    }
    
    
    
    
    // MARK: SEARCH BAR DELEGATE METHODS
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if searchBar.text == ""{
            
            searchActive = false
            
            
        }else{
            
            searchActive = true
            
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
        self.searchBarRef.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if tag == 1{
            
            let dummyFilterArray = filteredArray.mutableCopy() as? NSMutableArray ?? []
            
            dummyFilterArray.removeAllObjects()
            
            filteredArray = dummyFilterArray.mutableCopy() as? NSArray ?? []
            
            
            
            filteredArray = (searchPeopleArray.filter({ (text) -> Bool in
                
                let tmp: NSString = text as! NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
                
                
            })  as! NSArray )
            
            
            
            if(filteredArray.count == 0){
                
                searchActive = false
                
            } else {
                
                searchActive = true
                
                
                
            }
            
            
            print(filteredArray)
            
            
            
            tempsearchfilteredArray.removeAllObjects()
            
            print(tempsearchfilteredArray)
            
            
            for i in 0..<self.peopleResponseArray.count {
                
                let temdict = self.peopleResponseArray.object(at: i)as! [String:Any]
                
                let selectedname =  temdict["name"] as? String ?? ""
                
                for j in 0..<self.filteredArray.count{
                    
                    let name = self.filteredArray.object(at: j) as! String
                    
                    if name  ==  selectedname {
                        
                        tempsearchfilteredArray.add(temdict)
                        
                    }else{
                        
                        // Do nothing
                        
                    }
                    
                    
                }
                tblSearch.reloadData()
                
                
            }
            
            if tempsearchfilteredArray.count == 0 && searchBar.text == ""{
                
                searchActive = false
            }else{
                searchActive = true
            }
            tblSearch.reloadData()

            
            
        }else if tag == 2{
            
            let dummyFilterArray = filteredArray.mutableCopy() as? NSMutableArray ?? []
            
            dummyFilterArray.removeAllObjects()
            
            filteredArray = dummyFilterArray.mutableCopy() as? NSArray ?? []
            
            
            
            filteredArray = (searchTagArray.filter({ (text) -> Bool in
                
                let tmp: NSString = text as! NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
                
                
            })  as! NSArray )
            
            
            
            if(filteredArray.count == 0){
                
                searchActive = false
                
            } else {
                
                searchActive = true
                
                
                
            }
            
            
            print(filteredArray)
            
            
            
            tempsearchfilteredArray.removeAllObjects()
            
            print(tempsearchfilteredArray)
            
            
            for i in 0..<self.tagResponseArray.count {
                
                let temdict = self.tagResponseArray.object(at: i)as! [String:Any]
                
                let selectedname =  temdict["tag_name"] as? String ?? ""
                
                for j in 0..<self.filteredArray.count{
                    
                    let name = self.filteredArray.object(at: j) as! String
                    
                    if name  ==  selectedname {
                        
                        tempsearchfilteredArray.add(temdict)
                        
                    }else{
                        
                        // Do nothing
                        
                    }
                    
                    
                }
                tblSearch.reloadData()
                
            }
            if tempsearchfilteredArray.count == 0 && searchBar.text == ""{
                
                searchActive = false
            }else{
                searchActive = true
            }
            tblSearch.reloadData()
        }else if tag == 3{
            
            let dummyFilterArray = filteredArray.mutableCopy() as? NSMutableArray ?? []
            
            dummyFilterArray.removeAllObjects()
            
            filteredArray = dummyFilterArray.mutableCopy() as? NSArray ?? []
            
            
            
            filteredArray = (searchTopicArray.filter({ (text) -> Bool in
                
                let tmp: NSString = text as! NSString
                
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                
                return range.location != NSNotFound
                
                
            })  as! NSArray )
            
            
            
            if(filteredArray.count == 0){
                
                searchActive = false
                
            } else {
                
                searchActive = true
                
                
                
            }
            
            
            print(filteredArray)
            
            
            
            tempsearchfilteredArray.removeAllObjects()
            
            print(tempsearchfilteredArray)
            
            
            for i in 0..<self.topicResponseArray.count {
                
                let temdict = self.topicResponseArray.object(at: i)as! [String:Any]
                
                let selectedname =  temdict["category_name"] as? String ?? ""
                
                for j in 0..<self.filteredArray.count{
                    
                    let name = self.filteredArray.object(at: j) as! String
                    
                    if name  ==  selectedname {
                        
                        tempsearchfilteredArray.add(temdict)
                        
                    }else{
                        
                        // Do nothing
                        
                    }
                    
                    
                }
                tblSearch.reloadData()
                
            }
        }
        
        if tempsearchfilteredArray.count == 0 && searchBar.text == ""{
            
            searchActive = false
        }else{
            searchActive = true
        }
        tblSearch.reloadData()
        
    }
    
    
}




//MARK:- EXTENTION TABLE VIEW
//MARK:

extension SearchTopVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tag == 1{
            
            if searchActive == true{
                
                return tempsearchfilteredArray.count
                
            }else{
                
                 return profilesArray.count
            }
            
           
            
        }
        else if tag == 2{
            
            
            if searchActive == true{
                
                return tempsearchfilteredArray.count
                
            }else{
                
                return tagArray.count
            }
    
            
        }
        else if tag == 3{
            
            if searchActive == true{
                
                return tempsearchfilteredArray.count
                
            }else{
                
                return categoryArray.count
            }
            
        }
            
        else{
            
            return profilesArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var CEll  = UITableViewCell()
        
        if tag == 1{
            
            
            tblSearch.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
            let cell : SearchXibs = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
            
            if searchActive == true{
                
                
                if tempsearchfilteredArray.count != 0{
                    
                    
                    let temDict =  tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                    print(temDict)
                    
                    cell.lblTitle.text = temDict.value(forKey: "name") as? String ?? ""
                    cell.imgSearch.sd_setImage(with: URL(string: temDict.value(forKey: "user_image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    cell.imgSearch.layer.masksToBounds = false
                    cell.imgSearch.clipsToBounds = true
                    cell.lblSubTitle.text = temDict.value(forKey: "username") as? String ?? ""
                }
                
                CEll = cell
                
                
            }else{
                
                if profilesArray.count != 0{
                    
                    
                    let temDict =  profilesArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                    print(temDict)
                    
                    cell.lblTitle.text = temDict.value(forKey: "name") as? String ?? ""
                    cell.imgSearch.sd_setImage(with: URL(string: temDict.value(forKey: "user_image") as? String ?? ""), placeholderImage: UIImage(named: "user_signup"))
                    cell.imgSearch.layer.masksToBounds = false
                    cell.imgSearch.clipsToBounds = true
                    cell.lblSubTitle.text = temDict.value(forKey: "username") as? String ?? ""
                }
                
                CEll = cell
                
                
            }
            
           
            
         
            
        }
        else if tag == 2{
            tblSearch.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
            let cell : SearchXibs = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
            
            
            if searchActive == true{
                
                if tempsearchfilteredArray.count != 0{
                    
                    
                    let temDict =  tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                    print(temDict)
                    
                    cell.lblTitle.text = temDict.value(forKey: "tag_name") as? String ?? ""
                    cell.lblSubTitle.text = "\(temDict.value(forKey: "num_of_post") as? String ?? "") posts"
                    cell.imgSearch.image = #imageLiteral(resourceName: "hash_tag")
                }
                CEll = cell
                
                
            }else{
                
                if tagArray.count != 0{
                    
                    
                    let temDict =  tagArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                    print(temDict)
                    
                    cell.lblTitle.text = temDict.value(forKey: "tag_name") as? String ?? ""
                    cell.lblSubTitle.text = "\(temDict.value(forKey: "num_of_post") as? String ?? "") posts"
                    cell.imgSearch.image = #imageLiteral(resourceName: "hash_tag")
                }
                CEll = cell
                
            }
            
            
           
            
        }
            
        else if tag == 3{
            self.tblSearch.register(UINib(nibName:"SearchXibs",bundle:nil), forCellReuseIdentifier: "SearchXibs")
            let cell : SearchXibs = tblSearch.dequeueReusableCell(withIdentifier: "SearchXibs", for: indexPath) as! SearchXibs
            
            
            if searchActive == true{
                
                if tempsearchfilteredArray.count != 0{
                    
                    
                    let temDict =  tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                    print(temDict)
                    
                    cell.lblTitle.text = temDict.value(forKey: "category_name") as? String ?? ""
                    cell.lblSubTitle.text = "\(temDict.value(forKey: "num_of_post") as? String ?? "") posts"
                    //                cell.imgSearch.sd_setImage(with: URL(string: temDict.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: ""))
                    
                }
                
                CEll = cell
                
            }else{
                
                if categoryArray.count != 0{
                    
                    
                    let temDict =  categoryArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                    print(temDict)
                    
                    cell.lblTitle.text = temDict.value(forKey: "category_name") as? String ?? ""
                    cell.lblSubTitle.text = "\(temDict.value(forKey: "num_of_post") as? String ?? "") posts"
                    //                cell.imgSearch.sd_setImage(with: URL(string: temDict.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage(named: ""))
                    
                }
                
                CEll = cell
                
            }
            
            
           
            
        }
        
        
        
        return CEll
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tag == 1{
            
            var otherUserID = ""
            
            if searchActive == true{
                
                let temDict =  tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                print(temDict)
                
                otherUserID = temDict.value(forKey: "user_id") as? String ?? ""
                
            }else{
                let temDict =  profilesArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                print(temDict)
                
                otherUserID = temDict.value(forKey: "user_id") as? String ?? ""
               
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherProfileVC") as! OtherProfileVC
            
            vc.userID = otherUserID
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if tag == 2{
            
            var tag_id = ""
            
            if searchActive == true{
                
                let temDict =  tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                print(temDict)
                
                tag_id = temDict.value(forKey: "tag_id") as? String ?? ""
                
            }else{
                let temDict =  tagArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                print(temDict)
                
                tag_id = temDict.value(forKey: "tag_id") as? String ?? ""
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home1VC") as! Home1VC
            
            vc.id = tag_id
            vc.apiName = "tagpostbyid"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            
             var category_id = ""
            
            if searchActive == true{
                
                let temDict =  tempsearchfilteredArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                print(temDict)
                
                category_id = temDict.value(forKey: "category_id") as? String ?? ""
                
            }else{
                
                let temDict =  categoryArray.object(at: indexPath.row) as? NSDictionary  ?? ["":""]
                print(temDict)
                
                category_id = temDict.value(forKey: "category_id") as? String ?? ""
            }
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home1VC") as! Home1VC
            vc.id = category_id
            vc.apiName = "catgpostbyid"
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
        
    }
    
}




