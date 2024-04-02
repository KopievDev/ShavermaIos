//
//  Component.swift
//  VeLo Player
//
//  Created by Иван Копиев on 04.03.2024.
//

import UIKit

class Component: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implement")
    }

    func commonInit() {
        setupUI()
        bind()
    }

    func setupUI() {

    }

    func bind() {

    }
}
