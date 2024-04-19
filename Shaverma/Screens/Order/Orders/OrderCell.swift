//
//  OrderCell.swift
//  Shaverma
//
//  Created by Иван Копиев on 19.04.2024.
//

import UIKit
import CombineCocoa

final class OrderCell: BaseCell<OrderResponse> {

    private let numberLabel = UILabel(
        text: "-",
        font: .bold(15),
        textColor: .staticWhite,
        lines: 1,
        alignment: .left
    )
    private let amountLabel = UILabel(
        text: "-",
        font: .bold(15),
        textColor: .staticWhite,
        lines: 1,
        alignment: .right
    )
    private let addresstLabel = UILabel(
        text: "",
        font: .medium(13),
        textColor: .staticWhite,
        lines: 0,
        alignment: .left
    )
    private lazy var topStack = UIStackView(
        axis: .horizontal,
        spacing: 8,
        arrangedSubviews: [numberLabel, amountLabel]
    )
    private lazy var commonStack = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [topStack, addresstLabel]
    )
    private lazy var forview = UIView(embed: commonStack) { $0.edges.equalToSuperview().inset(16) }
        .backgroundColor(.primaryBase)
        .cornerRadius(16)

    override func commonInit() {
        setupUI()
    }

    override func render(viewModel: OrderResponse) {
        numberLabel.text = "№ \(viewModel.numberOrder)"
        amountLabel.text = "\((viewModel.totalAmount/Decimal(100)).rubleString() ?? "")"
        addresstLabel.text = viewModel.address
    }
}

private extension OrderCell {
    func setupUI() {
        backgroundColor(.clear).selectionStyle = .none
        [forview].addOnParent(view: contentView)
        forview.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
