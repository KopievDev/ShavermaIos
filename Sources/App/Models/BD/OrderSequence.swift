//
//  File.swift
//  
//
//  Created by Иван Копиев on 19.04.2024.
//

import Vapor
import Fluent

final class OrderSequence: Model, Content {
    static let schema = "order_sequences"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "current_order_number")
    var currentOrderNumber: Int

    init() { }

    init(id: UUID? = nil, currentOrderNumber: Int) {
        self.id = id
        self.currentOrderNumber = currentOrderNumber
    }
}

extension OrderSequence {
    struct Migration: AsyncMigration {
        var name: String { "AddOrderSequence" }

        func prepare(on database: Database) async throws {
            try await database.schema(OrderSequence.schema)
                .id()
                .field("current_order_number", .int, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(OrderSequence.schema).delete()
        }
    }
}
