//
//  OrderItemCell.swift
//  Shaverma
//
//  Created by Иван Копиев on 19.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class OrderItemCell: BaseCell<OrderResponse.Item> {

    private let formView = UIView()
        .backgroundColor(.primaryBase)
        .cornerRadius(16)

    private let imgView = UIImageView(width: 120, height: 120)
        .contentMode(.scaleAspectFill)
        .clipsToBounds(true)
        .cornerRadius(16)

    private let titleLabel = UILabel(
        text: "Шаурма",
        font: .bold(16),
        textColor: .staticWhite,
        lines: 0,
        alignment: .left
    )

    private let descLabel = UILabel(
        text: "Самая вкусная на гриле!\nСвежий вкус для свежего дыхания",
        font: .regular(10),
        textColor: .secondaryText,
        lines: 3,
        alignment: .left
    )

    private let priceLabel = UILabel(
        text: "199 ₽",
        font: .systemFont(ofSize: 16, weight: .bold),
        textColor: .staticWhite,
        lines: 0,
        alignment: .right
    )

    private let countLabel = UILabel(
        text: "за шт.",
        font: .systemFont(ofSize: 11, weight: .regular),
        textColor: .secondaryText,
        lines: 0,
        alignment: .left
    )

    private lazy var textStack = UIStackView(
        axis: .vertical,
        spacing: 4,
        arrangedSubviews: [titleLabel, descLabel]
    )

    private lazy var priceStack = UIStackView(
        axis: .horizontal,
        spacing: 4,
        arrangedSubviews: [countLabel, priceLabel]
    )

    @Published private var product: OrderResponse.Item?

    private var subscriptions: Set<AnyCancellable> = []

    override func commonInit() {
        setupUI()
        bind()
    }

    override func render(viewModel: OrderResponse.Item) {
        product = viewModel
    }
}

private extension OrderItemCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor(.clear)
        [formView].addOnParent(view: contentView)
        formView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview()
        }
        [imgView, textStack, priceStack].addOnParent(view: formView)

        imgView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(16)
        }

        textStack.snp.makeConstraints {
            $0.left.equalTo(imgView.snp.right).offset(8)
            $0.top.right.equalToSuperview().inset(16)
            $0.bottom.lessThanOrEqualTo(priceStack.snp.top).inset(-8)
        }
        priceStack.snp.makeConstraints {
            $0.left.equalTo(imgView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(imgView.snp.bottom)
        }
    }

    func bind() {
        $product
            .compactMap { $0 }
            .sink { [weak self] item in guard let self else { return }
                titleLabel.text = item.product.name
                descLabel.text = item.product.desc
                imgView.load(urlString: item.product.imageUrl ?? "")
                priceLabel.text = (item.price/100).rubleString()
                countLabel.text =  "\(item.quantity) шт"
            }.store(in: &subscriptions)
    }
}

