//
//  OrdersViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import Combine

final class OrdersViewModel {
    @Published var orders: [OrderResponse] = []
    @Published var isLoading = false
    private let api = ShavermaAPI.shared

    func viewDidLoad() {
        loadOrders()
    }

    func loadOrders() {
        Task { @MainActor in
            do {
                isLoading = true
                defer { isLoading = false }
                orders = try await api.orders()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
