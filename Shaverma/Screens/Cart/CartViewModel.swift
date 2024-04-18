//
//  CartViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import Combine

final class CartViewModel {
    @Published
    var cartResponse: CartResponse?
    @Published
    var items: [ProductResponse] = []
    @Published
    var isLoading: Bool = false
    private var subscriptions: Set<AnyCancellable> = []

    func viewDidLoad() {
        bind()
    }

    func bind() {
        CartStorage.shared.$cartResponse
            .compactMap { $0 }
            .sink { [weak self] resp in guard let self else { return }
            cartResponse = resp
            items = resp.products.compactMap { $0.product.with(count: $0.quantity) }
        }.store(in: &subscriptions)
    }
}
