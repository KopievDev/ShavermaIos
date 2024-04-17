//
//  ProfileViewerViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import Combine

final class ProfileViewerViewModel {
    enum ActionType {
        case error(String)
    }
    let actionPublisher = PassthroughSubject<ActionType, Never>()

    @Published var items: [TextCellViewModel] = []
    @Published var isLoading: Bool = false
    private let api = ShavermaAPI.shared

    func viewDidLoad() {
        Task { @MainActor in 
            do {
                isLoading = true
                defer { isLoading = false }
                items = try await api.getMe().items
            } catch {
                actionPublisher.send(.error(error.localizedDescription))
            }
        }
    }
}

private extension UserResponse {
    var items: [TextCellViewModel] {
        [
            .init(value: name, desc: "Имя"),
            .init(value: familyName, desc: "Фамилия"),
            .init(value: email, desc: "Почта"),
            .init(value: phone.formattedText(), desc: "Телефон"),
        ]
    }
}
