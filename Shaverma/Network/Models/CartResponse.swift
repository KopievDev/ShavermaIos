//
//  CartResponse.swift
//  Shaverma
//
//  Created by Иван Копиев on 18.04.2024.
//

import Foundation

struct CartResponse: Codable {
    let id: UUID
    let totalAmount: Decimal
    let products: [Item]

    struct Item: Codable {
        let id: UUID
        let price: Decimal
        let quantity: Int
        let product: ProductResponse
    }
}

struct CartRequest: Codable {
    let id: UUID
    let quantity: Int
}
