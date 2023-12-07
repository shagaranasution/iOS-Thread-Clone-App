//
//  TCAllActivitiesViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 24/10/23.
//

import UIKit

final class TCAllActivitiesViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(
            TCSearchTableViewCell.self,
            forCellReuseIdentifier: TCSearchTableViewCell.identifier
        )
        
        return tableView
    }()
    
    // MARK: - Properties
    
    public var didScrollTableView: ((_ contentOffset: CGPoint) -> Void)?
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.dataSource = self
        tableView.delegate = self
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
    
}

// MARK: - Extension Table Data Source, Layout Delegate

extension TCAllActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TCSearchTableViewCell.identifier,
            for: indexPath
        ) as? TCSearchTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    // MARK: - Layout Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollTableView?(tableView.contentOffset)
    }
    
}
