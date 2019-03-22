//
//  LCContact.swift
//  ListOfContacts
//
//  Created by Лилия Левина on 19/03/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import Foundation

struct LCContact {
    let id: String
    var firstName: String   //имя
    var lastName: String    //фамилия
    var middleName: String? //отчество
    var phone: String
    var image: Data?
    var isFriend: Bool?
    var isСolleague: Bool?
    var birthDay: Date?
    var workPosition: String?
    var workPhone: String?
    
    init(id:String, phone:String, name:String, lastName:String) {
        self.id = id
        self.firstName = name
        self.lastName = lastName
        self.phone = phone
    }
    //друг
    init(id:String, phone:String, friendBirthDay:Date?, name:String, lastName:String, middleName:String?, image:Data?) {
        self.init(id: id, phone: phone, name: name, lastName: lastName)
        self.isFriend = true
        self.birthDay = friendBirthDay
        self.middleName = middleName
        self.image = image
    }
    //коллега
    init(id:String, phone:String, workPosition:String?, workPhone:String?, name:String, lastName:String, middleName: String?, image:Data?) {
        self.init(id: id, phone: phone, name: name, lastName: lastName)
        self.isСolleague = true
        self.middleName = middleName
        self.workPosition = workPosition
        self.workPhone = workPhone
        self.image = image
    }
    //друг&коллега
    init(id:String, phone:String, friendBirthDay:Date?, workPosition:String?, workPhone:String?, name:String, lastName:String, middleName: String?, image:Data?) {
        self.init(id: id, phone: phone, friendBirthDay: friendBirthDay, name: name, lastName: lastName, middleName: middleName, image:image)
        self.isСolleague = true
        self.middleName = middleName
        self.workPosition = workPosition
        self.workPhone = workPhone
    }
    
    func fullName() -> String {
        if let middleName = middleName {
            return firstName + (" " + middleName + " ") + lastName
        } else {
            return firstName + " " + lastName
        }
    }
    
    func formattedBirthday() -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy"
        guard let birthDay = birthDay else {
            return ""
        }
        return dateFormatterPrint.string(from: birthDay)
    }
    
    func allRequiredPropertiesAreFilled() -> Bool {
        if let friend = isFriend, isСolleague == nil {
            return !firstName.isEmpty && !lastName.isEmpty && friend
        }
        if let colleague = isСolleague, isFriend == nil {
            return !firstName.isEmpty && !lastName.isEmpty && colleague
        }
        
        if let friend = isFriend, let colleague = isСolleague {
            return !firstName.isEmpty && !lastName.isEmpty && (friend || colleague)
        }
        
        return false
    }
    
}

extension LCContact: Equatable {
    static func == (lhs: LCContact, rhs: LCContact) -> Bool {
        return ((lhs.id == rhs.id) &&
                (lhs.firstName == rhs.firstName) &&
                (lhs.lastName == rhs.lastName) &&
                (lhs.middleName == rhs.middleName) &&
                (lhs.phone == rhs.phone) &&
                (lhs.image == rhs.image) &&
                (lhs.isFriend == rhs.isFriend) &&
                (lhs.isСolleague == rhs.isСolleague) &&
                (lhs.birthDay == rhs.birthDay) &&
                (lhs.workPosition == rhs.workPosition) &&
                (lhs.workPhone == rhs.workPhone))
    }
}
