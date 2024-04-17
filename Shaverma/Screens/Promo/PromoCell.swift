//
//  PromoCell.swift
//  Shaverma
//
//  Created by Иван Копиев on 17.04.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class PromoCell: BaseCell<PromoResponse> {

    private let imgView = UIImageView()
        .contentMode(.scaleAspectFill)
        .clipsToBounds(true)
        .cornerRadius(16)

    private var subscriptions: Set<AnyCancellable> = []

    override func commonInit() {
        setupUI()
        bind()
    }

    override func render(viewModel: PromoResponse) {
        imgView.load(urlString: viewModel.imageUrl)
    }
}

private extension PromoCell {
    func setupUI() {
        selectionStyle = .none
        [imgView].addOnParent(view: contentView)
        imgView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(imgView.snp.width).multipliedBy(0.472)
        }
    }

    func bind() {

    }
}
