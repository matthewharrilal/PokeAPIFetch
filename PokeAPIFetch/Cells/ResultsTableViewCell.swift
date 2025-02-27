//
//  ResultsTableViewCell.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/27/24.
//

import Foundation
import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    static var identifier: String {
        String(describing: ResultsTableViewCell.self)
    }
    
    private var hasAnimatedText: Bool = false
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: TypewriterLabel = {
        let label = TypewriterLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: TypewriterLabel = {
        let label = TypewriterLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.subviews.forEach { $0.updateShimmerLayer() }
    }
}

extension ResultsTableViewCell {
    
    private func setup() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 36),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        contentView.subviews.forEach { $0.startShimmer() }
    }
    
    func configure(_ pokemonWithImage: PokemonWithImage) {
        contentView.subviews.forEach { $0.stopShimmer() }
        
        thumbnailImageView.image = pokemonWithImage.image
        titleLabel.text = pokemonWithImage.name
        descriptionLabel.text = "Placeholder for now"
    }
}
