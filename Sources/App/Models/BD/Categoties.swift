//
//  Categoties.swift
//
//
//  Created by Иван Копиев on 01.04.2024.
//

import Foundation
import Fluent
import Vapor

final class Categoties: Model, Content {
    static let schema = "categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
