//
//  CartResponse.swift
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
struct CartResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Продукты
    let products: [CartItemResponse]
    /// Общая сумма
    let totalAmount: Decimal

    static var example: CartResponse = .init(
        id: .generateRandom(),
        products: [CartItemResponse.example, CartItemResponse.example],
        totalAmount: 79600
    )
}
