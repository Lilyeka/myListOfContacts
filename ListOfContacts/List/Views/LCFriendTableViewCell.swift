//
//  LCFriendTableViewCell.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 20/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class LCFriendTableViewCell: LCContactTableViewCell {
    public static var reuseFriendCellIdentifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI elements
    var birthdayLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleBirthdayLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        phoneLabelBottomConstraint?.isActive = false
        configureBirthdayLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func configureBirthdayLabel() {
        contentView.addSubview(titleBirthdayLabel)
        titleBirthdayLabel.leftAnchor.constraint(greaterThanOrEqualTo: phoneLabel.leftAnchor).isActive = true
        titleBirthdayLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4).isActive = true
        titleBirthdayLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        contentView.addSubview(birthdayLabel)
        birthdayLabel.leftAnchor.constraint(equalTo: titleBirthdayLabel.rightAnchor, constant: 4).isActive = true
        birthdayLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4).isActive = true
        birthdayLabel.rightAnchor.constraint(equalTo: phoneLabel.rightAnchor).isActive = true
        birthdayLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
}
