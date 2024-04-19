//
//  AddressSelectViewModel.swift
//  VeLo Player
//
// Created by Иван Копиев on 05.04.2024.
//

import Combine
import Foundation
import CoreLocation


final class AddressSelectViewModel: NSObject {
    enum Flow { case back, tabbar }
    let flow: Flow
    @Published
    var address: String? = "-"
    @Published
    var appartament: String?
    @Published
    var isLoading: Bool = false
    private var coordinate: CLLocationCoordinate2D?

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let api = ShavermaAPI.shared
    
    init(flow: Flow = .back) {
        self.flow = flow
    }
    
    func viewDidLoad() {

    }

    func saveAddress() async throws -> AddressResponse {
        guard let coordinate, let address else { throw NSError(domain: "Проверьте вводимые данные", code: -1) }

        let request: AddressResponse = .init(
            text: address + ", кв. \(appartament ?? "")",
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        isLoading = true
        defer { isLoading = false }
        return try await api.saveAdrress(request)
    }

    func getCurrentLocation() -> CLLocation? {
        locationManager.location
    }

    func categories() async throws -> [Category] {
        try await api.categories()
    }

    func getAddress(for coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        // Выполняем геокодирование координат для получения адреса
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] (placemarks, error) in
            guard let self else { return }
            if let error = error {
                print("Ошибка геокодирования: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first else {
                print("Адрес не найден")
                return
            }
            // Отображаем адрес аннотации в алерте
            address = formatAddress(from: placemark)
        }
    }

    private func formatAddress(from placemark: CLPlacemark) -> String {
        [
            placemark.country,
            placemark.administrativeArea,
            placemark.subLocality,
            placemark.name,
            placemark.postalCode
        ].compactMap { $0 }.joined(separator: ", ")
    }

}
