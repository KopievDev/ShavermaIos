//
//  Product.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

struct Product: Codable {
    let id: UUID
    let name: String
    let desc: String
    let price: Decimal
    let imageUrl: String?

    var count: Int?

    init(id: UUID = .init(), name: String, desc: String, price: Decimal, imageUrl: String?, count: Int? = nil) {
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.imageUrl = imageUrl
        self.count = count
    }
}

extension Product {
    static let shaverma: [Product] = [
        .init(
            name: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            name: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            name: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            name: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            name: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
    ]

    static let zakuson: [Product] = [
        .init(
            name: "Картошка ФРИИ",
            desc: "Освободи картоху, чтобы не было плохо",
            price: 15900,
            imageUrl: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            name: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            name: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            imageUrl: "https://mustdev.ru/vkr/sh2.png"
        ),
        ]

    static let drinks: [Product] = [
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        ]

    static let sauses: [Product] = [
        .init(
            name: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            name: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            name: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            name: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            name: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            imageUrl: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        ]
}
