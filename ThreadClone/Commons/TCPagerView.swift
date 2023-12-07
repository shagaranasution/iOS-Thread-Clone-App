//
//  TCPagerView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 23/10/23.
//

import UIKit

final class TCPagerView: UIView {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public var headerView: UIView?
    
    public lazy var tabsView: TCPagerTabsView = {
        let tabsView = TCPagerTabsView(
            sizeConfiguration: sizeConfiguration
        )
        
        return tabsView
    }()
    
    public lazy var pagesView = TCPagerPagesView()
    
    // MARK: - Public Properties
    
    public let sizeConfiguration: TCPagerTabsView.SizeConfiguration
    
    public var contentOffset: CGPoint {
        get {
            return scrollView.contentOffset
        }
        set(newContentOffset) {
            scrollView.contentOffset = newContentOffset
        }
    }
    
    // MARK: - Initialization
    
    init(
        headerView: UIView? = nil,
        tabSizeConfiguration: TCPagerTabsView.SizeConfiguration
    ) {
        self.headerView = headerView
        self.sizeConfiguration = tabSizeConfiguration
        super.init(frame: .zero)
        setupViews()
        tabsView.delegate = self
        pagesView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        scrollView.addSubview(contentView)
        let contentViewHeightConstraint: NSLayoutConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor)
        contentViewHeightConstraint.isActive = true
        contentViewHeightConstraint.priority = UILayoutPriority(50)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        if let headerView = headerView {
            contentView.addSubviews(headerView, tabsView, pagesView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                tabsView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                tabsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                tabsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                tabsView.heightAnchor.constraint(equalToConstant: sizeConfiguration.height),
                
                pagesView.topAnchor.constraint(equalTo: tabsView.bottomAnchor, constant: 8),
                pagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                pagesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                pagesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        } else {
            contentView.addSubviews(tabsView, pagesView)
            NSLayoutConstraint.activate([
                tabsView.topAnchor.constraint(equalTo: contentView.topAnchor),
                tabsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                tabsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                tabsView.heightAnchor.constraint(equalToConstant: sizeConfiguration.height),
                
                pagesView.topAnchor.constraint(equalTo: tabsView.bottomAnchor, constant: 8),
                pagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                pagesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                pagesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    }
    
    // MARK: - Public Methods
    
}

// MARK: - Extension TCPagerTabsView Delegaate

extension TCPagerView: TCPagerTabsViewDelegate {
    
    func pagerTabsView(_ view: TCPagerTabsView, didMoveToTabAt index: Int) {
        self.pagesView.moveToPage(at: index)
    }
    
}

// MARK: - Extension TCPagerPagesView Delegaate

extension TCPagerView: TCPagerPagesViewDelegate {
    
    func pagerPagesView(_ view: TCPagerPagesView, didMoveToPageAt index: Int) {
        self.tabsView.moveToTab(at: index)
    }
    
}
