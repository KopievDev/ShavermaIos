//
//  OrderResponse.swift
//
//
//  Created by Иван Копиев on 19.04.2024.
//

import Vapor
import Foundation
import SwiftOpenAPI
import VaporToOpenAPI

@OpenAPIDescriptable()
/// Объект корзины
struct OrderResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Номер заказа
    let numberOrder: Int
    /// Адрес
    let address: String
    /// Продукты
    let products: [OrderItemResponse]
    /// Общая сумма
    let totalAmount: Decimal

    static var example: OrderResponse = .init(
        id: .generateRandom(),
        numberOrder: 123,
        address: "Рязановское шоссе, 23, Москва, Россия, 108802",
        products: [OrderItemResponse.example, OrderItemResponse.example],
        totalAmount: 79600
    )
}

@OpenAPIDescriptable()
/// Объект корзины
struct OrderItemResponse: Content, WithExample {
    /// id
    let id: UUID
    /// Продукт
    let product: ProductsResponse
    /// Кол-во шт
    let quantity: Int
    /// Общая сумма
    let price: Decimal

    static var example: OrderItemResponse = .init(
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
/// Запрос на оформление заказа
struct OrderRequest: Content, WithExample {
    /// Способ оплаты (cash/card)
    let payment: String

    static var example: OrderRequest = .init(payment: "card")
}

extension OrderResponse {
    func orderMessage(payment: String, user: User) -> String {
"""
Новый заказ № \(numberOrder)
Адрес: \(address)
Клиент: \(user.familyName ?? "") \(user.name) \(user.phone ?? "") \(user.email)
\(products.map {"\($0.product.id) \($0.product.name) - \($0.quantity)шт (\($0.price.rubles.rubleString() ?? ""))"}.joined(separator: "\n"))
Сумма заказа: \(totalAmount.rubles.rubleString() ?? "")
Оплата: \(payment == "card" ? "Картой курьеру":"Наличными курьеру")
"""
    }
}

extension Decimal {

    var rubles: Decimal {
        self/100.0
    }


    /**
     Ruble formatted string

     For 1000 exponent is equal to 3 (10^3), output: "1 000 ₽"

     For 123 (123.0 either) exponent is equal to 0, output: "123 ₽"

     For 10.123 exponent is equal to -3, output: "10,12 ₽"

     For 0 (0.0 either) exponent equal -1, output: "0 ₽"
     */
    func rubleString() -> String? {
        NumberFormatter.rubles.minimumFractionDigits = (self.isZero || self.exponent >= 0) ? 0 : 2
        return NumberFormatter.rubles.string(for: self)
    }

    /**
     Amount formated string without currency symbol

     For 1000 exponent is equal to 3 (10^3), output: "1 000"

     For 123 (123.0 either) exponent is equal to 0, output: "123"

     For 10.123 exponent is equal to -3, output: "10,12"

     For 0 (0.0 either) exponent equal -1, output: "0"
     */
    func amountString() -> String? {
        NumberFormatter.currencyNoSymbol.minimumFractionDigits = (self.isZero || self.exponent >= 0) ? 0 : 2
        return NumberFormatter.currencyNoSymbol.string(for: self)?.trimmingCharacters(in: .whitespaces)
    }

    func editingAmountString() -> String? {
        var digits = 2
        /// If user typed "10,7" there is no need to show "10,70" at the moment
        if self.exponent == -1 {
            digits = 1
        }
        if self.exponent >= 0 || self.isZero {
            digits = 0
        }
        NumberFormatter.currencyNoSymbol.minimumFractionDigits = digits
        return NumberFormatter.currencyNoSymbol.string(for: self)?.trimmingCharacters(in: .whitespaces)
    }
}

extension NumberFormatter {
    static var rubles: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru-Ru")
        formatter.currencyGroupingSeparator = "\u{202f}" /// narrow non-breaking space
        return formatter
    }()

    static var currencyNoSymbol: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru-Ru")
        formatter.currencySymbol = ""
        formatter.groupingSeparator = "\u{202f}" /// narrow non-breaking space
        return formatter
    }()
}
