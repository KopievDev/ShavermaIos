//
//  CartStorage.swift
//  Shaverma
//
//  Created by Иван Копиев on 18.04.2024.
//

import Foundation

final class CartStorage {

    static let shared: CartStorage = .init()

    @Published
    var cartResponse: CartResponse?

    private let api = ShavermaAPI.shared

    private init() { }
    
    func start() {
        Task { @MainActor in 
            cartResponse = try? await api.getCart()
        }
    }
    
    func send(product: ProductResponse, quantity: Int?) {
        Task { @MainActor in
            do {
                cartResponse = try await api.putCart(model: .init(id: product.id, quantity: quantity ?? 0))
            } catch {
                Toast.with(viewModel: .init(title: error.localizedDescription, state: .danger))
            }
        }
    }

    func logout() {
        cartResponse = nil
    }
}
