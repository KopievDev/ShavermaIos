//
//  User.swift
//
//
//  Created by Иван Копиев on 31.03.2024.
//

import Vapor
import Fluent
import Foundation

enum Role: String, Codable {
    case admin, client
}

final class User: Model, Content {
    static var schema: String = "users"

    @ID(key: .id)
    var id: UUID?
    @Field(key: "email")
    var email: String
    @Field(key: "password")
    var password: String
    @Field(key: "name")
    var name: String
    @Field(key: "family_name")
    var familyName: String?
    @Field(key: "phone")
    var phone: String?
    @OptionalEnum(key: "role")
    var role: Role?

    required init() { }

    init(
        id: UUID? = nil,
        email: String,
        password: String,
        name: String,
        familyName: String? = nil,
        phone: String? = nil,
        role: Role? = nil
    ) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.familyName = familyName
        self.phone = phone
        self.role = role
    }
}

// MARK: - ModelAuthenticatable -
extension User: ModelAuthenticatable {

    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

// MARK: - UserToken generate -
extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: requireID()
        )
    }
}

// MARK: - Make Addresses -
extension User {
    func createAddress(_ model: AddressResponse) throws -> Addresses {
        try .init(
            id: .generateRandom(),
            text: model.text,
            latitude: model.latitude,
            longitude: model.longitude,
            userID: requireID()
        )
    }
}
