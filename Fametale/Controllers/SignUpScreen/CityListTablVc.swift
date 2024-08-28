  //
//  CityListTablVc.swift
//  Travolong
//
//  Created by Callsoft on 20/11/17.
//  Copyright © 2017 callsoft. All rights reserved.
//

import UIKit

protocol selectedCountry{
 
    func countryInformation(info:NSDictionary)

}

  class CityListTablVc: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchResultArray:NSMutableArray = NSMutableArray()
    var country_list_array:NSArray = NSArray()
    var objeCountryListDelegate:selectedCountry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultArray = CommonMethod.appDelegate().countryArray
        country_list_array = CommonMethod.appDelegate().countryArray
        searchBar.delegate = self
        // let tappGest = UITapGestureRecognizer(target: self, action:#selector(tapped(recognizer:)))
        // self.view.addGestureRecognizer(tappGest)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //    @objc func tapped(recognizer: UITapGestureRecognizer) -> Void {
    //
    //        view.endEditing(true)
    //          self.dismiss(animated: true, completion: nil)
    //
    //    }
    
    // MARK:- TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "CountryListCell", bundle: nil), forCellReuseIdentifier: "CountryListCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListCell", for: indexPath) as! CountryListCell
        
        let dict:NSDictionary = searchResultArray[indexPath.row] as! NSDictionary
        let dialCodeString = dict.object(forKey: "country_dailing_code") as? String
        cell.lblCountryCode?.text = dialCodeString
        let code: String = dialCodeString!.trimmingCharacters(in: CharacterSet(charactersIn: "+"))
        let imageName = "flagn"+"_"+"\(code).png"
        cell.imgFlag?.image = UIImage(named: imageName)
        let CounryNameString = dict.object(forKey: "country_name") as? String
        cell.lblCountryName?.text = CounryNameString
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if searchBar.text == "" {
            
            let dict:NSDictionary = country_list_array[indexPath.row] as! NSDictionary
            
            if  objeCountryListDelegate != nil{
                
                objeCountryListDelegate.countryInformation(info: dict)
                
            }
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        else {
            
            let dict:NSDictionary = searchResultArray[indexPath.row] as! NSDictionary
            
            if  objeCountryListDelegate != nil{
                
                objeCountryListDelegate.countryInformation(info: dict as NSDictionary)
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
  }

  extension CityListTablVc:UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // called only once
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // called twice every time
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // called only once
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            
            searchCountry(searchText)
        }
        else {
            
            searchResultArray = country_list_array as! NSMutableArray
            tblView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        
        
    }
    
    
    
    func searchCountry(_ string: String) {
        
        var bobPredicate: NSPredicate?
        var filteredarray:NSArray = NSArray()
        bobPredicate = NSPredicate(format: "country_name beginswith[c] %@", string)
        filteredarray = country_list_array.filter { (bobPredicate?.evaluate(with: $0))! } as! NSArray
        searchResultArray = filteredarray.mutableCopy() as! NSMutableArray
        tblView.reloadData()
        
    }
    
  }

