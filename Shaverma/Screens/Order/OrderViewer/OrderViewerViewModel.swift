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
    @Published
    var items: [OrderResponse.Item]

    init(order: OrderResponse) {
        self.order = order
        self.items = order.products
    }
    
    func viewDidLoad() {

    }
}
