//
//  LCContactListTableViewCell.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 19/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class LCContactTableViewCell: UITableViewCell {
    
    static let IMAGE_SIZE: CGFloat = 90.0
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI elements
    var contactImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = IMAGE_SIZE/2
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines  = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var phoneLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    
    var phoneLabelBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureNameLabel()
        configureImageView()
        configurePhoneLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    
    fileprivate func configureNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
    }

    fileprivate func configureImageView() {
        contentView.addSubview(contactImageView)
        contactImageView.leftAnchor.constraint(equalTo:contentView.leftAnchor, constant: 8).isActive = true
        contactImageView.topAnchor.constraint(equalTo:nameLabel.topAnchor).isActive = true
        contactImageView.rightAnchor.constraint(equalTo:nameLabel.leftAnchor, constant: -8).isActive = true
       contactImageView.bottomAnchor.constraint(lessThanOrEqualTo:contentView.bottomAnchor, constant: -8).isActive = true
        contactImageView.heightAnchor.constraint(equalToConstant: LCContactTableViewCell.IMAGE_SIZE).isActive = true
        contactImageView.widthAnchor.constraint(equalToConstant: LCContactTableViewCell.IMAGE_SIZE).isActive = true
    }

    fileprivate  func configurePhoneLabel() {
        contentView.addSubview(phoneLabel)
        phoneLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        phoneLabelBottomConstraint = phoneLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        phoneLabelBottomConstraint?.isActive = true
    }
}
