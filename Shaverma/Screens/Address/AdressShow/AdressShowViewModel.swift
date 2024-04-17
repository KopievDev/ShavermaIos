//
//  AdressShowViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 16.04.2024.
//

import Combine

final class AdressShowViewModel {
    private let api = ShavermaAPI.shared
    @Published
    var isLoading: Bool = false
    @Published 
    var address: AddressResponse?

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
                print(error.localizedDescription)
            }
        }
    }
}


