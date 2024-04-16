//
//  AdressShowViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 16.04.2024.
//

import Combine

final class AdressShowViewModel {
    private let api = ShavermaAPI.shared

    @Published var address: AddressResponse?

    func viewWillAppear() {
        loadAddress()
    }

    func loadAddress() {
        Task {
            do {
                address = try await api.getAdrress()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


