//
//  MKPointAnnotation.swift
//  Shaverma
//
//  Created by Иван Копиев on 16.04.2024.
//
import UIKit
import MapKit

extension MKPointAnnotation {

    func imageSnapshot(mapSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let mapView = MKMapView(frame: CGRect(origin: .zero, size: mapSize))
        mapView.centerCoordinate = coordinate

        mapView.addAnnotation(self)

        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        options.size = mapView.frame.size
        options.scale = UIScreen.main.scale

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { [weak self] (snapshot, error) in
            guard let self else { return }
            guard let snapshot = snapshot else {
                if let error = error {
                    print("Ошибка при создании снимка карты: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            // Рисуем изображение с аннотацией на снимке карты
            let image = self.drawAnnotationImage(on: snapshot, with: coordinate)
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
