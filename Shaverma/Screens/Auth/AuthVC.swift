//
//  AuthVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 04.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class AuthVC: UIViewController {

    private let viewModel: AuthViewModel
    private let router: AuthRouter
    private var subscriptions: Set<AnyCancellable> = []
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
    private lazy var stack = UIStackView(
        axis: .vertical,
        spacing: 16,
        arrangedSubviews: [mailTextfield, passTextfield]
    )
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
        viewModel: AuthViewModel,
        router: AuthRouter
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
    }
}

private extension AuthVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor = .staticWhite
    }

    func addSubviews() {
        [titleLabel, stack, button].addOnParent(view: view)
    }

    func addConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.left.right.equalToSuperview().inset(16)
        }

        stack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-16)
            $0.left.right.equalToSuperview().inset(16)
        }
        button.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
    }

    func bind() {
        mailTextfield.textPublisher
            .sink { [weak self] email in self?.viewModel.email = email }
            .store(in: &subscriptions)

        passTextfield.textPublisher
            .sink { [weak self] pass in self?.viewModel.password = pass }
            .store(in: &subscriptions)

        viewModel.actions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handle(actions: $0) }
            .store(in: &subscriptions)

        withCloseKeyboardWhenTap()
            .store(in: &subscriptions)

        button.tapPublisher
            .sink { [weak self] in self?.viewModel.didTapContinue() }
            .store(in: &subscriptions)
    }

    func handle(actions: AuthViewModel.ActionType) {
        switch actions {
        case .successLogin:
            Task { @MainActor in
                let categories = try? await viewModel.categories()
                router.routeToMain(categories: categories ?? Category.categories)
            }
        case .error(let viewModel):
            Toast.with(viewModel: viewModel)
        }
    }
}
