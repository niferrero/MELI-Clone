//
//  ItemTableViewCell.swift
//  MeliClone
//
//  Created by Nicolas Alejandro Ferrero on 18/09/2022.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    var cellData: TableViewCellType? {
        didSet {
            if let cellData = cellData {
                titleLabel.text = cellData.title
                priceLabel.text = "$ \(cellData.price)"
                detailLabel.text = "\(cellData.detailName): \(cellData.detailValue)"
                addressLabel.text = cellData.addressName
                productImageView.loadFrom(URLAddress: cellData.thumbnail)
            }
        }
    }

    static var cellIdentifier = "ItemCell"
    
    private lazy var cardView: UIView = .load()
    
    private lazy var titleLabel: UILabel = .load() { view in
        view.font = UIFont.systemFont(ofSize: 13)
        view.textColor = UIColor.txtDark
        view.numberOfLines = 0
    }
    
    private lazy var priceLabel: UILabel = .load() { view in
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .black
    }
    
    private lazy var detailLabel: UILabel = .load() { view in
        view.font = UIFont.systemFont(ofSize: 11)
        view.textColor = UIColor.txtGray
    }
    
    private lazy var addressLabel: UILabel = .load() { view in
        view.font = UIFont.systemFont(ofSize: 11)
        view.textColor = UIColor.txtGray
    }
    
    private lazy var imageContainer: UIView = .load { view in
        view.addSubviews(productImageView, likeButton)
        view.setRoundBorders(10)
        productImageView.pinToEdges(of: view)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor)
        ])
        
        productImageView.width(equalTo: 131)
        productImageView.height(equalTo: 131)
    }
    
    private lazy var stackView: UIStackView = .load { view in
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(priceLabel)
        view.addArrangedSubview(detailLabel)
        view.addArrangedSubview(addressLabel)
        view.axis = .vertical
        view.spacing = 4
    }
    
    private lazy var productImageView: UIImageView = .load { view in
        view.backgroundColor = UIColor.gray
    }
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let insideCardSpacing: UIEdgeInsets = .init(
        top: 16, left: 16, bottom: 24, right: 16
    )
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Private Functions
    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubviews(imageContainer, stackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        cardView.pinToEdges(of: contentView, with: insideCardSpacing)
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageContainer.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor)
        ])
    }
}
