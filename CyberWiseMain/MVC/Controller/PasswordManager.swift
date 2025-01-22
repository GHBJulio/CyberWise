import Foundation

class PasswordManager: ObservableObject {
    @Published private(set) var passwords: [PasswordEntry] = []
    private let encryptionHelper = EncryptionHelper()
    
    init() {
        loadPasswords()
    }
    
    func addPassword(title: String, password: String, username: String) {
        guard let encryptedPassword = encryptionHelper.encrypt(password) else { return }
        let entry = PasswordEntry(id: UUID(), title: title, username: username, encryptedPassword: encryptedPassword)
        passwords.append(entry)
        savePasswords()
    }
    
    func updatePassword(entryId: UUID, newPassword: String) {
        if let index = passwords.firstIndex(where: { $0.id == entryId }) {
            passwords[index].encryptedPassword = encryptionHelper.encrypt(newPassword) ?? ""
            savePasswords()
        }
    }
    
    func deletePassword(entryId: UUID) {
        passwords.removeAll { $0.id == entryId }
        savePasswords()
    }
    
    func decryptPassword(_ encryptedPassword: String) -> String? {
        return encryptionHelper.decrypt(encryptedPassword)
    }
    
    private func savePasswords() {
        if let data = try? JSONEncoder().encode(passwords) {
            UserDefaults.standard.set(data, forKey: "savedPasswords")
        }
    }
    
    func updatePasswordEntry(entryId: UUID, newTitle: String, newPassword: String?) {
            if let index = passwords.firstIndex(where: { $0.id == entryId }) {
                passwords[index].title = newTitle.isEmpty ? passwords[index].title : newTitle
                if let newPassword = newPassword {
                    passwords[index].encryptedPassword = encryptionHelper.encrypt(newPassword) ?? passwords[index].encryptedPassword
                }
                savePasswords()
            }
        }
    
    func loadPasswords() {
        if let data = UserDefaults.standard.data(forKey: "savedPasswords"),
           let savedPasswords = try? JSONDecoder().decode([PasswordEntry].self, from: data) {
            passwords = savedPasswords
        }
    }
}

struct PasswordEntry: Identifiable, Codable {
    let id: UUID
    var title: String
    let username: String
    var encryptedPassword: String
}
