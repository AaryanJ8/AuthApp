//
//  Model.swift
//  ExampleAssignment
//
//  Created by Aaryan jaiswal on 19/08/23.
//

import Foundation
struct PhoneNumberModel {
    let countryCode: String
    let phoneNumber: String
    
    var fullPhoneNumber: String {
        return countryCode + phoneNumber
    }
}
