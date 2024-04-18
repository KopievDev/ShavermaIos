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
    lazy var tableView: UITableView = {
        $0.backgroundColor(.staticWhite).separatorStyle = .none
        $0.register(ProductCell.self)
        $0.contentInset = .init(top: 8, left: 0, bottom: 76, right: 0)
        $0.scrollsToTop = true
        $0.verticalScrollIndicatorInsets.top = 8
        return $0
    }(UITableView())
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
        [tableView].addOnParent(view: view)
    }

    func addConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind() {
        tableView.bind(viewModel.$items, cellType: ProductCell.self) { [unowned self] index, model, cell in
            cell.render(viewModel: model)
            cell.productAction = { product in
                self.update(product: product)
            }
        }.store(in: &subscriptions)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in guard let self else { return }
                $0 ? showLoader() : dismissLoader()
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
