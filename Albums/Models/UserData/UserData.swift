import Foundation

class UserData: Codable {
    var age: String
    var email: String
    var name: String
    var password: String
    var surname: String
    var phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case age
        case email
        case name
        case password
        case surname
        case phoneNumber
    }
    
     init(age: String, email: String, name: String, password: String, surname: String, phoneNumber: String) {
        self.age = age
        self.email = email
        self.name = name
        self.password = password
        self.surname = surname
        self.phoneNumber = phoneNumber
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(age, forKey: .age)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(password, forKey: .password)
        try container.encode(surname, forKey: .surname)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        age = try container.decode(String.self, forKey: .age)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        password = try container.decode(String.self, forKey: .password)
        surname = try container.decode(String.self, forKey: .surname)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
    }
}
