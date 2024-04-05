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
    
    var email: String = ""
    var password: String = ""

    func didTapContinue() {
        Task {
            do {
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
