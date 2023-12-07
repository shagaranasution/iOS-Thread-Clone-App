//
//  TCPagerPagesView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 23/10/23.
//

import UIKit

protocol TCPagerPagesViewDelegate: AnyObject {
    
    func pagerPagesView(_ view: TCPagerPagesView, didMoveToPageAt index: Int)
    
}

/// TCPagerPagesView is class used for creating object presenting page in view pager.
/// It responsible for managing items (pages) and providing action to handle moving between pages.
final class TCPagerPagesView: UIView {
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(
            TCPagerPageCollectionViewCell.self,
            forCellWithReuseIdentifier: TCPagerPageCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    /// Pages are property provided as a number of views for each pages.
    private(set) var pages: [UIView] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Public Properties
    
    public weak var delegate: TCPagerPagesViewDelegate?
    
    // MARK: - Initialization
    
    init(
        pages: [UIView] = []
    ) {
        self.pages = pages
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
    
    /// Method used to provide view for each pages.
    /// - Parameter views: a number of views presenting content for each page.
    public func setPages(_ views: [UIView]) {
        self.pages = views
    }
    
    /// Method used to handle action of moving between pages.
    /// - Parameter index: an integer representing index which is used as identity of page.
    public func moveToPage(at index: Int) {
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    // MARK: - ScrollView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / self.collectionView.frame.size.width)
        delegate?.pagerPagesView(self, didMoveToPageAt: pageIndex)
    }
    
}

// MARK: - Extension Data Source, Layout Delegate

extension TCPagerPagesView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TCPagerPageCollectionViewCell.identifier,
            for: indexPath
        ) as? TCPagerPageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let page = pages[indexPath.item]
        cell.setView(page)
        
        return cell
    }
    
    // MARK: - Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width,
                      height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
