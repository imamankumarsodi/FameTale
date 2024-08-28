//
//  TrendingVC.swift
//  Fametale
//
//  Created by Callsoft on 11/06/18.
//  Copyright © 2018 Callsoft. All rights reserved.
//

import UIKit

class TrendingVC: UIViewController {
    
    
    
    //MARK:- OUTLETS
    //MARK:
    @IBOutlet weak var viewTopOfDay: UIView!
    @IBOutlet weak var viewTopOfWeek: UIView!
    @IBOutlet weak var viewTopOfMonth: UIView!
    @IBOutlet weak var btntopOfDayRef: UIButton!
    @IBOutlet weak var btntopOfWeekRef: UIButton!
    @IBOutlet weak var btntopOfMonthRef: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK:- VARIABLES
    //MARK:
    let gradient = Gradient.singletonGradientObj
    var _currentPage: NSInteger = 0
    var _page: NSInteger = 0
    var selectedScrollIndex = 0
    var selectedIndex:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animatedScrollSetup()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden =  false
    }
    
    //MARK:- METHODS
    //MARK:
    func animatedScrollSetup(){
        
        self.scrollView.contentSize = CGSize(width: 3*self.view.frame.width,height: self.scrollView.frame.height)
        self.addChildViewController((self.storyboard?.instantiateViewController(withIdentifier: "TopOfDayTableVC"))! as! TopOfDayTableVC)
         self.addChildViewController((self.storyboard?.instantiateViewController(withIdentifier: "TopOfWeekTableVC"))! as! TopOfWeekTableVC)
         self.addChildViewController((self.storyboard?.instantiateViewController(withIdentifier: "TopOfMonthVC"))! as! TopOfMonthVC)

        self.loadScrollView()
        
        
        
    }
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
    
    
    
    
    func loadScrollView ()
    {
        _currentPage=0;
        _page = 0;
        for index in 0 ..< self.childViewControllers.count
        {
            self.loadScrollViewWithPage(index);
        }
    }
    
    
    
    func loadScrollViewWithPage(_ page : Int) -> Void
    {
        if(page < 0)
        {
            return
        }
        if page >= self.childViewControllers.count
        {
            return
        }
        let viewController: UIViewController? = (self.childViewControllers as NSArray).object(at: page) as? UIViewController
        if(viewController == nil)
        {
            return
        }
        if(viewController?.view.superview == nil)
        {
            var frame: CGRect  = self.scrollView.frame
            frame.origin.x = self.view.frame.width*CGFloat(page)
            frame.origin.y = 0;
            viewController?.view.frame = frame;
            self.scrollView.addSubview(viewController!.view);
        }
    }
    
    
    
    //MARK:- ACTIONS
    //MARK:
    
    
    
    @IBAction func btnSearchCategoryTapped(_ sender: Any) {
        if (sender as AnyObject).tag == 1
        {
            changeControlls(btnSeleted:btntopOfDayRef,selectedView:viewTopOfDay)
            updatingTopButtonsUI(btnRef1:btntopOfWeekRef,btnRef2:btntopOfMonthRef,viewRef1:viewTopOfWeek,viewRef2:viewTopOfMonth)
            animateScrollViewHorizontally(destinationPoint: CGPoint(x: 0  * self.view.frame.width, y: 0), andScrollView: self.scrollView, andAnimationMargin: 0);
        }else if(sender as AnyObject).tag == 2{
            changeControlls(btnSeleted:btntopOfWeekRef,selectedView:viewTopOfWeek)
            updatingTopButtonsUI(btnRef1:btntopOfDayRef,btnRef2: btntopOfMonthRef,viewRef1:viewTopOfDay,viewRef2:viewTopOfMonth)
            animateScrollViewHorizontally(destinationPoint: CGPoint(x: 1 * self.view.frame.width, y: 0), andScrollView: self.scrollView, andAnimationMargin: 0);
        }else if(sender as AnyObject).tag == 3{
            changeControlls(btnSeleted:btntopOfMonthRef,selectedView:viewTopOfMonth)
            updatingTopButtonsUI(btnRef1:btntopOfDayRef,btnRef2: btntopOfWeekRef,viewRef1:viewTopOfDay,viewRef2:viewTopOfWeek)
            animateScrollViewHorizontally(destinationPoint: CGPoint(x: 2 * self.view.frame.width, y: 0), andScrollView: self.scrollView, andAnimationMargin: 0);
        }
    }
    
    
    
    
 
    
    @IBAction func btnSearchTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchTopVC") as? SearchTopVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    @IBAction func btnChatTapped(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}
