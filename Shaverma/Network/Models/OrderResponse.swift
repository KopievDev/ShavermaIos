//
//  OrderResponse.swift
//  Shaverma
//
//  Created by Иван Копиев on 19.04.2024.
//

import Foundation

struct OrderResponse: Codable {
    let id: UUID
    let numberOrder: Int
    let address: String
    let totalAmount: Decimal
    let products: [Item]

    struct Item: Codable {
        let id: UUID
        let price: Decimal
        let quantity: Int
        let product: ProductResponse
    }
}

struct OrderRequest: Codable {
    let payment: String
}

extension OrderResponse {
    static let order = OrderResponse(id: .init(), numberOrder: 123, address: "Рязановское шоссе, 23, Москва, Россия, 108802", totalAmount: 199900, products: [
        .init(id: .init(), price: 19900, quantity: 2, product: .init(name: "Шава", desc: "", price: 19900, imageUrl: "")),
        .init(id: .init(), price: 19900, quantity: 2, product: .init(name: "Сок", desc: "", price: 19900, imageUrl: "")),
        .init(id: .init(), price: 19900, quantity: 2, product: .init(name: "Петушок", desc: "", price: 19900, imageUrl: "")),
        .init(id: .init(), price: 19900, quantity: 2, product: .init(name: "Носок", desc: "", price: 19900, imageUrl: "")),
        .init(id: .init(), price: 19900, quantity: 2, product: .init(name: "Картошка фрии", desc: "", price: 19900, imageUrl: "")),
    ])

}
