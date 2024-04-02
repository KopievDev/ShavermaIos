//
//  MainVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 02.04.2024.
//

import UIKit
import Combine
import CombineCocoa

final class MainVC: UIViewController {

    private let viewModel: MainViewModel
    private let router: MainRouter
    private var subscriptions: Set<AnyCancellable> = []

    //Page
    @Published public var currentIndex: Int = 0
    @Published public var viewControllers: [UIViewController] = []
    private lazy var layout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        $0.itemSize = UIScreen.main.bounds.size
        $0.minimumLineSpacing = 0
        return $0
    }(UICollectionViewFlowLayout())
    private lazy var collectionView: UICollectionView = {
        $0.register(UICollectionViewCell.self)
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.bounces = false
        return $0
    }(UICollectionView(layout: layout))
    private let pageIndicator: PageIndicator

    //Slide
    private let titleLabel = UILabel(
        text: "Акции",
        font: .systemFont(ofSize: 16, weight: .bold),
        textColor: .staticWhite,
        lines: 0,
        alignment: .left
    )
    private let cardCollectionView = CardCollectionView()
    private lazy var stackView = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [titleLabel, cardCollectionView]
    )
    private let topContentView = UIView()
        .backgroundColor(.primaryBase)
    private let blindContentView = UIView()
        .backgroundColor(.clear)
    private var topHeight: CGFloat {
        topContentView.frame.height
    }
    private var minTopOffset: CGFloat {
        0
    }
    public lazy var topConstraint = blindContentView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: topHeight
    )
    private var previousContentOffsetY: CGFloat = 0
    weak var table: UITableView? {
        didSet {
            table?.delegate = self
        }
    }

    init(
        viewModel: MainViewModel,
        router: MainRouter
    ) {
        self.viewModel = viewModel
        self.router = router
        self.viewControllers = viewModel.vcs
        self.pageIndicator = PageIndicator(
            viewModel: .init(values: viewModel.vcs.map { .init(title: $0.category.name) } )
        )
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

private extension MainVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        title = "Меню"
        table = viewModel.vcs.first?.tableView
        view.backgroundColor = .primaryBase
        cardCollectionView.cards = [
            .banner, .banner, .banner, .banner, .banner
        ]
    }

    func addSubviews() {
        [topContentView, blindContentView].addOnParent(view: view)
        [stackView].addOnParent(view: topContentView)
        [pageIndicator, collectionView].addOnParent(view: blindContentView)
    }

    func addConstraints() {
        topContentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }

        blindContentView.snp.makeConstraints { $0.left.right.bottom.equalToSuperview() }
        
        pageIndicator.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(collectionView.snp.top)
        }

        collectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }

        view.layoutIfNeeded()
        topConstraint.isActive = true
    }

    func bind() {
        //Page
        collectionView
            .publisher(for: \.bounds)
            .dropFirst()
            .map(\.size)
            .receive(on: DispatchQueue.main)
            .assign(to: \.itemSize, on: layout)
            .store(in: &subscriptions)

        collectionView
            .bind($viewControllers, cellType: UICollectionViewCell.self) { _, vc, cell in cell.with(vc.view) }
            .store(in: &subscriptions)

        pageIndicator.selectedIndex
            .sink { [unowned self] index in set(index: index) }
            .store(in: &subscriptions)

        $currentIndex
            .dropFirst()
            .sink { [unowned self] index in
                pageIndicator.setSelect(index: index)
                table = viewModel.vcs[index].tableView
            }.store(in: &subscriptions)
    }

    func render(percent: CGFloat) {
        topContentView.alpha(1-percent)
    }

    func set(index: Int, animated: Bool = true) {
        guard index < viewControllers.count else { return }
        collectionView.scrollRectToVisible(
            .init(
                x: layout.itemSize.width * CGFloat(index),
                y: 0,
                width: collectionView.frame.width,
                height: collectionView.frame.height
            ),
            animated: animated
        )
        currentIndex = index
    }
}


extension MainVC: UITableViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetY = scrollView.contentOffset.y
        let scrollDiff = currentContentOffsetY - previousContentOffsetY

        // Верхняя граница начала bounce эффекта
        let bounceBorderContentOffsetY = -scrollView.contentInset.top

        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY

        let currentConstraintConstant = topConstraint.constant
        var newConstraintConstant = currentConstraintConstant

        if contentMovesUp {
            // Уменьшаем константу констрэйнта
            newConstraintConstant = max(currentConstraintConstant - scrollDiff, minTopOffset)
        } else if contentMovesDown {
            // Увеличиваем константу констрэйнта
            newConstraintConstant = min(currentConstraintConstant - scrollDiff, topHeight)
        }

        // Меняем высоту и запрещаем скролл, только в случае изменения константы
        if newConstraintConstant != currentConstraintConstant {
            topConstraint.constant = newConstraintConstant
            scrollView.contentOffset.y = previousContentOffsetY
        }

        // Процент завершения анимации
        let animationCompletionPercent = (topHeight - currentConstraintConstant) / (topHeight - minTopOffset)
        render(percent: animationCompletionPercent)
        previousContentOffsetY = scrollView.contentOffset.y
    }
}
extension MainVC: UIScrollViewDelegate, UICollectionViewDelegate {

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView is UICollectionView else { return }
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        if currentIndex != Int(roundedIndex) { Haptic.selection() }
        currentIndex = Int(roundedIndex)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }

}

public extension UICollectionViewCell {
    @discardableResult
    func with(_ view: UIView) -> Self {
        [view].addOnParent(view: contentView)
        view.snp.makeConstraints { $0.edges.equalToSuperview() }
        return self
    }
}
