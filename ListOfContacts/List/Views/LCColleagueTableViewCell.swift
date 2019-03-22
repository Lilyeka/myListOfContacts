//
//  LCColleagueTableViewCell.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 20/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class LCColleagueTableViewCell: LCContactTableViewCell {
    public static var reuseColleagueCellIdentifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI Elements
    var positionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines  = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var workPhoneLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        phoneLabelBottomConstraint?.isActive = false
        configurePositionLabel()
        configureWorkPhoneLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: - Private methods
    fileprivate func configurePositionLabel() {
        contentView.addSubview(positionLabel)
        positionLabel.leftAnchor.constraint(equalTo: phoneLabel.leftAnchor).isActive = true
        positionLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4).isActive = true
        positionLabel.rightAnchor.constraint(equalTo: phoneLabel.rightAnchor).isActive = true
    }
    
    fileprivate func configureWorkPhoneLabel() {        
        contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: positionLabel.leftAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 4).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        contentView.addSubview(workPhoneLabel)
        workPhoneLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4).isActive = true
        workPhoneLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 4).isActive = true
        workPhoneLabel.rightAnchor.constraint(equalTo: positionLabel.rightAnchor).isActive = true
        workPhoneLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8).isActive = true
    }

}
