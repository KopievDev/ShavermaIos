//
//  Products.swift
//
//
//  Created by Иван Копиев on 01.04.2024.
//

import Fluent
import Vapor

final class Products: Model, Content {
    static let schema = "products"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    @Field(key: "desc")
    var desc: String
    @Field(key: "price")
    var price: Decimal
    @Parent(key: "category_id")
    var category: Categoties

    @Parent(key: "user_id")
    var user: User

    init() { }

//    init(id: UUID? = nil, value: String, userID: User.IDValue) {
//        self.id = id
//        self.value = value
//        self.$user.id = userID
//    }
}

