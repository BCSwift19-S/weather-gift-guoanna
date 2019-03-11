//
//  PageVC.swift
//  WeatherGift
//
//  Created by Anna Guo on 3/10/19.
//  Copyright © 2019 Anna Guo. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class PageVC: UIPageViewController {
    
    var currentPage = 0
    var locationsArray = ["Local City","Sydney, Australia", "Accra, Ghana", "Uglich, Russia"]
    var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurePageControl()
        configureListButton()
    }
    

    func configurePageControl(){
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        let safeHeight = view.frame.height - view.safeAreaInsets.bottom
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth)/2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
    }
    
    // MARK:- UI Configuration Methods
    func configureListButton(){
            
            let safeHeight = view.frame.height - view.safeAreaInsets.bottom
            
            listButton = UIButton(frame: CGRect(x: view.frame.width -
                barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
            
            listButton.setBackgroundImage(UIImage(named: "listbutton"),for: .normal)
            listButton.setBackgroundImage(UIImage(named: "listbutton-highlighted"),for: .highlighted)
            listButton.addTarget(self, action:
                #selector(segueToLocationsListVC), for:
                .touchUpInside)
            view.addSubview(listButton)
    }
    
    @objc func segueToLocationsListVC(){
        print("Hey you clicked me!")
    }
    
    
    //MARK:- Create View Controller for UI
    func createDetailVC(forPage page: Int) -> DetailVC {
        let currentPage = min(max(0, page), locationsArray.count-1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
    }
    
    
}


@available(iOS 11.0, *)
extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count-1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < 0 {
                return createDetailVC(forPage: currentViewController.currentPage)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC {
            pageControl.currentPage = currentViewController.currentPage
        }
    }

    
}
