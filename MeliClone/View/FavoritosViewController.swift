//
//  FavoritosViewController.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import UIKit

class FavoritosViewController: UIViewController {
    private let viewModel = FavoritesViewModel(service: TableService())
    
    // MARK: - Elementos Visuales
    private lazy var spinner: UIActivityIndicatorView = .load() { element in
        element.style = .large
        element.color = UIColor.accentColor
        element.isHidden = true
        view.addSubview(element)
    }
    
    private lazy var table: UITableView = .load() { element in
        element.dataSource = self
        element.delegate = self
        element.register(ItemTableViewCell.self, forCellReuseIdentifier: ItemTableViewCell.cellIdentifier)
        view.addSubview(element)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.titleView = UIView()
        print(UDHelper.getIds())
        viewModel.getFavorites(ids: UDHelper.getIds())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupSearchViewModelObserver()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Metodos Privados
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupSearchViewModelObserver() {
        viewModel.items.bind { [weak self] _ in
            DispatchQueue.main.async { self?.table.reloadData() }
        }
        
        viewModel.isSearching.bind { [weak self] isSearching in
            guard let isSearching = isSearching else { return }
            DispatchQueue.main.async {
                isSearching ? self?.spinner.show() : self?.spinner.dismiss()
            }
        }
        
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            DispatchQueue.main.async { [weak self] in
                self?.spinner.dismiss()
                let dialogMessage = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                dialogMessage.addAction(ok)
                self?.present(dialogMessage, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Extension Metodos TableView
extension FavoritosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.cellIdentifier, for: indexPath) as? ItemTableViewCell
        else { return UITableViewCell() }
        if let body = viewModel.items.value?[indexPath.row].body {
            cell.cellData = TableViewCellType(title: body.title,
                                              price: body.price ?? 0,
                                              detailName: body.attributes?[0].name ?? "",
                                              detailValue: body.attributes?[0].valueName ?? "n/c",
                                              addressName: body.sellerAddress.searchLocation?.state?.name ?? "",
                                              thumbnail: body.secureThumbnail)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Unfav", handler: { [weak self] _, _, _ in
            let id = self?.viewModel.items.value?[indexPath.row].body.id
            UserDefaults.standard.removeObject(forKey: id!)
            self?.viewModel.items.value?.remove(at: indexPath.row)
            self?.table.deleteRows(at: [indexPath], with: .automatic)
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let body = viewModel.items.value?[indexPath.row].body
        let detailVC = DetailViewController()
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.data = body
        tabBarController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
