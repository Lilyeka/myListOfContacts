//
//  LCTextFieldTableViewCell.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 20/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit
protocol LCTextFieldTableViewCellDelegate {
    func textDidChange(_ sender: UITextField)
}


class LCTextFieldTableViewCell: UITableViewCell {
    static let TITLE_TOP_OFFSET: CGFloat = 4
    static let TITLE_HEIGHT: CGFloat = 17
    static let TEXTFIELD_TOP_OFFSET: CGFloat = 4
    static let TEXTFIELD_BOTTOM_OFFSET: CGFloat = TEXTFIELD_TOP_OFFSET
    
    var delegate: LCTextFieldTableViewCellDelegate?
    
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    fileprivate var titleHeightConstraintHide: NSLayoutConstraint?
    fileprivate var titleTopOffsetConstraintHide: NSLayoutConstraint?
    fileprivate var titleHeightConstraintShow: NSLayoutConstraint?
    fileprivate var titleTopOffsetConstraintShow: NSLayoutConstraint?
    
    // MARK: - UIElements
    var cellTitleLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    var textField: UITextField = {
        var textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        return textfield
    }()
    
    // MARK: - Init
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureHiddenTitleLabel()
        configureTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Private methods
    fileprivate func configureHiddenTitleLabel() {
        self.contentView.addSubview(cellTitleLabel)
        
        titleTopOffsetConstraintHide = cellTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0)
        titleTopOffsetConstraintShow = cellTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: LCTextFieldTableViewCell.TITLE_TOP_OFFSET)
        titleHeightConstraintHide = cellTitleLabel.heightAnchor.constraint(equalToConstant: 0)
        titleHeightConstraintShow = cellTitleLabel.heightAnchor.constraint(equalToConstant: LCTextFieldTableViewCell.TITLE_HEIGHT)
        
        cellTitleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        cellTitleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
    }
    
    fileprivate func configureTextField() {
        self.contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: cellTitleLabel.bottomAnchor, constant: LCTextFieldTableViewCell.TEXTFIELD_TOP_OFFSET).isActive = true
        textField.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -LCTextFieldTableViewCell.TEXTFIELD_BOTTOM_OFFSET).isActive = true
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    //MARK: - Actions
    @objc func textDidChange(_ sender: UITextField) {
        delegate?.textDidChange(sender)
    }
    
    //MARK: - Public methods
    func showTitle() {
        titleHeightConstraintHide?.isActive = false
        titleHeightConstraintShow?.isActive = true
        titleTopOffsetConstraintHide?.isActive = false
        titleTopOffsetConstraintShow?.isActive = true
    }
    
    func hideTitle() {
        titleTopOffsetConstraintHide?.isActive = true
        titleTopOffsetConstraintShow?.isActive = false
        titleHeightConstraintHide?.isActive = true
        titleHeightConstraintShow?.isActive = false
    }
}
