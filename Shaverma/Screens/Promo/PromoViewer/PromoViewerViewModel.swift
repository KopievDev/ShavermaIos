//
//  PromoViewerViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import Combine

final class PromoViewerViewModel {
    @Published
    var promo: PromoResponse

    init(promo: PromoResponse) {
        self.promo = promo
    }

    func viewDidLoad() {

    }
}
