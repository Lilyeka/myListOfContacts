//
//  LCContactDetailViewController.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 20/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit
import Photos

protocol LCContactDetailViewControllerDelegate {
    func didPressSaveButton(contact: LCContact)
    func didPressCreateNewItemButton(contact: LCContact)
}

class LCContactDetailViewController: UIViewController {
    //MARK: - Delegate
    var delegate:LCContactDetailViewControllerDelegate?
    
    enum Constants {
        static let nameMaxCharacters = 20
        static let phoneMaxCharacters = 12
        static let workPositionMaxCharacters = 100
    }
    
    enum RowTypes: String, CaseIterable {
        case imageRow
        case firstNameRow = "Имя"
        case lastNameRow = "Фамилия"
        case middleNameRow = "Отчество"
        case phoneNumberRow = "Телефон"
        case friendRow = "Это друг"
        case birthdayRow = "День рождения"
        case colleagueRow = "Это коллега"
        case positionRow = "Должность"
        case workPhoneRow = "Рабочий телефон"
    }
    
    //MARK: - Variables
    var rowsArray: [RowTypes] = [RowTypes]()
    var createNewMode: Bool = true
    var contact: LCContact? {
        didSet {
            saveButtonAvailability()
            configureRowsArray()
        }
    }
    fileprivate var isShowKeyBoard: Bool = false
    fileprivate var isDataEditing: Bool = false
    fileprivate var contactCopy: LCContact?
  
    //MARK: - UI elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var createNewButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveNewAction))
        return button
    }()
    
    private lazy var editButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editAction))
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        var imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        return imgPicker
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private lazy var datePickerToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        return toolbar
    }()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavigationItem()
        configureTableView()
        contactCopy = contact
        if createNewMode { saveButtonAvailability() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Private methods
    fileprivate func saveButtonAvailability() {
        createNewButton.isEnabled = !(contact == contactCopy)
    }
    
    fileprivate func configureRowsArray() {
        guard let contact = contact else {
            return
        }
        rowsArray = [
            .imageRow,
            .firstNameRow,
            .lastNameRow,
            .middleNameRow,
            .phoneNumberRow
        ]
        rowsArray.append(.friendRow)
        if let friend = contact.isFriend, friend {
            rowsArray.append(.birthdayRow)
        } else if let birthdayRowIndex = rowsArray.firstIndex(of:.birthdayRow) {
            rowsArray.remove(at: birthdayRowIndex)
        }
        
        rowsArray.append(.colleagueRow)
        if let colleaugue = contact.isСolleague, colleaugue {
            rowsArray.append(.positionRow)
            rowsArray.append(.workPhoneRow)
        } else if let positionIndex = rowsArray.firstIndex(of:.positionRow), let wPhoneIndex = rowsArray.firstIndex(of:.workPhoneRow){
            rowsArray.remove(at: positionIndex)
            rowsArray.remove(at: wPhoneIndex)
        }
    }
    
    fileprivate func configureNavigationItem() {
        let backButton = UIBarButtonItem(title: "<Назад ", style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = createNewMode ? createNewButton : editButton
    }
    
    fileprivate func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 128
        
        tableView.register(LCContactImageTableViewCell.self, forCellReuseIdentifier: LCContactImageTableViewCell.reuseIdentifier)
        tableView.register(LCTextFieldTableViewCell.self, forCellReuseIdentifier: LCTextFieldTableViewCell.reuseIdentifier)
        tableView.register(LCTitledSwitchTableViewCell.self, forCellReuseIdentifier: LCTitledSwitchTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    fileprivate func dissmissVisibleViewController() {
        if let window = UIApplication.shared.delegate?.window {
            var vc = window?.rootViewController
            if (vc is UINavigationController) {
                vc = (vc as! UINavigationController).visibleViewController
                vc?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func showSaveQuestionViewController() {
        let vc = LCSaveChangesQuestionViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func getPropertyValueFor(row: LCContactDetailViewController.RowTypes) -> String? {
        switch row {
        case .firstNameRow:
            return contact?.firstName
        case .lastNameRow:
            return contact?.lastName
        case .middleNameRow:
            return contact?.middleName
        case .phoneNumberRow:
            return contact?.phone
        case .birthdayRow:
            return contact?.formattedBirthday()
        case .workPhoneRow:
            return contact?.workPhone
        case .positionRow:
            return contact?.workPosition
        default:
            break
        }
        return ""
    }
    
    fileprivate func setPropertyValueFor(row: LCContactDetailViewController.RowTypes, text:String?) {
        let value = text ?? ""
        switch row {
        case .firstNameRow:
            contact?.firstName = value
        case .lastNameRow:
            contact?.lastName = value
        case .middleNameRow:
            contact?.middleName = value
        case .phoneNumberRow:
            contact?.phone = value
        case .workPhoneRow:
            contact?.workPhone = value
        case .positionRow:
            contact?.workPosition = value
        default:
            break
        }
    }
    
    fileprivate func saveNewContact() {
        guard let contact = contact, contact.allRequiredPropertiesAreFilled() else {
            showErrorAlert(title: "Сохранение нового контакта невозможно", text: "Проверьте зполнены ли необходимые поля - Имя, Фамилия, признаки Друг/Коллега")
            return
        }
        delegate?.didPressCreateNewItemButton(contact: contact)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func saveEditedContact() {
        guard let contact = contact, contact.allRequiredPropertiesAreFilled() else {
            showErrorAlert(title: "Сохранение контакта невозможно", text: "Проверьте зполнены ли необходимые поля - Имя, Фамилия, признаки Друг/Коллега")
            return
        }
        delegate?.didPressSaveButton(contact: contact)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func showErrorAlert(title: String?, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ОК", style: .cancel))
        present(alertController, animated: true)
    }
    
    fileprivate func showImageSourceViewContoller() {
        let vc = LCImageSourceViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func prepareRowsForEditing() {
        for row in rowsArray {
            let rowsWithTextFields:[RowTypes] = [.firstNameRow, .lastNameRow, .middleNameRow, .phoneNumberRow, .birthdayRow, .workPhoneRow, .positionRow]
            if rowsWithTextFields.contains(row),let cell = tableView.cellForRow(at: IndexPath(row: rowsArray.firstIndex(of: row)!, section: 0)) as? LCTextFieldTableViewCell {
                cell.textField.isUserInteractionEnabled = true
                cell.showTitle()
            }
            let rowsWithSwitch:[RowTypes] = [.friendRow, .colleagueRow]
            if rowsWithSwitch.contains(row), let cell = tableView.cellForRow(at: IndexPath(row: rowsArray.firstIndex(of: row)!, section: 0)) as? LCTitledSwitchTableViewCell {
                cell.switchControl.isUserInteractionEnabled = true
            }
            if row == .imageRow, let cell = tableView.cellForRow(at: IndexPath(row: rowsArray.firstIndex(of: row)!, section: 0)) as? LCContactImageTableViewCell {
                cell.cellImageView.isUserInteractionEnabled = true
            }
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    //MARK: - NotificationCenter
    @objc func keyboardWillShow(_ notification: Notification) {
        if !isShowKeyBoard {
            isShowKeyBoard = true
            let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            guard let keyboardHeight = keyboardSize?.height else {
                return
            }
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height - keyboardHeight - 10)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if isShowKeyBoard {
            isShowKeyBoard = false
             tableView.frame = view.safeAreaLayoutGuide.layoutFrame
        }
    }

    //MARK: - Actions
    @objc func backAction(sender: UIBarButtonItem) {
        view.endEditing(true)
        guard let contactCopy = contactCopy, let contact = contact, contactCopy == contact else {
            showSaveQuestionViewController()
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveNewAction(sender: UIBarButtonItem) {
        view.endEditing(true)
        saveNewContact()
    }
    
    @objc func editAction(sender: UIBarButtonItem) {
        if (isDataEditing) {
            view.endEditing(true)
            saveEditedContact()
        } else {
            prepareRowsForEditing()
        }
        isDataEditing = !isDataEditing
        navigationItem.rightBarButtonItems![0].title = isDataEditing ? "Сохранить" : "Править"
    }
    
    @objc func switchControlDidChange(_ sender: UISwitch) {
        let rowType = rowsArray[sender.tag]
        switch rowType {
        case .friendRow:
            contact?.isFriend = sender.isOn
        case .colleagueRow:
            contact?.isСolleague = sender.isOn
        default:
            break
        }
        tableView.reloadData()
    }
    
    @objc func doneDatePicker(_ sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let cell = tableView.cellForRow(at: IndexPath(row: rowsArray.firstIndex(of: .birthdayRow)!, section: 0)) as? LCTextFieldTableViewCell {
            cell.textField.text = dateFormatter.string(from: datePicker.date)
        }
        contact?.birthDay = datePicker.date
        view.endEditing(true)
    }
    
    @objc func cancelDatePicker(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @objc func tapContactImage(_ sender:UIImageView) {
        view.endEditing(true)
        showImageSourceViewContoller()
    }
    
}

//MARK: - UITableViewDataSource
extension LCContactDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = rowsArray[indexPath.row]
        switch rowType {
            case .imageRow:
                var cell = tableView.dequeueReusableCell(withIdentifier: LCContactImageTableViewCell.reuseIdentifier, for: indexPath) as? LCContactImageTableViewCell
                if cell == nil {
                    cell = LCContactImageTableViewCell(style: .default, reuseIdentifier: LCContactImageTableViewCell.reuseIdentifier)
                }
                cell?.cellImageView.image = UIImage(data: contact?.image ?? Data()) ?? UIImage(named: "default")
                cell?.cellImageView.isUserInteractionEnabled = (createNewMode || isDataEditing)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapContactImage))
                cell?.cellImageView.addGestureRecognizer(tapGesture)
                return cell!
            case .firstNameRow, .lastNameRow, .middleNameRow, .phoneNumberRow, .birthdayRow,.positionRow,.workPhoneRow:
                var cell = tableView.dequeueReusableCell(withIdentifier: LCTextFieldTableViewCell.reuseIdentifier, for: indexPath) as? LCTextFieldTableViewCell
                if cell == nil {
                    cell = LCTextFieldTableViewCell(style: .default, reuseIdentifier: LCTextFieldTableViewCell.reuseIdentifier)
                }
                cell?.cellTitleLabel.text = rowType.rawValue
                cell?.textField.delegate = self
                cell?.textField.tag = indexPath.row
                cell?.textField.isUserInteractionEnabled = (createNewMode || isDataEditing)
                cell?.textField.text = getPropertyValueFor(row: rowType)
                (createNewMode || isDataEditing) ? cell?.showTitle() : cell?.hideTitle()
                cell?.textField.inputView = nil
                cell?.textField.inputAccessoryView = nil
                if rowType == .birthdayRow {
                    cell?.showTitle()
                    cell?.textField.inputView = datePicker
                    cell?.textField.inputAccessoryView = datePickerToolbar
                }
                if rowType == .workPhoneRow || rowType == .positionRow {
                    cell?.showTitle()
                }
                return cell!
            case .friendRow, .colleagueRow:
                var cell = tableView.dequeueReusableCell(withIdentifier: LCTitledSwitchTableViewCell.reuseIdentifier, for: indexPath) as?
                LCTitledSwitchTableViewCell
                if cell == nil {
                    cell = LCTitledSwitchTableViewCell(style: .default, reuseIdentifier: LCTitledSwitchTableViewCell.reuseIdentifier)
                }
                cell?.cellTitleLabel.text = rowType.rawValue
                cell?.switchControl.tag = indexPath.row
                cell?.switchControl.addTarget(self, action: #selector(switchControlDidChange), for: .valueChanged)
                cell?.switchControl.isOn = rowType == .friendRow ? (contact?.isFriend ?? false) : (contact?.isСolleague ?? false)
                cell?.switchControl.isUserInteractionEnabled = (createNewMode || isDataEditing)
                return cell!
        }
    }
    
}
//MARK: - UITableViewDelegate
extension LCContactDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        if (isDataEditing || createNewMode) {
            switch rowsArray[indexPath.row] {
            case .imageRow:
                showImageSourceViewContoller()
            default:
                break
            }
        }
    }

}

//MARK: - UITextFieldDelegate
extension LCContactDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.resignFirstResponder()
        let rowType = rowsArray[textField.tag]
        setPropertyValueFor(row: rowType, text: textField.text)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let rowType = rowsArray[textField.tag]
        setPropertyValueFor(row: rowType, text: textField.text)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
      
        let rowType = rowsArray[textField.tag]
        var maxCharacters = 0
        switch rowType {
        case .firstNameRow, .lastNameRow, .middleNameRow:
            maxCharacters = Constants.nameMaxCharacters
        case .phoneNumberRow, .workPhoneRow:
            maxCharacters = Constants.phoneMaxCharacters
        case .positionRow:
            maxCharacters = Constants.workPositionMaxCharacters
        default:
            break
        }
        
        if count >= maxCharacters {
            showErrorAlert(title: nil, text: "Максимальное количество символов: \(maxCharacters)")
            view.endEditing(true)
        }
        
        if rowType == .phoneNumberRow || rowType == .workPhoneRow {
            let allowedCharacterSet = CharacterSet(charactersIn: "+1234567890")
            let typedCharacteSet = CharacterSet(charactersIn: string)
            if !allowedCharacterSet.isSuperset(of: typedCharacteSet) {
                showErrorAlert(title: "Недопустимый символ", text: "Допустим ввод цифр и знака +")
            }
            return count <= maxCharacters && (allowedCharacterSet.isSuperset(of: typedCharacteSet))
        }
        return count <= maxCharacters
    }
}

extension LCContactDetailViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        self.view.endEditing(true)
    }
}

extension LCContactDetailViewController: LCImageSourceViewControllerDelegate {
    func didTapFromCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Нет доступа к камере", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func didTapFromGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension LCContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let asset = info[.phAsset] as? PHAsset {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFit,
                options: nil) { result, info in
                    guard let image = result else {
                        return
                    }
                    self.contact?.image = image.jpegData(compressionQuality: 0.5)
            }
        } else if let image = info[.originalImage] as? UIImage {
            self.contact?.image = image.jpegData(compressionQuality: 0.5)
        }
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with:.automatic)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension LCContactDetailViewController: LCSaveChangesQuestionViewControllerDelegate {
    func didTapSave() {
        createNewMode ? saveNewContact(): saveEditedContact()
    }
    
    func didTapNotSave() {
        navigationController?.popViewController(animated: true)
    }
}
