//
//  AddressSelectVC.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import UIKit
import MapKit
import Combine
import CombineCocoa
import CoreLocation
import MapKit

final class AddressSelectVC: UIViewController, MKMapViewDelegate {

    private let viewModel: AddressSelectViewModel
    private let router: AddressSelectRouter
    private var subscriptions: Set<AnyCancellable> = []
    private let mapView = MKMapView()

    private let addressTitleLabel = UILabel(
        text: "Адрес",
        font: .bold(16),
        textColor: .primaryBase,
        lines: 1,
        alignment: .left
    )
    private let addressLabel = UILabel(
        text: "-",
        font: .regular(13),
        textColor: .primaryBase,
        lines: 0,
        alignment: .left
    )

    let textField = TextField(
        viewModel: .init(
            placeholder: "Квартира",
            isSecureTextEntry: false,
            keyboardType: .numberPad
        )
    )
    private let doneButton = Button(
        viewModel: .init(
            title: "Готово",
            backgroundColor: .orangeButton,
            textColor: .white,
            isEnabled: true,
            withAnimate: true,
            withAnimateColors: true,
            withHaptic: true,
            corners: .full
        )
    )
    private lazy var bottomStack = UIStackView(
        axis: .vertical,
        spacing: 8,
        arrangedSubviews: [
            addressTitleLabel,
            addressLabel,
            textField,
            UIView(height: 52),
            doneButton
        ]
    )
    private lazy var bottomForm = UIView(embed: bottomStack) {
        $0.top.left.right.equalToSuperview().inset(16)
        $0.bottom.equalToSuperview().inset(24)
    }
        .backgroundColor(.staticWhite)
    private let addressImageBlock: ((UIImage?) -> Void)?
    let keyboard = KeyboardHeight()

    private let myGeoButton = UIButton(width: 52, height: 52)
        .withImage(.init(systemName: "location"))
        .backgroundColor(.systemPurple)
        .tintColor(.staticWhite)
        .cornerRadius(26)

    init(
        viewModel: AddressSelectViewModel,
        router: AddressSelectRouter,
        addressImageBlock: ((UIImage?) -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.router = router
        self.addressImageBlock = addressImageBlock
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
        showMe()
    }


    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        // Удаляем все существующие аннотации с карты
        mapView.removeAnnotations(mapView.annotations)

        // Получаем координаты точки нажатия на карту
        let locationInView = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

        // Создаем новую аннотацию на основе полученных координат
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate

        // Добавляем новую аннотацию на карту
        mapView.addAnnotation(annotation)
        annotation.imageSnapshot(mapSize: .init(width: 400, height: 200)) { [weak self] image in
            guard let self else { return }
            addressImageBlock?(image)
        }
        viewModel.getAddress(for: coordinate)
    }

    // Метод делегата MKMapViewDelegate для отображения кастомной аннотации (если необходимо)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "CustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            // Добавьте кастомизацию внешнего вида аннотации здесь (например, изображение)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    private func showErrorAlert(_ address: String) {
        let alert = UIAlertController(title: "Ошибка", message: address, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

private extension AddressSelectVC {
    func setupUI() {
        setupView()
        addSubviews()
        addConstraints()
    }

    func setupView() {
        mapView.delegate = self
        // Создание распознавателя жестов для отслеживания нажатий на карту
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    func addSubviews() {
        [mapView, bottomForm].addOnParent(view: view)
        [myGeoButton].addOnParent(view: mapView)
    }

    func addConstraints() {
        mapView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomForm.snp.top)
        }
        bottomForm.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
        myGeoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.right.equalToSuperview().inset(16)
        }
    }

    func bind() {
        myGeoButton.tapPublisher.sink { [weak self] in guard let self else { return }
            showMe()
        }.store(in: &subscriptions)

        keyboard.$visibleHeight
            .dropFirst()
            .sink { [weak self] keyboardVisibleHeight in guard let self else { return }
               bottomForm.snp.updateConstraints {
                   $0.bottom.equalToSuperview().inset(keyboardVisibleHeight)
               }
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
          }.store(in: &subscriptions)

        withCloseKeyboardWhenTap()
            .store(in: &subscriptions)

        viewModel.$address
            .assign(to: \.text, on: addressLabel)
            .store(in: &subscriptions)

        textField.textPublisher
            .sink { [weak self] in guard let self else { return }
                viewModel.appartament = $0
            }.store(in: &subscriptions)

        viewModel.$address.combineLatest(viewModel.$appartament)
            .sink { [weak self] address, appartement in guard let self else { return }
                doneButton.viewModel.isEnabled = address != "-" && (appartement?.isEmpty == false) && appartement != nil
            }.store(in: &subscriptions)

        doneButton.tapPublisher.sink { [weak self] in guard let self else { return }
            saveAddress()
        }.store(in: &subscriptions)
    }

    func saveAddress() {
        Task { @MainActor in
            do {
                let address = try await viewModel.saveAddress()
                router.goBack()
            } catch {
                showErrorAlert(error.localizedDescription)
            }
        }
    }

    func showMe() {
        Task {
            guard let userLocation = viewModel.getCurrentLocation() else { return }
            mapView.setCenter(userLocation.coordinate, animated: true)
            // Установка маркера на текущее местоположение
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation.coordinate
            annotation.title = "Текущее местоположение"
            mapView.addAnnotation(annotation)
            // Зум к текущему местоположению с определенным масштабом
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}
