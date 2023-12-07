//
//  TCActivitiesViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit

final class TCActivitiesViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var allActivitiesVC = TCAllActivitiesViewController()
    private lazy var replyActivitiesVC = TCReplyAcitivitiesViewController()
    
    private lazy var pagerView: TCPagerView = {
        let tabs: [TCPagerTabItemProtocol] = [
            TCActivityTabItemView(title: "All"),
            TCActivityTabItemView(title: "Replies"),
        ]
        let pages: [UIView] = [
            allActivitiesVC.view,
            replyActivitiesVC.view
        ]
        let pagerView = TCPagerView(
            tabSizeConfiguration: .fixed(width: 120, height: 42, spacing: 8)
        )
        allActivitiesVC.didScrollTableView = { [weak self] contentOffset in
            guard let self = self else { return }
            
            let saafeAreaTopHeight = safeAreaTopHeight
            
            if contentOffset.y > 0 && pagerView.contentOffset.y <= 0 {
                pagerView.contentOffset.y += contentOffset.y
            }
            
            if contentOffset.y < 0 {
                pagerView.contentOffset.y = saafeAreaTopHeight * -1
            }
        }
        replyActivitiesVC.didScrollTableView = { [weak self] contentOffset in
            guard let self = self else { return }
            
            let saafeAreaTopHeight = safeAreaTopHeight
            
            if contentOffset.y > 0 && pagerView.contentOffset.y <= 0 {
                pagerView.contentOffset.y += contentOffset.y
            }
            
            if contentOffset.y < 0 {
                pagerView.contentOffset.y = saafeAreaTopHeight * -1
            }
            
        }
        pagerView.tabsView.setTabs(tabs)
        pagerView.pagesView.setPages(pages)
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pagerView
    }()
    
    // MARK: - Private Properties
    
    private lazy var safeAreaTopHeight: CGFloat = {
        return view.safeAreaInsets.top
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addChildren()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(pagerView)
        NSLayoutConstraint.activate([
            pagerView.topAnchor.constraint(equalTo: view.topAnchor),
            pagerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func addChildren() {
        addChild(allActivitiesVC)
        allActivitiesVC.didMove(toParent: self)
        addChild(replyActivitiesVC)
        replyActivitiesVC.didMove(toParent: self)
    }
    
}
