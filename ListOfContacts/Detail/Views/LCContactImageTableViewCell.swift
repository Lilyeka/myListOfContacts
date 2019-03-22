//
//  LCContactImageTableViewCell.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 20/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class LCContactImageTableViewCell: UITableViewCell {
    static let IMAGE_SIZE: CGFloat = 160
    static let IMAGE_TOP_OFFSET: CGFloat = 8
    static let IMAGE_BOTTOM_OFFSET: CGFloat = -8
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UIElements
    var cellImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = IMAGE_SIZE/2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private methods
    fileprivate func configureImageView() {
        self.contentView.addSubview(cellImageView)
        cellImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        cellImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: LCContactImageTableViewCell.IMAGE_TOP_OFFSET).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: LCContactImageTableViewCell.IMAGE_BOTTOM_OFFSET).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant: LCContactImageTableViewCell.IMAGE_SIZE).isActive = true
        cellImageView.widthAnchor.constraint(equalToConstant: LCContactImageTableViewCell.IMAGE_SIZE).isActive = true
    }
}
