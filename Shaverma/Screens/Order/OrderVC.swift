//
//  OrderVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class OrderVC: UIViewController {

    private let viewModel: OrderViewModel
    private let router: OrderRouter
    private var subscriptions: Set<AnyCancellable> = []
    private let addressTitleLabel = UILabel(
        text: "Куда доставить",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 1,
        alignment: .left
    )
    private let imageView = UIImageView(height: 134)
        .backgroundColor(.secondaryText)
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
    private let paymentLabel = UILabel(
        text: "Способ оплаты",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 1,
        alignment: .left
    )
    private let cardButton = Button(
        viewModel: .init(
            title: "Картой при получении",
            backgroundColor: .orangeButton,
            textColor: .white,
            isEnabled: true,
            withAnimate: true,
            withAnimateColors: true,
            withHaptic: true,
            corners: .full
        )
    ).with(tag: 0)
    private let cashButton = Button(
        viewModel: .init(
            title: "Наличными курьеру",
            backgroundColor: .disabledButton,
            textColor: .white,
            isEnabled: true,
            withAnimate: true,
            withAnimateColors: true,
            withHaptic: true,
            corners: .full
        )
    ).with(tag: 1)
    private lazy var paymentStack = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [cardButton, cashButton]
    )
    private lazy var commonStack = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [
            UIView(),
            addressTitleLabel,
            imageView,
            addressCommentLabel,
            UIView(),
            addressLabel,
            UIView(height: 8),
            paymentLabel,
            UIView(embed: paymentStack) {
                $0.left.right.equalToSuperview().inset(24)
                $0.top.bottom.equalToSuperview().inset(8)
            }
        ]
    )
    private lazy var scrollStack = ScrollStack(stack: commonStack)
    private let orderButton = Button(
        viewModel: .init(
            title: "Оформить заказ",
            backgroundColor: .orangeButton,
            textColor: .white,
            isEnabled: true,
            withAnimate: true,
            withAnimateColors: true,
            withHaptic: true,
            corners: .full
        )
    )

    init(
        viewModel: OrderViewModel,
        router: OrderRouter
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

private extension OrderVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
        imageView.isUserInteractionEnabled = true
    }

    func addSubviews() {
        [scrollStack, orderButton].addOnParent(view: view)
    }

    func addConstraints() {
        scrollStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        orderButton.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
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

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in guard let self else { return }
                $0 ? showLoader() : dismissLoader()
            }.store(in: &subscriptions)

        cardButton.tapPublisher.sink { [weak self] in guard let self else { return }
            paymentStack
                .arrangedSubviews
                .compactMap { $0 as? Button }
                .forEach { $0.viewModel.backgroundColor = $0.tag == 0 ? .orangeButton : .disabledButton  }
            viewModel.paymentMethod = .card
        }.store(in: &subscriptions)

        cashButton.tapPublisher.sink { [weak self] in guard let self else { return }
            paymentStack
                .arrangedSubviews
                .compactMap { $0 as? Button }
                .forEach { $0.viewModel.backgroundColor = $0.tag == 1 ? .orangeButton : .disabledButton }
            viewModel.paymentMethod = .cash
        }.store(in: &subscriptions)

        orderButton.tapPublisher
            .sink { [weak self] in self?.viewModel.didTapOrder() }
            .store(in: &subscriptions)

        viewModel.actions.sink { [weak self] action in guard let self else { return }
            switch action {
            case .successOrder(let orderResponse):
                router.routeToComplete(order: orderResponse)
            case .error(let viewModel):
                Toast.with(viewModel: viewModel)
            }
        }.store(in: &subscriptions)
    }
}
