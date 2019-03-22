//
//  LCTitledSwitchTableViewCell.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 21/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class LCTitledSwitchTableViewCell: UITableViewCell {

    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - UIElements
    var cellTitleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    var switchControl: UISwitch = {
        var sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureSwitchControl()
        configureTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    //MARK: - Private methods
    fileprivate func configureSwitchControl() {
        contentView.addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
    }
    
    fileprivate func configureTitleLabel() {
        contentView.addSubview(cellTitleLabel)
        cellTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        cellTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        cellTitleLabel.rightAnchor.constraint(equalTo: switchControl.leftAnchor, constant: -8).isActive = true
        cellTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
}
