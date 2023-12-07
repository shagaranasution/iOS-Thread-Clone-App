//
//  TCPagerTabsView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 23/10/23.
//

import UIKit

protocol TCPagerTabsViewDelegate: AnyObject {
    
    func pagerTabsView(_ view: TCPagerTabsView, didMoveToTabAt index: Int)
    
}

/// TCPagerTabsView is class used for creating object presenting tab in view pager.
/// It responsible for managing tabs and providing action to handle tapping on each tabs.
final class TCPagerTabsView: UIView {
    
    /// SizeConfiguration is enumeration defining size categorizations which can be selected and used to custom size of the tab.
    /// It has `fillEqually(height:spacing:)`, `fixed(width:height:spacing)` for further usage.
    enum SizeConfiguration {
        case fillEqually(height: CGFloat, spacing: CGFloat)
        case fixed(width: CGFloat, height: CGFloat, spacing: CGFloat)
        
        /// Get-property for providing defined height value.
        var height: CGFloat {
            switch self {
            case .fillEqually(let height, _):
                return height
            case .fixed(_, let height, _):
                return height
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            TCPagerTabCollectionViewCell.self,
            forCellWithReuseIdentifier: TCPagerTabCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // MARK: - Private Properties
    
    private var currentSelectedIndex: Int = 0
    private(set) var tabs: [TCPagerTabItemProtocol] {
        didSet {
            self.collectionView.reloadData()
            self.tabs[currentSelectedIndex].onSelected()
        }
    }
    
    // MARK: - Public Properties
    
    public weak var delegate: TCPagerTabsViewDelegate?
    public let sizeConfiguration: SizeConfiguration
    
    // MARK: - Initialization
    
    init(
        sizeConfiguration: SizeConfiguration,
        tabs: [TCPagerTabItemProtocol] = []
    ) {
        self.sizeConfiguration = sizeConfiguration
        self.tabs = tabs
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Public Methods
    
    /// Method used to provide view for each cells.
    /// - Parameter views: a number of views presenting content for each cells.
    public func setTabs(_ tabs: [TCPagerTabItemProtocol]) {
        self.tabs = tabs
    }
    
    public func moveToTab(at index: Int) {
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        self.tabs[currentSelectedIndex].onNotSelected()
        self.tabs[index].onSelected()
        self.currentSelectedIndex = index
    }
    
}

// MARK: Extension Data Source, Layout Delegate

extension TCPagerTabsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.moveToTab(at: indexPath.item)
        self.delegate?.pagerTabsView(self, didMoveToTabAt: indexPath.item)
    }
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TCPagerTabCollectionViewCell.identifier,
            for: indexPath
        ) as? TCPagerTabCollectionViewCell else {
            return UICollectionViewCell()
        }
        let tab = tabs[indexPath.item]
        cell.setView(tab)
        
        return cell
    }
    
    // MARK: - Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch sizeConfiguration {
        case .fillEqually(let height, let spacing):
            let totalWidth = self.frame.width
            let widthPerItem = (
                totalWidth - (
                    spacing * CGFloat((self.tabs.count + 1))
                )
            ) / CGFloat(self.tabs.count)
            
            return CGSize(width: widthPerItem, height: height)
        case .fixed(let width, let height, let spacing):
            return CGSize(width: width - (spacing * 2), height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            switch sizeConfiguration {
            case .fillEqually(_, let spacing),
                 .fixed(_, _, let spacing):
                
                return spacing
            }
        }
    
}
