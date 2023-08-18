//
//  File.swift
//  ExampleAssignment
//
//  Created by Aaryan jaiswal on 19/08/23.
//

import Foundation
import Security

class KeychainManager {
    private let serviceIdentifier = "com.Aaryan.PracticeAssingment.keychain"
    
    func saveTokenForPhoneNumber(_ phoneNumber: String, token: String) -> Bool {
        guard let phoneNumberData = phoneNumber.data(using: .utf8),
              let tokenData = token.data(using: .utf8) else {
            return false
        }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: phoneNumberData,
            kSecValueData as String: tokenData
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func getTokenForPhoneNumber(_ phoneNumber: String) -> String? {
        guard let phoneNumberData = phoneNumber.data(using: .utf8) else {
            return nil
        }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: phoneNumberData,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ] as [String: Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data,
           let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
    
    func deletePhoneNumber(_ phoneNumber: String) -> Bool {
        guard let phoneNumberData = phoneNumber.data(using: .utf8) else {
            return false
        }
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccount as String: phoneNumberData
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
