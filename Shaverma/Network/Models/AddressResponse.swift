//
//  AddressResponse.swift
//  Shaverma
//
//  Created by Иван Копиев on 16.04.2024.
//

import UIKit
import MapKit

struct AddressResponse: Codable {
    let text: String
    let latitude: Double
    let longitude: Double
}

extension AddressResponse {
    
    func imageSnapshot(mapSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let mapView = MKMapView(frame: CGRect(origin: .zero, size: mapSize))
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.centerCoordinate = coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        options.size = mapView.frame.size
        options.scale = UIScreen.main.scale

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, error) in
            guard let snapshot = snapshot else {
                if let error = error {
                    print("Ошибка при создании снимка карты: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            // Рисуем изображение с аннотацией на снимке карты
            let image = drawAnnotationImage(on: snapshot, with: coordinate)
            completion(image)
        }
    }

    private func drawAnnotationImage(on snapshot: MKMapSnapshotter.Snapshot, with coordinate: CLLocationCoordinate2D) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
        snapshot.image.draw(at: .zero)

        let point = snapshot.point(for: coordinate)
        let pinImage = UIImage.mapPin // Изображение метки (пина) для аннотации
        pinImage.draw(at: point)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
