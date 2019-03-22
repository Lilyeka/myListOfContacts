//
//  LCImageSourceViewController.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 20/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

protocol LCImageSourceViewControllerDelegate {
    func didTapFromCamera()
    func didTapFromGallery()
}

class LCImageSourceViewController: UIViewController {
    var delegate:LCImageSourceViewControllerDelegate?
    
    //MARK: - UI elements
    var bottomAnchorHide: NSLayoutConstraint?
    var bottomAnchorShow: NSLayoutConstraint?
    
    fileprivate var backgroundButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.addTarget(self, action: #selector(didTapBackgroundAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate var bottomView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate var closeButton: UIButton = {
        var button = UIButton(type: .custom)
        if let image = UIImage(named: "close_icon") {
            button.setImage(image, for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCloseButtonAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate var titleLabel: UILabel = {
        var title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Выберите источник фото"
        title.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        title.textColor = .black
        title.textAlignment = .center
        return title
    }()
    
    fileprivate var lineView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor =  UIColor.gray
        return view
    }()
    
    fileprivate var fromCameraButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Сделать снимок", for:.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        button.addTarget(self, action: #selector(didTapFromCameraAction), for: .touchUpInside)
        return button
    }()
    
    fileprivate var fromGalleryButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Выбрать из фотополенки", for:.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        button.addTarget(self, action: #selector(didTapFromGalleryAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureBackgroundButton()
        configureBottomView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomAnchorHide?.isActive = false
        bottomAnchorShow?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bottomAnchorHide?.isActive = true
        bottomAnchorShow?.isActive = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Private methods
    fileprivate func configureBackgroundButton() {
        view.addSubview(backgroundButton)
        backgroundButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func configureBottomView() {
        view.addSubview(bottomView)
        bottomView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        bottomAnchorHide = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200)
        bottomAnchorHide?.isActive = true
        bottomAnchorShow = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomAnchorShow?.isActive = false
        
        bottomView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8).isActive = true
  
        bottomView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        closeButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 8).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        bottomView.addSubview(lineView)
        lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        lineView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [fromCameraButton,fromGalleryButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        bottomView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 8).isActive = true
        stackView.leftAnchor.constraint(equalTo: bottomView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: bottomView.rightAnchor).isActive = true
        
        var bottomOffset:CGFloat = -20.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            if let bottomPadding = bottomPadding, bottomPadding > CGFloat(0) {
                bottomOffset = -bottomPadding - 8.0
            }
        }
        stackView.bottomAnchor.constraint(lessThanOrEqualTo:  bottomView.bottomAnchor, constant: bottomOffset).isActive = true
    }
    
    // MARK: -Actions
    @objc func didTapBackgroundAction(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCloseButtonAction(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapFromCameraAction(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.didTapFromCamera()
    }
    
    @objc func didTapFromGalleryAction(_ sender:UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.didTapFromGallery()
    }

}
