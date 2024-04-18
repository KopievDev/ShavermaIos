//
//  CartVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class CartVC: UIViewController {

    private let viewModel: CartViewModel
    private let router: CartRouter
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var tableView: UITableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(ProductCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 200, right: 0)
        $0.scrollsToTop = true
        $0.verticalScrollIndicatorInsets.top = 8
        return $0
    }(UITableView())
    private let amountCommentLabel = UILabel(
        text: "Сумма заказа",
        font: .regular(13),
        textColor: .primaryBase,
        lines: 1,
        alignment: .left
    )
    private let amountLabel = UILabel(
        text: "0 ₽",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 1,
        alignment: .right
    )
    private lazy var textStack = UIStackView(
        axis: .horizontal,
        spacing: 8,
        arrangedSubviews: [amountCommentLabel,amountLabel]
    )
    private let doneButton = Button(
        viewModel: .init(
            title: "Продолжить",
            backgroundColor: .orangeButton,
            textColor: .white,
            isEnabled: true,
            withAnimate: true,
            withAnimateColors: true,
            withHaptic: true,
            corners: .full
        )
    )
    private lazy var bottomStack = UIStackView(
        axis: .vertical,
        spacing: 16,
        arrangedSubviews: [textStack, doneButton]
    )
    private lazy var bottomForm = UIView(embed: bottomStack) {
        $0.top.left.right.equalToSuperview().inset(16)
        $0.bottom.equalToSuperview().inset(24)
    }.backgroundColor(.staticWhite).corners(.top)

    init(
        viewModel: CartViewModel,
        router: CartRouter
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

private extension CartVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [tableView, bottomForm].addOnParent(view: view)
        bottomForm.layer.shadowColor = UIColor.primaryBase.cgColor
        bottomForm.layer.shadowOpacity = 0.2
        bottomForm.layer.shadowRadius = 10
        bottomForm.layer.shadowOffset = CGSize(width: 0.0, height: -3)
        bottomForm.clipsToBounds = false
    }

    func addConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomForm.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func bind() {
        tableView.bindDiffable(viewModel.$items) { [unowned self] table, index, model in
            table.dequeueCell(ProductCell.self, index) { cell in
                cell.render(viewModel: model)
                cell.productAction = { product in
                    self.update(product: product)
                }
            }
        }.store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in guard let self else { return }
                $0 ? showLoader() : dismissLoader()
            }.store(in: &subscriptions)

        viewModel.$amount.sink { [weak self] amount in guard let self else { return }
            amountLabel.text = amount
        }.store(in: &subscriptions)
    }
    
    func update(product: ProductResponse) {
        guard let index = viewModel.items.firstIndex(where: { $0.id == product.id }) else { return }
        if product.count == nil || product.count == 0 {
            viewModel.items.remove(at: index)
        } else {
            viewModel.items[index] = product
        }
        CartStorage.shared.send(product: product, quantity: product.count)
    }
}
