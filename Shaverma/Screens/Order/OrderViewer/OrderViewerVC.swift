//
//  OrderViewerVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class OrderViewerVC: UIViewController {

    private let viewModel: OrderViewerViewModel
    private let router: OrderViewerRouter
    private var subscriptions: Set<AnyCancellable> = []
    private let titleLabel = UILabel(
        text: "Заказ",
        font: .bold(20),
        textColor: .primaryBase,
        lines: 1,
        alignment: .center
    )
    private let numberCommentLabel = UILabel(
        text: "Номер заказа:",
        font: .medium(13),
        textColor: .primaryBase,
        lines: 1,
        alignment: .right
    )
    private let numberLabel = UILabel(
        text: "1213131",
        font: .bold(15),
        textColor: .primaryBase,
        lines: 1,
        alignment: .left
    )
    private lazy var numberStack = UIStackView(
        axis: .horizontal,
        spacing: 8,
        arrangedSubviews: [numberCommentLabel, numberLabel]
    )
    private let addressCommentLabel = UILabel(
        text: "Адрес:",
        font: .bold(16),
        textColor: .primaryBase,
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
    private let orderLabel = UILabel(
        text: "Заказ:",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 0,
        alignment: .left
    )
    lazy var tableView: ContentSizedTableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(OrderItemCell.self)
        $0.isScrollEnabled = false
        return $0
    }(ContentSizedTableView())

    private lazy var commonStack = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [
            UIView(),
            titleLabel,
            UIView(embed: numberStack){ $0.centerX.top.bottom.equalToSuperview() },
            addressCommentLabel,
            UIView(),
            addressLabel,
            UIView(height: 8),
            orderLabel,
            tableView
        ]
    )
    private lazy var scrollStack = ScrollStack(stack: commonStack)

    init(
        viewModel: OrderViewerViewModel,
        router: OrderViewerRouter
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

private extension OrderViewerVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [scrollStack].addOnParent(view: view)
    }

    func addConstraints() {
        scrollStack.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func bind() {
        viewModel.$order.sink { [weak self] resp in guard let self else { return }
            numberLabel.text = "\(resp.numberOrder)"
            addressLabel.text = resp.address
            orderLabel.text = "Заказ на сумму: \((resp.totalAmount/100).rubleString() ?? "")"
            title = "Заказ №\(resp.numberOrder)"
        }.store(in: &subscriptions)

        tableView.bind(viewModel.$items, cellType: OrderItemCell.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)
    }
}


final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize() }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + adjustedContentInset.top)
    }
}
