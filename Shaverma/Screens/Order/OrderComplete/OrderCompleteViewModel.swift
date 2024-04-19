//
//  OrderCompleteViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import Combine

final class OrderCompleteViewModel {

    @Published
    var order: OrderResponse

    init(order: OrderResponse) {
        self.order = order
    }

    func viewDidLoad() {
        CartStorage.shared.start()
    }
}
