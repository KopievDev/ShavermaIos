//
//  Product.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import Foundation

struct Product: Codable {
    let title: String
    let desc: String
    let price: Decimal
    let img: String

    var count: Int?
}

extension Product {
    static let shaverma: [Product] = [
        .init(
            title: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            title: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            title: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            title: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "Шаурма",
            desc: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            title: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
    ]

    static let zakuson: [Product] = [
        .init(
            title: "Картошка ФРИИ",
            desc: "Освободи картоху, чтобы не было плохо",
            price: 15900,
            img: "https://mustdev.ru/vkr/sh1.png"
        ),
        .init(
            title: "Шаурма Блэк АНУС",
            desc: "Один раз не пид*рас, попробуй темный лаваш",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        .init(
            title: "НормШава",
            desc: "Для нормальных пацанов",
            price: 19900,
            img: "https://mustdev.ru/vkr/sh2.png"
        ),
        ]

    static let drinks: [Product] = [
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        ]

    static let sauses: [Product] = [
        .init(
            title: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            img: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            img: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            title: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            img: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            img: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            title: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            img: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        .init(
            title: "Лимонад Айсти",
            desc: "Холодный, как сердце твоей бывшей",
            price: 10000,
            img: "https://mustdev.ru/vkr/drink1.png"
        ),
        .init(
            title: "Горячий",
            desc: "Жгучий соус для вкусной картохи",
            price: 10000,
            img: "https://mustdev.ru/vkr/sous.jpeg"
        ),
        ]
}
