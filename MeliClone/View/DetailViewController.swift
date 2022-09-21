//
//  DetailViewController.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import UIKit

class DetailViewController: UIViewController {
    var data: Body?
    private let viewModel = detailViewModel()
    
    // MARK: - Elementos Visuales
    private lazy var spinner: UIActivityIndicatorView = .load() { element in
        element.style = .large
        element.color = UIColor.accentColor
        element.isHidden = true
        view.addSubview(element)
    }
    
    private lazy var navigationLabel: UILabel = .load() { element in
        element.font = UIFont.systemFont(ofSize: 14)
        element.numberOfLines = 0
        element.textColor = .black
        element.text = "Enviar a Nombre de Usuario - Dirección"
    }
    
    private lazy var navigationIcon: UIImageView = .load() { element in
        element.image = UIImage(systemName: "mappin")
        element.tintColor = .black
    }
    
    private lazy var stack: UIStackView = .load() { element in
        element.backgroundColor = UIColor.primaryColor
        element.axis = .horizontal
        element.spacing = UIStackView.spacingUseSystem
        element.isLayoutMarginsRelativeArrangement = true
        element.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
        element.addArrangedSubview(navigationIcon)
        element.addArrangedSubview(navigationLabel)
        view.addSubview(element)
    }
    
    private lazy var scrollView: UIScrollView = .load() { element in
        view.addSubview(element)
    }
    
    private lazy var contentView: UIView = .load() { element in
        scrollView.addSubview(element)
    }
    
    private lazy var subTitleLabel: UILabel = .load() { element in
        element.font = UIFont.systemFont(ofSize: 12)
        element.numberOfLines = 0
        element.textColor = UIColor.txtGray
        contentView.addSubview(element)
    }
    
    private lazy var titleLabel: UILabel = .load() { element in
        element.font = UIFont.systemFont(ofSize: 16)
        element.textColor = UIColor.txtDark
        element.numberOfLines = 0
        contentView.addSubview(element)
    }
    
    private lazy var image : UIImageView = .load() { element in
        //element.contentMode = .scaleAspectFill
        //element.clipsToBounds = true
//        element.layer.borderWidth = 1
//        element.layer.borderColor = UIColor.red.cgColor
        element.backgroundColor = .lightGray
        contentView.addSubview(element)
    }
    
    private lazy var priceLabel: UILabel = .load() { element in
        element.font = UIFont.systemFont(ofSize: 36)
        element.textColor = .black
        element.numberOfLines = 0
        contentView.addSubview(element)
    }
    
    private lazy var questionButton: MELIButton = {
        let btn = MELIButton(text: "Preguntar", icon: nil, .Primary)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var wappButton: MELIButton = {
        let btn = MELIButton(text: "WhatsApp", icon: UIImage(systemName: "paperclip"), .Primary)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var buttonStack: UIStackView = .load() { element in
        element.axis = .horizontal
        element.spacing = 9
        element.alignment = .center
        element.distribution = .fillEqually
        element.addArrangedSubview(questionButton)
        element.addArrangedSubview(wappButton)
        contentView.addSubview(element)
    }
    
    private lazy var favButton: MELIButton = {
        let btn = MELIButton(text: "Agregar a favoritos", icon: UIImage(systemName: "heart"), .Link)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var shareButton: MELIButton = {
        let btn = MELIButton(text: "Compartir", icon: UIImage(systemName: "paperclip"), .Link)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var linkStack: UIStackView = .load() { element in
        element.axis = .horizontal
        element.spacing = 0
        element.alignment = .center
        element.distribution = .equalCentering
        element.addArrangedSubview(favButton)
        element.addArrangedSubview(shareButton)
        contentView.addSubview(element)
    }
    
    private lazy var descriptionLabel: UILabel = .load() { element in
        element.font = UIFont.systemFont(ofSize: 16)
        element.text = "Descripción"
        element.textColor = UIColor.txtDark
        element.numberOfLines = 0
        contentView.addSubview(element)
    }
    
    private lazy var descriptionText: UILabel = .load() { element in
        element.font = UIFont.systemFont(ofSize: 12)
        element.textColor = UIColor.txtDark
        element.numberOfLines = 0
        contentView.addSubview(element)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupData()
        setupConstraints()
        setupSearchViewModelObserver()
    }
    
    // MARK: - Metodos Privados
    private func setupData() {
        guard let id = data?.id else { return }
        viewModel.getData(itemId: id)
        subTitleLabel.text = data?.title
        titleLabel.text = data?.title
        if let imageurl = data?.secureThumbnail { image.loadFrom(URLAddress: imageurl) }
        if let price = data?.price { priceLabel.text = "$ \(price)" }
    }
    
    private func setupSearchViewModelObserver() {
        viewModel.description.bind { [weak self] description in
            DispatchQueue.main.async { self?.descriptionText.text = description }
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stack.heightAnchor.constraint(equalToConstant: 50),

            scrollView.topAnchor.constraint(equalTo: stack.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subTitleLabel.widthAnchor.constraint(equalToConstant: 225),
            subTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 320),
            titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 6),
            
            image.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 46),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.widthAnchor.constraint(equalToConstant: 198),
            priceLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 24),
            
            buttonStack.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 25),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            linkStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 34),
            linkStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 320),
            descriptionLabel.topAnchor.constraint(equalTo: linkStack.bottomAnchor, constant: 58),
            
            descriptionText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            descriptionText.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            descriptionText.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavBar() {
        guard let id = data?.id else { return }
        let heartButton = UIBarButtonItem(image: UIImage(systemName: viewModel.isFavorite(key: id) ? "heart" : "heart.fill"), style: .done, target: self, action: #selector(addFavorite))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: nil)
        let cartButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .done, target: self, action: nil)
        heartButton.tintColor = .black
        searchButton.tintColor = .black
        cartButton.tintColor = .black
        self.navigationItem.rightBarButtonItems = [cartButton, searchButton, heartButton]
    }
    
    @objc func addFavorite() {
        guard let id = data?.id else { return }
        viewModel.isFavorite(key: id) ? viewModel.addFavorite(key: id, value: id) : viewModel.removeFavorite(key: id)
        self.navigationItem.rightBarButtonItems?[2].image = UIImage(systemName: viewModel.isFavorite(key: id) ? "heart" : "heart.fill")
    }
}
