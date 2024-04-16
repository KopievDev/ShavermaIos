//
//  PromoVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class PromoVC: UIViewController {

    private let viewModel: PromoViewModel
    private let router: PromoRouter
    private var subscriptions: Set<AnyCancellable> = []

    init(
        viewModel: PromoViewModel,
        router: PromoRouter
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

private extension PromoVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {

    }

    func addConstraints() {

    }

    func bind() {

    }
}
