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
        // - UUID (i.e. every store of the brand)
        // - major (i.e. identify which specific store is in that UUID)
        // - minor (i.e. identify which specific location of the store is in that UUID of that major)
        // - identifier: is just human readable text
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        // To start monitor a iBeacon region you must call this method at least once
        locationManager?.startMonitoring(for: beaconRegion)
        // Start to send notifications detecting the iBeacon
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.distanceReading.textColor = .white
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.distanceReading.textColor = .black
                
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.distanceReading.textColor = .white
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.distanceReading.textColor = .white
                
            }
        }
    }
    
    // Act on notifications sent by startRangingBeacons()
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // If found at least one beacon update the view with its relative distance
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            // if not found draw the initial style of the view
            update(distance: .unknown)
        }
    }

}

