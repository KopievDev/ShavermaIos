//
//  MainViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 02.04.2024.
//

import Combine
import UIKit

final class MainViewModel {
    let vcs: [WithTable]

    @Published
    var promos: [PromoResponse] = []

    private let api = ShavermaAPI.shared

    init(vcs: [WithTable]) {
        self.vcs = vcs
    }
    
    func viewDidLoad() {
        loadPromos()
    }

    func loadPromos() {
        Task { @MainActor in
            do {
                promos = try await api.getPromos()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
