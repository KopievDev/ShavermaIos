//
//  PromoViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import Combine

final class PromoViewModel {
    @Published
    var items: [PromoResponse] = []

    private let api = ShavermaAPI.shared

    func viewDidLoad() {
        Task { @MainActor in
            do {
                items = try await api.getPromos()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
