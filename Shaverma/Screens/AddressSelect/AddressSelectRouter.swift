//
//  AddressSelectRouter.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

final class AddressSelectRouter: Router {
    weak var vc: AddressSelectVC?

    func goBack() {
        if let nav = vc?.navigationController {
            nav.popViewController(animated: true)
        } else {
            vc?.dismiss(animated: true)
        }
    }
}
