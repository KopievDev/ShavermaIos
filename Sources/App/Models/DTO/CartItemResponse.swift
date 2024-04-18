//
//  CartItemResponse.swift
//
//
//  Created by Иван Копиев on 18.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Объект корзины
struct CartItemResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Продукт
    let product: ProductsResponse
    /// Кол-во шт
    let quantity: Int
    /// Общая сумма
    let price: Decimal

    static var example: CartItemResponse = .init(
        id: .generateRandom(),
        product: .init(
            id: .generateRandom(),
            name: "Шаурма",
            desc: "Сочная",
            imageUrl: "someUrk",
            price: 19900,
            category: .generateRandom()
        ),
        quantity: 2,
        price: 39800
    )
}

@OpenAPIDescriptable()
/// Запрос на изменение продукта
struct CartRequest: Content, WithExample {
    /// id Продукта
    let id: UUID
    /// Кол-во шт
    let quantity: Int

    static var example: CartRequest = .init(id: .generateRandom(), quantity: 1)
}
