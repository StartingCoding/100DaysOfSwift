//
//  ViewController.swift
//  Project22
//
//  Created by Loris on 6/21/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconName: UILabel!
    @IBOutlet var circle: UIView!
    
    var isFirstDetection: Bool = false
    
//    let regions = [UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!,
//                   UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!,
//                   UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!]
    
    // Location Manager is the Manager that can managed the location of the device:
    // when the location changes notifies the delegate so it can act on it
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating the object "Location Manager"
        locationManager = CLLocationManager()
        // Setting the delegate of the LocationManager to be us (ViewController)
        locationManager?.delegate = self
        // Request authorization for always using location
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        distanceReading.textColor = .white
        circle.layer.cornerRadius = 128
    }
    
    // Act on verification status from requestAlwaysAuthorization()
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // If we are always authorized
        if status == .authorizedAlways {
            // if the device can detect iBeacons
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                // if the device can measure the distance from the beacon (ranging)
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        // Define iBeacon with:
        // - proximityUUID (UUID) (i.e. every store of the brand)
        // - major (i.e. identify which specific store is in that UUID)
        // - minor (i.e. identify which specific location of the store is in that UUID of that major)
        // - identifier: is just human readable text
        let uuidFirstBeacon = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let firstBeaconRegion = CLBeaconRegion(proximityUUID: uuidFirstBeacon, major: 123, minor: 456, identifier: "Beacon 1")

        // To start monitor a iBeacon region you must call this method at least once
        locationManager?.startMonitoring(for: firstBeaconRegion)
        // Start to send notifications detecting the iBeacon
        locationManager?.startRangingBeacons(in: firstBeaconRegion)
//
//        // Second iBeacon
//        let uuidSecondBeacon = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
//        let secondBeaconRegion = CLBeaconRegion(proximityUUID: uuidSecondBeacon, major: 123, minor: 456, identifier: "Beacon 2")
//
//        // To start monitor a iBeacon region you must call this method at least once
//        locationManager?.startMonitoring(for: secondBeaconRegion)
//        // Start to send notifications detecting the iBeacon
//        locationManager?.startRangingBeacons(in: secondBeaconRegion)
//
//        // Third iBeacon
//        let uuidThirdBeacon = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!
//        let thirdBeaconRegion = CLBeaconRegion(proximityUUID: uuidThirdBeacon, major: 123, minor: 456, identifier: "Beacon 3")
//
//        // To start monitor a iBeacon region you must call this method at least once
//        locationManager?.startMonitoring(for: thirdBeaconRegion)
//        // Start to send notifications detecting the iBeacon
//        locationManager?.startRangingBeacons(in: thirdBeaconRegion)
        
//        registerRegions()
    }
    
//    func registerRegions() {
//
//        for region in regions {
//            let beaconRegion = CLBeaconRegion(proximityUUID: region, major: 123, minor: 456, identifier: "MyBeacon")
//            locationManager?.startMonitoring(for: beaconRegion)
//            locationManager?.startRangingBeacons(in: beaconRegion)
//        }
//
//    }
    
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.beaconName.text = name
                self.circle.tintColor = .darkGray
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.beaconName.text = name
                self.circle.tintColor = .white
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.beaconName.text = name
                self.circle.tintColor = .darkGray
                self.circle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconName.text = name
                self.circle.tintColor = .darkGray
                self.circle.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                
            }
        }
    }
    
    // Act on notifications sent by startRangingBeacons()
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // If found at least one beacon update the view with its relative distance
        if let beacon = beacons.first {
            
            if isFirstDetection == false {
                firstDetection()
                isFirstDetection.toggle()
            }
            
            update(distance: beacon.proximity, name: beacon.proximityUUID.uuidString)
        } else {
            // if not found draw the initial style of the view
            update(distance: .unknown, name: "No Beacon")
        }
    }
    
    // When you first detect a beacon show a message
    func firstDetection() {
        let ac = UIAlertController(title: "MyBeacon Detected!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

