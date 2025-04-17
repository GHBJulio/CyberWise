//
//  EncryptionHelper.swift
//  CyberWiseMain
//
//  Created by GUILHERME JULIO on 19/01/2025.
//

import Foundation

import CryptoKit

class EncryptionHelper {
    private let key: SymmetricKey
    
    init() {
        // Generate a persistent key (you can save it securely in the Keychain)
        if let savedKey = UserDefaults.standard.data(forKey: "encryptionKey") {
            key = SymmetricKey(data: savedKey)
        } else {
            let newKey = SymmetricKey(size: .bits256)
            UserDefaults.standard.set(newKey.withUnsafeBytes { Data($0) }, forKey: "encryptionKey")
            key = newKey
        }
    }
    
    func encrypt(_ text: String) -> String? {
        guard let data = text.data(using: .utf8) else { return nil }
        guard let sealedBox = try? AES.GCM.seal(data, using: key) else { return nil }
        return sealedBox.combined?.base64EncodedString()
    }
    
    func decrypt(_ encryptedText: String) -> String? {
        guard let data = Data(base64Encoded: encryptedText),
              let sealedBox = try? AES.GCM.SealedBox(combined: data),
              let decryptedData = try? AES.GCM.open(sealedBox, using: key) else { return nil }
        return String(data: decryptedData, encoding: .utf8)
    }
}
