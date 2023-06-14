//
//  UITabBarViewController.swift
//  Unsplash
//
//  Created by Анатолий Фетелеу on 29.03.2023.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureTabBarItems()
    }
    
    private func setup() {
        tabBar.tintColor = .label
        
        view.backgroundColor = .white
    }
    
    private func configureTabBarItems() {
        let gcdRxSwiftVC = GCDRxSwiftViewController()
        let gcdRxSwiftNavigationVC = UINavigationController(rootViewController: gcdRxSwiftVC)
        let gcdRxSwiftTabBarItem = UITabBarItem(
            title: "GCD+RxSwift",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 1
        )
        gcdRxSwiftNavigationVC.navigationBar.prefersLargeTitles = true
        gcdRxSwiftNavigationVC.tabBarItem = gcdRxSwiftTabBarItem
        
        let gcdAlamofireVC = GCDAlamofireViewController()
        let gcdAlamofireNavigationVC = UINavigationController(rootViewController: gcdAlamofireVC)
        let gcdAlamofireTabBarItem = UITabBarItem(
            title: "GCD+Alamofire",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 2
        )
        gcdAlamofireNavigationVC.navigationBar.prefersLargeTitles = true
        gcdAlamofireNavigationVC.tabBarItem = gcdAlamofireTabBarItem
        
        let gcdURLSessionVC = GCDURLSessionViewController()
        let gcdURLSessionNavigationVC = UINavigationController(rootViewController: gcdURLSessionVC)
        let gcdURLSessionTabBarItem = UITabBarItem(
            title: "GCD+URLSession",
            image: UIImage(systemName: "list.dash.header.rectangle"),
            tag: 0
        )
        gcdURLSessionNavigationVC.navigationBar.prefersLargeTitles = true
        gcdURLSessionNavigationVC.tabBarItem = gcdURLSessionTabBarItem
        
        setViewControllers([
            gcdURLSessionNavigationVC,
            gcdAlamofireNavigationVC,
            gcdRxSwiftNavigationVC,
            
        ], animated: false)
    }
}
