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
        return $0
    }(UITableView())
    
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
        [tableView].addOnParent(view: view)
    }

    func addConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind() {
        tableView.bind(viewModel.$orders, cellType: OrderCell.self) { index, model, cell in
            cell.render(viewModel: model)
        }.store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in guard let self else { return }
                $0 ? showLoader() : dismissLoader()
            }.store(in: &subscriptions)
    }
}

extension OrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = viewModel.orders[indexPath.row]
        router.routeTo(order: order)
    }
}
