//
//  TCTabBarViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit

final class TCTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.tintColor = .label
        delegate = self
        setupTabBar()
    }
    
    private func setupTabBar() {
        let vc1 = TCThreadsViewController(withViewModel: TCThreadsViewViewModel())
        let vc2 = TCSearchViewController()
        let vc3 = TCThreadCreationViewController()
        let vc4 = TCActivitiesViewController()
        let vc5 = TCCurrentProfileViewController()
        
        vc1.title = "Thread"
        vc2.title = "Explore"
        vc3.title = "New Thread"
        vc4.title = "Activity"
//        vc5.title = "Profile"
        
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
//        let nav4 = UINavigationController(rootViewController: vc4)
        let nav5 = UINavigationController(rootViewController: vc5)
        
        nav1.tabBarItem = UITabBarItem(title: "Thread", image: UIImage(systemName: "house"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "plus"), tag: 2)
//        nav4.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "heart"), tag: 3)
        nav5.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        nav2.navigationBar.prefersLargeTitles = true
//        nav4.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3, nav5], animated: true)
    }
    
}

// MARK: - Extension UITabBarControllerDelegate

extension TCTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[2] {
            let nav = UINavigationController(rootViewController: TCThreadCreationViewController())
            present(nav, animated: true)
            return false
        }
        
        return true
    }
    
}
