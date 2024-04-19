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

protocol Validator {
    func didEnter(text: String) -> Bool?
}

final class TextField: Component {

    private let textfield = UITextField()

    let textPublisher = CurrentValueSubject<String, Never>("")

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
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.textColor = .primaryBase
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

        viewModel.$keyboardType
            .sink { [weak self] keyboardType in guard let self else { return }
                textfield.keyboardType = keyboardType
            }.store(in: &subscriptions)
        viewModel.$textContentType
            .sink { [weak self] textContentType in guard let self else { return }
                textfield.textContentType = textContentType
            }.store(in: &subscriptions)

        viewModel.$placeholder
            .sink { [weak self] placeholder in guard let self else { return }
                textfield.attributedPlaceholder = NSAttributedString(
                    string: placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
                )
            }.store(in: &subscriptions)

        textfield.textPublisher.sink { [weak self] text in guard let self else { return }
            textPublisher.send(text)
            if let validator = viewModel.validator {
                render(isValid: validator.didEnter(text: text))
            }
        }.store(in: &subscriptions)
    }

    func set(text: String) {
        textfield.text = text
    }

    func render(isValid: Bool?) {
        UIView.animate(withDuration: 0.3) { [self] in
            guard let isValid else {
                layer.borderWidth = 0
                return
            }
            if isValid {
                layer.borderWidth = 2
                layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.5).cgColor
            } else {
                layer.borderWidth = 2
                layer.borderColor = UIColor.systemRed.withAlphaComponent(0.5).cgColor
            }
        }
    }
}

extension TextField {
    class ViewModel {
        @Published
        var placeholder: String?
        @Published
        var isSecureTextEntry: Bool = false
        @Published
        var keyboardType: UIKeyboardType
        @Published
        var textContentType: UITextContentType?

        var validator: Validator?

        init(
            placeholder: String? = nil,
            isSecureTextEntry: Bool = false,
            validator: Validator? = nil,
            keyboardType: UIKeyboardType = .default,
            textContentType: UITextContentType? = nil
        ) {
            self.placeholder = placeholder
            self.isSecureTextEntry = isSecureTextEntry
            self.validator = validator
            self.keyboardType = keyboardType
            self.textContentType = textContentType
        }
    }
}
struct EmailValidator: Validator {

    func didEnter(text: String) -> Bool? {
        guard !text.isEmpty else { return nil }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: text)

    }
}

struct PhoneValidator: Validator {

    func didEnter(text: String) -> Bool? {
        guard !text.isEmpty else { return nil }
        let phoneRegex = #"^\+?\d{1,3}[- ]?\(?\d{3}\)?[- ]?\d{3}[- ]?\d{2}[- ]?\d{2}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: text)
    }
}

struct NameValidator: Validator {

    func didEnter(text: String) -> Bool? {
        guard !text.isEmpty else { return nil }
        // Пример регулярного выражения для валидации имени
        let nameRegex = "^[A-Za-zА-Яа-я]+(?: [A-Za-zА-Яа-я]+)*$" // Простая проверка на буквы и пробелы
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: text)
    }
}

struct PassValidator: Validator {

    func didEnter(text: String) -> Bool? {
        guard !text.isEmpty else { return nil }
        return text.count >= 8
    }
}
