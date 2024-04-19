//
//  RegistrationViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import Combine

final class RegistrationViewModel {

    enum ActionType {
        case error(String)
        case routeNext
    }
    let actionPublisher = PassthroughSubject<ActionType, Never>()

    var name: String?
    var familyName: String?
    var email: String?
    var phone: String?
    var password: String?
    var confirmPassword: String?
    @Published var isLoading = false

    private let api = ShavermaAPI.shared

    func viewDidLoad() {
        api.logout()
    }

    func categories() async throws -> [Category] {
        try await api.categories()
    }

    func didTapNextButton() {
        guard let name, let email, let familyName, let phone, let password, let confirmPassword, confirmPassword == password else {
            actionPublisher.send(.error("Проверьте заполняемые данные"))
            return
        }

        Task { @MainActor in
            do {
                isLoading = true
                defer { isLoading = false }
                let tokenResponse = try await api.register(
                    model: .init(
                        email: email,
                        familyName: familyName,
                        name: name,
                        password: password,
                        phone: phone.filter { $0.isNumber }
                    )
                )
                api.token = tokenResponse.token
                actionPublisher.send(.routeNext)
            } catch {
                actionPublisher.send(.error(error.localizedDescription))
            }
        }
    }

}
