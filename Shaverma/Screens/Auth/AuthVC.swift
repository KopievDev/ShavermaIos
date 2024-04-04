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
        viewModel.viewDidLoad()
    }
}

private extension AuthVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {

    }

    func addSubviews() {

    }

    func addConstraints() {

    }

    func bind() {

    }
}
