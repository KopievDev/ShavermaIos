//
//  AddressSelectScreen.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit

struct AddressSelectScreen: Screen {

    let addressImageBlock: ((UIImage?) -> Void)?

    let flow: AddressSelectViewModel.Flow

    init(flow: AddressSelectViewModel.Flow = .back, addressImageBlock: ((UIImage?) -> Void)? = nil) {
        self.flow = flow
        self.addressImageBlock = addressImageBlock
    }

    func build() -> AddressSelectVC {
        let viewModel = AddressSelectViewModel(flow: flow)
        let router = AddressSelectRouter()
        let vc = AddressSelectVC(viewModel: viewModel, router: router, addressImageBlock: addressImageBlock)
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.titleView = UILabel(
            text: "Укажите адрес",
            font: .bold(16),
            textColor: .staticWhite,
            lines: 0,
            alignment: .left
        )
        return vc
    }
}
