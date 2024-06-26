//
//  AuthViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 04.04.2024.
//

import Combine

final class AuthViewModel {
    
    enum ActionType {
        case successLogin
        case error(Toast.ViewModel)
    }
    
    let actions = PassthroughSubject<ActionType, Never>()
    
    private let api = ShavermaAPI.shared
    @Published var isLoading = false
    var email: String = ""
    var password: String = ""
    
    func viewDidLoad() {
//        api.token = "BcIkbdtotygaMU2DlbQf2w=="
        api.logout()
    }

    func categories() async throws -> [Category] {
        try await ShavermaAPI.shared.categories()
    }

    func didTapContinue() {
        Task {
            do {
                isLoading = true
                defer { isLoading = false }
                let response = try await api.login(email: email, password: password)
                api.token = response.token
                actions.send(.successLogin)
            } catch {
                actions.send(
                    .error(
                        .init(
                            title: error.localizedDescription,
                            state: .danger,
                            delay: 5,
                            haptic: .warning
                        )
                    )
                )
            }
        }
    }
}
