//
//  ProfileViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit
import Combine

final class ProfileViewModel {
    
    @Published
    var cells: [MenuItem] = MenuItem.items
    
    func viewDidLoad() {

    }
}

struct MenuItem {
    let title: String
    let type: String
    let icon: Image?
}

extension MenuItem {
    static let items: [MenuItem] = [
        .init(title: "Мои данные", type: "myData", icon: .init(value: .chevroneRight, tint: .primaryBase)),
        .init(title: "Заказы", type: "ordrerd", icon: .init(value: .chevroneRight, tint: .primaryBase)),
        .init(title: "Адрес", type: "address", icon: .init(value: .chevroneRight, tint: .primaryBase)),
        .init(title: "Выйти", type: "logout", icon: .init(value: .chevroneRight, tint: .primaryBase)),
    ]
}

struct Image {
    let value: UIImage
    let tint: UIColor?
}
