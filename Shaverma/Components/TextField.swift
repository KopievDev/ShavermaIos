//
//  TextField.swift
//  Shaverma
//
//  Created by Иван Копиев on 04.04.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class TextField: Component {

    private let textfield = UITextField()
    
    let viewModel: ViewModel
    private var subscriptions: Set<AnyCancellable> = []

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError(.notImplememt)
    }

    override func setupUI() {
        cornerRadius(16).backgroundColor(.disabledButton)
        [textfield].addOnParent(view: self)

        textfield.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(4)
        }
        snp.makeConstraints {
            $0.height.equalTo(52)
        }
    }

    override func bind() {
        viewModel.$isSecureTextEntry
            .sink { [weak self] isSec in guard let self else { return }
                textfield.isSecureTextEntry = isSec
            }.store(in: &subscriptions)

        viewModel.$placeholder
            .sink { [weak self] placeholder in guard let self else { return }
                textfield.placeholder = placeholder
            }.store(in: &subscriptions)

    }
}

extension TextField {
    class ViewModel {
        @Published
        var placeholder: String?
        @Published
        var isSecureTextEntry: Bool = false

    }
}
