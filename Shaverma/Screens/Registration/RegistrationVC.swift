//
//  RegistrationVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 17.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class RegistrationVC: UIViewController {

    private let viewModel: RegistrationViewModel
    private let router: RegistrationRouter
    private var subscriptions: Set<AnyCancellable> = []
    private let keyboard = KeyboardHeight()
    private let titleLabel = UILabel(
        text: "Шаурма на районе",
        font: .bold(20),
        textColor: .primaryBase,
        lines: 0,
        alignment: .center
    )
    private let mailTextfield = TextField(
        viewModel: .init(
            placeholder: "Почта",
            validator: EmailValidator()
        )
    )
    private let passTextfield = TextField(
        viewModel: .init(
            placeholder: "Пароль",
            isSecureTextEntry: true
        )
    )
    private let confirmPassTextfield = TextField(
        viewModel: .init(
            placeholder: "Повторите пароль",
            isSecureTextEntry: true
        )
    )
    private let phoneTextfield = TextField(
        viewModel: .init(
            placeholder: "Телефон",
            validator: PhoneValidator()
        )
    )
    private let nameTextfield = TextField(
        viewModel: .init(
            placeholder: "Имя",
            validator: NameValidator()
        )
    )
    private let secondNameTextfield = TextField(
        viewModel: .init(
            placeholder: "Фамилия",
            validator: NameValidator()
        )
    )
    private lazy var stack = UIStackView(
        axis: .vertical,
        spacing: 16,
        arrangedSubviews: [
            titleLabel,
            mailTextfield,
            passTextfield,
            confirmPassTextfield,
            phoneTextfield,
            nameTextfield,
            secondNameTextfield
        ]
    )
    private lazy var scrollStack = ScrollStack(stack: stack)

    private let button = Button(
        viewModel: .init(
            title: "Продолжить",
            backgroundColor: .orangeButton,
            textColor: .staticWhite,
            isEnabled: true,
            corners: .full
        )
    )

    init(
        viewModel: RegistrationViewModel,
        router: RegistrationRouter
    ) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.router.vc = self
    }

    required init?(coder: NSCoder) {
        fatalError("Not implement")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.viewDidLoad()
    }
}

private extension RegistrationVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [scrollStack, button].addOnParent(view: view)
    }

    func addConstraints() {
        scrollStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview().inset(16)
        }

        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }

    func bind() {
        phoneTextfield.textPublisher
            .sink { [weak self] text in guard let self else { return }
                phoneTextfield.set(text: text.formattedText())
                viewModel.phone = text.formattedText()
            }.store(in: &subscriptions)

        withCloseKeyboardWhenTap()
            .store(in: &subscriptions)

        keyboard.$visibleHeight
            .sink { [weak self] height in guard let self else { return }
                scrollStack.contentInset = .init(top: 16, left: 0, bottom: height, right: 0)
            }.store(in: &subscriptions)

        mailTextfield.textPublisher
            .sink { [weak self] text in guard let self else { return }
                viewModel.email = text
            }.store(in: &subscriptions)

        nameTextfield.textPublisher
            .sink { [weak self] text in guard let self else { return }
                viewModel.name = text
            }.store(in: &subscriptions)

        secondNameTextfield.textPublisher
            .sink { [weak self] text in guard let self else { return }
                viewModel.familyName = text
            }.store(in: &subscriptions)

        passTextfield.textPublisher
            .sink { [weak self] text in guard let self else { return }
                viewModel.password = text
            }.store(in: &subscriptions)

        confirmPassTextfield.textPublisher
            .sink { [weak self] text in guard let self else { return }
                viewModel.confirmPassword = text
            }.store(in: &subscriptions)

        viewModel.actionPublisher.sink { [weak self] action in
            guard let self else { return }
            switch action {
            case .error(let string):
                showAlert(message: string)
            case .routeNext:
               routeToTabBar()
            }
        }.store(in: &subscriptions)

        button.tapPublisher
            .sink { [weak self] in self?.viewModel.didTapNextButton() }
            .store(in: &subscriptions)
    }

    func routeToTabBar() {
        Task { @MainActor in
            do {
                let categories = try await viewModel.categories()
                router.routeToMain(categories: categories)
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
}


extension UIViewController {

    func showAlert(title: String = "Ошибка", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
