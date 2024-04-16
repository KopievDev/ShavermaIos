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
    private let imageView = UIImageView()
        .clipsToBounds(true)
        .cornerRadius(16)
        .contentMode(.scaleAspectFill)

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

    func set(image: UIImage?) {
        imageView.image = image
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
        view.gesture().sink {  [weak self] _ in guard let self else { return }
            router.routeToSomeScreen() 
        }.store(in: &subscriptions)
    }

    func addSubviews() {
        [imageView].addOnParent(view: view)
    }

    func addConstraints() {
        imageView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(16)
            $0.height.equalTo(134)
        }
    }

    func bind() {

    }
}
