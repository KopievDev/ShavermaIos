//
//  OrdersVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 19.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class OrdersVC: UIViewController {

    private let viewModel: OrdersViewModel
    private let router: OrdersRouter
    private var subscriptions: Set<AnyCancellable> = []
    lazy var tableView: UITableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(OrderCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 76, right: 0)
        $0.scrollsToTop = true
        $0.delegate = self
        $0.verticalScrollIndicatorInsets.top = 8
        $0.refreshControl = refreshControl
        return $0
    }(UITableView())
    private let refreshControl = UIRefreshControl()
    private let emptyView = EmptyView(
        viewModel: .init(icon: .box, title: "Заказы отсутствуют")
    ).alpha(0)

    init(
        viewModel: OrdersViewModel,
        router: OrdersRouter
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

private extension OrdersVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        view.backgroundColor(.staticWhite)
    }

    func addSubviews() {
        [tableView, emptyView].addOnParent(view: view)
    }

    func addConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        emptyView.snp.makeConstraints {
            $0.left.right.centerY.equalToSuperview()
        }
    }

    func bind() {
        tableView.bind(viewModel.$orders, cellType: OrderCell.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)

        viewModel.$orders
            .map(\.isEmpty)
            .sink { [weak self] isEmpty in guard let self else { return }
                UIView.animate(withDuration: 0.2) {
                    self.emptyView.alpha(isEmpty ? 1:0)
                }
        }.store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in guard let self else { return }
                $0 ? showLoader() : dismissLoader()
                if $0 { refreshControl.endRefreshing() } 
            }.store(in: &subscriptions)

        refreshControl
            .publisher(for: .valueChanged)
            .sink(unownedObject: self) { vc, _ in
                vc.viewModel.viewDidLoad()
            }.store(in: &subscriptions)
    }
}

extension OrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = viewModel.orders[indexPath.row]
        router.routeTo(order: order)
    }
}
