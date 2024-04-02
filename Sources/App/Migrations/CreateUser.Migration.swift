//
//  CreateUser.swift
//  
//
//  Created by Иван Копиев on 31.03.2024.
//

import Fluent
import Vapor

extension User {
    struct Migration: AsyncMigration {
        var name: String { "CreateUser" }

        func prepare(on database: Database) async throws {
            try await database.schema(User.schema)
                .id()
                .field("name", .string, .required)
                .field("family_name", .string, .required)
                .field("phone", .string, .required)
                .field("email", .string, .required)
                .field("password", .string, .required)
                .unique(on: "email")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(User.schema).delete()
        }
    }
}


extension User {
    struct AddRoleMigration: AsyncMigration {
        var name: String { "AddRoleToUser" }

        func prepare(on database: Database) async throws {
            try await database.schema(User.schema)
                .field("role", .string)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database.schema(User.schema).deleteField("role").update()
        }
    }
}
