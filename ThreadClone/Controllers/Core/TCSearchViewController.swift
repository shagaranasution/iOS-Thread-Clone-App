//
//  TCSearchViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit
import PhotosUI

final class TCSearchViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let viewModel = TCSearchViewViewModel()
    
    // MARK: - UI
    
    private lazy var searchController: UISearchController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        let searchController = UISearchController(searchResultsController: vc)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            TCSearchTableViewCell.self,
            forCellReuseIdentifier: TCSearchTableViewCell.identifier
        )
        
        return tableView
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
        view.addSubviews(tableView)
        addConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
        viewModel.fetchUsers()
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

// MARK: - Extension UITableViewDataSource, UITableViewDelegate

extension TCSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.users.count > 0 else {
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
            
            return 0
        }
        
        tableView.backgroundView = nil
        
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TCSearchTableViewCell.identifier,
            for: indexPath
        ) as? TCSearchTableViewCell else {
            return UITableViewCell()
        }
        
        let viewModel = TCSearchTableViewCellViewModel(user: viewModel.users[indexPath.row])
        cell.configure(with: viewModel)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = viewModel.users[indexPath.row]
        let vc = TCProfileViewController(userId: user.id)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
}

// MARK: - Extension TCSearchViewViewModel Delegate

extension TCSearchViewController: TCSearchViewViewModelDelegate {
    
    func didFetchUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
}
