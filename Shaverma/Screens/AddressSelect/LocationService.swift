//
//  LocationService.swift
//  Shaverma
//
//  Created by Иван Копиев on 15.04.2024.
//


import Foundation
import CoreLocation

public protocol LocationService: AnyObject {
    func location() async throws -> CLLocation
}


final class DefaultLocationService: NSObject, LocationService {
    
    enum LocationError: Error {
        case notDetermined
        case emptyLocations
    }
    
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<(CLLocation), Error>?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func location() async throws -> CLLocation {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied: 
            locationContinuation?.resume(throwing: LocationError.notDetermined)
        default: break
        }
        return try await withCheckedThrowingContinuation { locationContinuation = $0 }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: LocationError.emptyLocations)
            return
        }
        locationContinuation?.resume(returning: location)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        locationContinuation?.resume(throwing: error)
    }
}
