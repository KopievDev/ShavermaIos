//
//  ScrollStack.swift
//  Shaverma
//
//  Created by Иван Копиев on 17.04.2024.
//

import UIKit
import SnapKit
import Combine

final class ScrollStack: Component {

    // MARK: - Public -
    var keyboardDismissMode: UIScrollView.KeyboardDismissMode {
        get { scrollView.keyboardDismissMode }
        set { scrollView.keyboardDismissMode = newValue }
    }

    var contentOffset: CGPoint {
        get { scrollView.contentOffset }
        set { scrollView.contentOffset = newValue }
    }

    var contentInset: UIEdgeInsets {
        get { scrollView.contentInset }
        set { scrollView.contentInset = newValue }
    }

    var isLayoutMarginsRelativeArrangementForStack: Bool {
        get { stack.isLayoutMarginsRelativeArrangement }
        set { stack.isLayoutMarginsRelativeArrangement = newValue }
    }

    var stackLayoutMargins: UIEdgeInsets {
        get { stack.layoutMargins }
        set { stack.layoutMargins = newValue }
    }

    var delegate: UIScrollViewDelegate? {
        get { scrollView.delegate }
        set { scrollView.delegate = newValue }
    }
    var alwaysBounceVertical: Bool {
        get { scrollView.alwaysBounceVertical }
        set { scrollView.alwaysBounceVertical = newValue }
    }

    var pullToRefreshAction: VoidBlock?
    // MARK: - UI -
    private let scrollView = UIScrollView()
        .backgroundColor(.clear)
    private let refreshControl = UIRefreshControl()
    private let contentView = UIView()
        .backgroundColor(.clear)

    private let stack: UIStackView
    private let viewModel: ViewModel
    private var subscriptions: Set<AnyCancellable> = []

    init(
        viewModel: ViewModel = .init(),
        stack: UIStackView
    ) {
        self.stack = stack
        self.viewModel = viewModel
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("Not implement")
    }

    func scrollDown() {
        let bottomOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
        )
        scrollView.setContentOffset(bottomOffset, animated: true)
    }

    func finishRefreshing() {
        guard viewModel.isRefreshable else { return }
        refreshControl.endRefreshing()
    }

    override func setupUI() {
         scrollView.alwaysBounceVertical = true
         [scrollView].addOnParent(view: self)
         if viewModel.isRefreshable {
             refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
             scrollView.refreshControl = refreshControl
         }
         [contentView].addOnParent(view: scrollView)
         [stack].addOnParent(view: contentView)

         scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
         contentView.snp.makeConstraints { $0.top.bottom.left.right.width.equalToSuperview() }
         stack.snp.makeConstraints { $0.edges.equalToSuperview() }
     }

    override func bind() {
         viewModel.$showsVerticalScrollIndicator
             .assign(to: \.showsVerticalScrollIndicator, on: scrollView)
             .store(in: &subscriptions)
         viewModel.$corners
             .sink { [unowned self] val in corners(val) }
             .store(in: &subscriptions)
     }
}

private extension ScrollStack {


    @objc
    private func refreshAction() {
        pullToRefreshAction?()
    }
}

// MARK: - ViewModel -
extension ScrollStack {
    class ViewModel {
        @Published
        public var corners: Corners
        @Published
        var showsVerticalScrollIndicator = false
        let isRefreshable: Bool

        public init(
            showsVerticalScrollIndicator: Bool = false,
            corners: Corners = .none,
            isRefreshable: Bool = false
        ) {
            self.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            self.corners = corners
            self.isRefreshable = isRefreshable
        }
    }
}
