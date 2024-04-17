//
//  TextCell.swift
//  Shaverma
//
//  Created by Иван Копиев on 17.04.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

struct TextCellViewModel {
    let value: String
    let desc: String
}

final class TextCell: BaseCell<TextCellViewModel> {

    private let titleLabel = UILabel(
        font: .regular(13),
        textColor: .darkGray,
        lines: 0,
        alignment: .left
    )

    private let descLabel = UILabel(
        font: .bold(14),
        textColor: .primaryBase,
        lines: 3,
        alignment: .left
    )
    private lazy var textStack = UIStackView(
        axis: .vertical,
        spacing: 4,
        arrangedSubviews: [titleLabel, descLabel]
    )

    private var subscriptions: Set<AnyCancellable> = []

    override func commonInit() {
        setupUI()
    }

    override func render(viewModel: TextCellViewModel) {
        titleLabel.text = viewModel.desc
        descLabel.text = viewModel.value
    }
}

private extension TextCell {
    func setupUI() {
        selectionStyle = .none
        [textStack].addOnParent(view: contentView)
        textStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
