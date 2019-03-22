//
//  ViewController.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 19/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class LCListOfContactsViewController: UIViewController {
    //MARK: - Data
    var contactsArray = [LCContact]()
    var friendsArray = [LCContact]()
    var colleaguesArray = [LCContact]()
    
    //MARK: - UI elements
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Друзья", "Коллеги"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(changeList), for: .valueChanged)
        return control
    }()
    
    lazy var addButton: UIBarButtonItem = {
       return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContactAction))
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fillTestData()
        configureNavigationItem()
        configureTableView()
    }
    
    //MARK: - Actions
    @objc func changeList(sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @objc func addContactAction() {
        let vc = LCContactDetailViewController()
        vc.delegate = self
        vc.createNewMode = true
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            vc.contact = LCContact(id: UUID().uuidString, phone: "", friendBirthDay: nil, name: "", lastName: "", middleName: nil, image:nil)
        case 1:
            vc.contact = LCContact(id: UUID().uuidString, phone: "", workPosition: nil, workPhone: nil, name: "", lastName: "", middleName: nil, image:nil)
        default:
            break
        }
        show(vc, sender: self)
    }
    
    // MARK: - Private methods
    
    fileprivate func fillTestData() {
        let f_contact1 = LCContact(id: UUID().uuidString, phone: "89177979790", friendBirthDay: nil, name: "Иван", lastName: "Иванов", middleName: "Иванович", image: UIImage(named:"cheburashka")?.jpegData(compressionQuality: 0.5))
        let f_contact2 = LCContact(id: UUID().uuidString, phone: "8(347)2509090", friendBirthDay: nil, name: "Петр", lastName: "Петров", middleName: nil,image: UIImage(named:"ilon")?.jpegData(compressionQuality: 0.5))
        let f_contact3 = LCContact(id: UUID().uuidString, phone: "8(495)8889900", friendBirthDay: Date(), name: "Габдулхалим", lastName: "Павлиашвилли", middleName: "Курбонаевич", image:nil)
        let c_contact1 = LCContact(id: UUID().uuidString, phone: "880080999099", workPosition: "Начальник сетора заключения договоров юридического департамента ООО Бульдог", workPhone: "120", name: "Константин", lastName: "Стрельников", middleName: "Георгиевич", image:UIImage(named:"gena")?.jpegData(compressionQuality: 0.5))
        let c_contact2 = LCContact(id: UUID().uuidString, phone: "880080999099", workPosition: "Продюссер центр Радос", workPhone: "+74958009088", name: "Вера", lastName: "Брежнева", middleName: "Викторовна", image:UIImage(named:"brej")?.jpegData(compressionQuality: 0.5))
        let cf_contact = LCContact(id:UUID().uuidString, phone: "77890904920492", friendBirthDay: Date(), workPosition: "Программист", workPhone: "78990909090", name: "Василий", lastName: "Петров", middleName: "Васильевич", image:nil)
        contactsArray = [f_contact1, f_contact2, f_contact3, c_contact1, c_contact2, cf_contact]
        setFriendsAndColleaguesArrays()
    }
    
    fileprivate func configureNavigationItem() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = addButton
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 128

        tableView.register(LCFriendTableViewCell.self, forCellReuseIdentifier: LCFriendTableViewCell.reuseFriendCellIdentifier)
        tableView.register(LCColleagueTableViewCell.self, forCellReuseIdentifier: LCColleagueTableViewCell.reuseColleagueCellIdentifier)
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func setFriendsAndColleaguesArrays() {
        friendsArray = contactsArray.filter {$0.isFriend == true}.sorted(by:{ $0.fullName() < $1.fullName()})
        colleaguesArray = contactsArray.filter {$0.isСolleague == true}.sorted(by: {$0.fullName() < $1.fullName()})
    }
}

extension LCListOfContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return friendsArray.count
        case 1:
            return colleaguesArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let contact: LCContact = friendsArray[indexPath.row]
            var cell = tableView.dequeueReusableCell(withIdentifier: LCFriendTableViewCell.reuseFriendCellIdentifier, for: indexPath) as? LCFriendTableViewCell
            if cell == nil {
                cell = LCFriendTableViewCell(style: .default, reuseIdentifier: LCContactTableViewCell.reuseIdentifier)
            }
            cell?.nameLabel.text = contact.fullName()
            cell?.phoneLabel.text = contact.phone
            cell?.contactImageView.image =  UIImage(data: contact.image ?? Data()) ?? UIImage(named: "default")
            let stringBirthday = contact.formattedBirthday()
            if !stringBirthday.isEmpty {
                cell?.birthdayLabel.text = contact.formattedBirthday()
                cell?.titleBirthdayLabel.text = "День рождения:"
            }
            return cell!
        case 1:
            let contact: LCContact = colleaguesArray[indexPath.row]
            var cell = tableView.dequeueReusableCell(withIdentifier: LCColleagueTableViewCell.reuseColleagueCellIdentifier, for: indexPath) as? LCColleagueTableViewCell
            if cell == nil {
                cell = LCColleagueTableViewCell(style: .default, reuseIdentifier: LCColleagueTableViewCell.reuseColleagueCellIdentifier)
            }
            cell?.nameLabel.text = contact.fullName()
            cell?.phoneLabel.text = contact.phone
            cell?.contactImageView.image =  UIImage(data: contact.image ?? Data()) ?? UIImage(named: "default")
            cell?.positionLabel.text = contact.workPosition
            if let workPhone = contact.workPhone, !workPhone.isEmpty {
                cell?.titleLabel.text = "Рабочий телефон:"
                cell?.workPhoneLabel.text = contact.workPhone
            }
            return cell!
        default:
            return UITableViewCell()
        }
    }
}

extension LCListOfContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LCContactDetailViewController()
        vc.delegate = self
        vc.createNewMode = false
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            vc.contact = friendsArray[indexPath.row]
        case 1:
            vc.contact = colleaguesArray[indexPath.row]
        default:
            break
        }
        show(vc, sender: self)
    }
}

extension LCListOfContactsViewController: LCContactDetailViewControllerDelegate {
    func didPressSaveButton(contact: LCContact) {
        if let index = contactsArray.firstIndex(where: { $0.id == contact.id }) {
            contactsArray[index] = contact
        }
        setFriendsAndColleaguesArrays()
        tableView.reloadData()
    }
    
    func didPressCreateNewItemButton(contact: LCContact) {
        contactsArray.append(contact)
        setFriendsAndColleaguesArrays()
        tableView.reloadData()
    }
}

