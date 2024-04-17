//
//  PromoViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import Combine

final class PromoViewModel {
    @Published
    var items: [PromoResponse] = [
        .init(id: .init(), title: "efef", desc: "wefw", imageUrl: "https://mustdev.ru/vkr/promo1.png"),
        .init(id: .init(), title: "wefwfe", desc: "wefwef", imageUrl: "https://mustdev.ru/vkr/15promo.png"),
        .init(id: .init(), title: "wefwef", desc: "wefwef", imageUrl: "https://mustdev.ru/vkr/freedelivery.png"),
    ]

    func viewDidLoad() {

    }
}
