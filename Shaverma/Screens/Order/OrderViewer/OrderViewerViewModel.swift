//
//  OrderViewerViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import Combine

final class OrderViewerViewModel {
    @Published
    var order: OrderResponse

    init(order: OrderResponse) {
        self.order = order
    }
    
    func viewDidLoad() {

    }
}
