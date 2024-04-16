//
//  Addresses.swift
//
//
//  Created by Иван Копиев on 16.04.2024.
//

import Foundation
import Fluent
import Vapor

final class Addresses: Model, Content {
    static let schema = "addresses"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "text")
    var text: String
    @Field(key: "latitude")
    var latitude: Double
    @Field(key: "longitude")
    var longitude: Double
    @Parent(key: "user_id")
    var user: User

    init() { }

    init(id: UUID? = nil, text: String, latitude: Double, longitude: Double, userID: User.IDValue) {
        self.id = id
        self.text = text
        self.latitude = latitude
        self.longitude = longitude
        self.$user.id = userID
    }
}

extension Addresses {

    var response: AddressResponse {
        .init(text: text, latitude: latitude, longitude: longitude)
    }
}


extension Addresses {
    struct Migration: AsyncMigration {
        var name: String { "CreateAddresses" }

        func prepare(on database: Database) async throws {
            try await database.schema(Addresses.schema)
                .id()
                .field("text", .string, .required)
                .field("latitude", .double, .required)
                .field("longitude", .double, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Addresses.schema).delete()
        }
    }
}
