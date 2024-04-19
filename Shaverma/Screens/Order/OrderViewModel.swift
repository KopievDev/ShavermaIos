//
//  OrderViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import Combine

final class OrderViewModel {

    enum PaymentMethod: String {
        case card
        case cash
    }
    enum ActionType {
        case successOrder(OrderResponse)
        case error(Toast.ViewModel)
    }

    let actions = PassthroughSubject<ActionType, Never>()

    @Published
    var isLoading: Bool = false
    @Published
    var address: AddressResponse?

    var paymentMethod: PaymentMethod = .card
    private let api = ShavermaAPI.shared

    func viewWillAppear() {
        loadAddress()
    }

    func loadAddress() {
        Task {
            do {
                isLoading = true
                defer { isLoading = false }
                address = try await api.getAdrress()
            } catch {
                actions.send(.error(.init(title: error.localizedDescription, state: .danger)))
            }
        }
    }

    func didTapOrder() {
        Task { @MainActor in
            do {
                isLoading = true
                defer { isLoading = false }
                let order = try await api.order(model: .init(payment: paymentMethod.rawValue))
                actions.send(.successOrder(order))
            } catch {
                actions.send(.error(.init(title: error.localizedDescription, state: .danger)))
            }
        }
    }
}
