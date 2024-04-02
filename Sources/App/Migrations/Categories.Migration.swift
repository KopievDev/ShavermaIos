//
//  Categories.Migration.swift
//  
//
//  Created by Иван Копиев on 01.04.2024.
//

import Foundation
import Fluent
import Vapor

extension Categoties {
    struct Migration: AsyncMigration {
        var name: String { "CreateCategoties" }

        func prepare(on database: Database) async throws {
            try await database.schema(Categoties.schema)
                .id()
                .field("name", .string, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Categoties.schema).delete()
        }
    }
}
