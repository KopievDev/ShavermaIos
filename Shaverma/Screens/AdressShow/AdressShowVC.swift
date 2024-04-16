//
//  AdressShowVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 16.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class AdressShowVC: UIViewController {

    private let viewModel: AdressShowViewModel
    private let router: AdressShowRouter
    private var subscriptions: Set<AnyCancellable> = []
    private let addressTitleLabel = UILabel(
        text: "Адрес",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 1,
        alignment: .left
    )
    private let imageView = UIImageView(height: 134)
        .contentMode(.scaleAspectFill)
        .clipsToBounds(true)
        .cornerRadius(16)
    private let addressCommentLabel = UILabel(
        text: "Нажмите на карту, чтобы изменить текущий адрес.",
        font: .regular(9),
        textColor: .separator,
        lines: 0,
        alignment: .left
    )
    private let addressLabel = UILabel(
        text: "-",
        font: .regular(13),
        textColor: .primaryBase,
        lines: 0,
        alignment: .left
    )
    private lazy var bottomStack = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [
            UIView(),
            addressTitleLabel,
            imageView,
            addressCommentLabel,
            UIView(),
            addressLabel,
        ]
    )

    init(
        viewModel: AdressShowViewModel,
        router: AdressShowRouter
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

private extension AdressShowVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        imageView.isUserInteractionEnabled = true
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [bottomStack].addOnParent(view: view)
    }

    func addConstraints() {
        bottomStack.snp.makeConstraints {
            $0.left.right.top.equalToSuperview().inset(16)
        }
    }

    func bind() {
        viewModel.$address
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.addressLabel.text = $0.text
                $0.imageSnapshot(mapSize: .init(width: 400, height: 200)) { image in
                    self?.imageView.image = image
                }
            }.store(in: &subscriptions)

        imageView.gesture().sink { [weak self] _ in guard let self else { return }
            router.routeToChangeAddress()
        }.store(in: &subscriptions)
    }
}
