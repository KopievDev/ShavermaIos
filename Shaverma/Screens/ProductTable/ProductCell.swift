//
//  ProductCell.swift
//  Shaverma
//
//  Created by Иван Копиев on 02.04.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

typealias ProductBlock = ((Product) -> Void)

final class ProductCell: BaseCell<Product> {

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
        alignment: .left
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

    private let selectButton = UIButton(
        text: "   Выбрать   ",
        font: .systemFont(ofSize: 15, weight: .bold),
        textColor: .staticWhite,
        backgroundColor: .orangeButton
    ).cornerRadius(15)
    private let deleteButton = UIButton(
        text: "-",
        font: .systemFont(ofSize: 15, weight: .bold),
        textColor: .staticWhite,
        backgroundColor: .orangeButton
    ).cornerRadius(15)
    private let plusButton = UIButton(
        text: "+",
        font: .systemFont(ofSize: 15, weight: .bold),
        textColor: .staticWhite,
        backgroundColor: .orangeButton
    ).size(width: 30).cornerRadius(15)
    private let countTextLabel = UILabel(
        text: "1",
        font: .systemFont(ofSize: 15, weight: .bold),
        textColor: .secondaryText,
        lines: 0,
        alignment: .center
    )
    private lazy var orderStack = UIStackView(
        axis: .horizontal,
        spacing: 8,
        arrangedSubviews: [
            deleteButton,
            countTextLabel,
            plusButton,
            selectButton
        ]
    ).size(height: 30)

    private lazy var priceStack = UIStackView(
        axis: .vertical,
        spacing: 4,
        arrangedSubviews: [priceLabel, countLabel]
    )

    @Published private var product: Product?
    var productAction: ProductBlock?

    private var subscriptions: Set<AnyCancellable> = []

    override func commonInit() {
        setupUI()
        bind()
    }

    override func render(viewModel: Product) {
        product = viewModel
    }
}

private extension ProductCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor(.clear)
        [formView].addOnParent(view: contentView)
        formView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.right.equalToSuperview().inset(16)
        }
        [imgView, textStack, priceStack, orderStack].addOnParent(view: formView)

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
            $0.bottom.equalTo(imgView.snp.bottom)
        }
        orderStack.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(priceStack.snp.centerY)
        }
    }

    func bind() {
        $product
            .compactMap { $0 }
            .sink { [weak self] product in guard let self else { return }
                titleLabel.text = product.name
                descLabel.text = product.desc
                imgView.load(urlString: product.imageUrl ?? "")
                priceLabel.text = (product.price/100).rubleString()
                if let count = product.count {
                    [deleteButton, countTextLabel, plusButton].forEach { $0.isHidden = false }
                    selectButton.isHidden = true
                    countTextLabel.text = "\(count)"
                } else {
                    [deleteButton, countTextLabel, plusButton].forEach { $0.isHidden = true }
                    selectButton.isHidden = false
                }
            }.store(in: &subscriptions)

        selectButton.tapPublisher.sink { [weak self] in guard let self else { return }
            Haptic.selection()
            product?.count = 1
            guard let product else { return }
            productAction?(product)
        }.store(in: &subscriptions)

        deleteButton.tapPublisher.sink { [weak self] in 
            guard let self, let count = product?.count else { return }
            Haptic.selection()
            if count == 1 {
                product?.count = nil
            } else if count > 1 {
                product?.count = count - 1
            }
            guard let product else { return }
            productAction?(product)
        }.store(in: &subscriptions)

        plusButton.tapPublisher.sink { [weak self] in
            Haptic.selection()
            guard let self, let count = product?.count else { return }
            product?.count = count + 1
            guard let product else { return }
            productAction?(product)
        }.store(in: &subscriptions)
    }
}

public extension Decimal {

    /**
     Ruble formatted string

     For 1000 exponent is equal to 3 (10^3), output: "1 000 ₽"

     For 123 (123.0 either) exponent is equal to 0, output: "123 ₽"

     For 10.123 exponent is equal to -3, output: "10,12 ₽"

     For 0 (0.0 either) exponent equal -1, output: "0 ₽"
     */
    func rubleString() -> String? {
        NumberFormatter.rubles.minimumFractionDigits = (self.isZero || self.exponent >= 0) ? 0 : 2
        return NumberFormatter.rubles.string(for: self)
    }

    /**
     Amount formated string without currency symbol

     For 1000 exponent is equal to 3 (10^3), output: "1 000"

     For 123 (123.0 either) exponent is equal to 0, output: "123"

     For 10.123 exponent is equal to -3, output: "10,12"

     For 0 (0.0 either) exponent equal -1, output: "0"
     */
    func amountString() -> String? {
        NumberFormatter.currencyNoSymbol.minimumFractionDigits = (self.isZero || self.exponent >= 0) ? 0 : 2
        return NumberFormatter.currencyNoSymbol.string(for: self)?.trimmingCharacters(in: .whitespaces)
    }

    func editingAmountString() -> String? {
        var digits = 2
        /// If user typed "10,7" there is no need to show "10,70" at the moment
        if self.exponent == -1 {
            digits = 1
        }
        if self.exponent >= 0 || self.isZero {
            digits = 0
        }
        NumberFormatter.currencyNoSymbol.minimumFractionDigits = digits
        return NumberFormatter.currencyNoSymbol.string(for: self)?.trimmingCharacters(in: .whitespaces)
    }
}

extension NumberFormatter {
    static var rubles: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru-Ru")
        formatter.currencyGroupingSeparator = "\u{202f}" /// narrow non-breaking space
        return formatter
    }()

    static var currencyNoSymbol: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru-Ru")
        formatter.currencySymbol = ""
        formatter.groupingSeparator = "\u{202f}" /// narrow non-breaking space
        return formatter
    }()
}
