//
//  TCThreadsViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit

final class TCThreadsViewController: UIViewController {
    
    // MARK: - UI
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            TCThreadsTableViewCell.self,
            forCellReuseIdentifier: TCThreadsTableViewCell.identifier
        )
        
        return tableView
    }()
    
    // MARK: - Private Properties
    
    private var currentUserId: String?
    private let viewModel: TCThreadsViewViewModel
    private var didScrollTableView: ((_ contentOffset: CGPoint) -> Void)?
    
    init(withViewModel viewModel: TCThreadsViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.delegate = self
        viewModel.fetchThreads()
        setupNotificationCenterAddition()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc
    private func handleThreadPostedNotification() {
        viewModel.fetchThreads()
    }
    
    @objc
    private func handleProfileUpdatedNotification() {
        viewModel.fetchThreads()
    }
    
    private func setupNotificationCenterAddition() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleThreadPostedNotification),
            name: .threadPostedNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProfileUpdatedNotification),
            name: .profileUpdatedNotification,
            object: nil
        )
    }
    
    // MARK: - Public Methods
    
    public func registerDidScrollTableViewHandler(_ block: @escaping (CGPoint) -> Void) {
        didScrollTableView = block
    }
    
}

// MARK: - Extension UITableViewDataSource, UITableViewDelegate

extension TCThreadsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.threads.count > 0 else {
            let image = UIImage(systemName: "scribble")
            
            let placholderView = TCPlaceholderWithImageView()
            placholderView.frame = CGRect(x: 0, y: 0, width: 240, height: 120)
            placholderView.set(
                text: "There is no data\nto show.",
                image: image
            )
            let backgroundView = UIView()
            backgroundView.addSubview(placholderView)
            placholderView.center = tableView.center
            
            tableView.backgroundView = backgroundView
            tableView.separatorStyle = .none
            
            return 0
        }
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        
        return viewModel.threads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TCThreadsTableViewCell.identifier,
            for: indexPath
        ) as? TCThreadsTableViewCell else {
            return UITableViewCell()
        }
        let thread = viewModel.threads[indexPath.row]
        let cellViewModel = TCThreadsTableViewCellViewModel(thread: thread)
        cell.configure(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollTableView?(scrollView.contentOffset)
    }
    
}

extension TCThreadsViewController: TCThreadsViewViewModelDelegate {
    
    func didFetchThreads() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}
