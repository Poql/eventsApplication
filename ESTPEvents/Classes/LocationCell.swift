//
//  LocationCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit
import MapKit

private struct Constant {
    static let latitudeDelta: CLLocationDegrees = 0.001
    static let longitudeDelta: CLLocationDegrees = 0.001
    static let mapViewCornerRadius: CGFloat = 3
    static let mapViewBorderWidth: CGFloat = 0.5
}

class LocationCell: UITableViewCell, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Public

    func configure(location location: Location?) {
        titleLabel.text = location?.title
        subtitleLabel.text = location?.subtitle
        mapView.delegate = self
        mapView.userInteractionEnabled = false
        mapView.layer.cornerRadius = Constant.mapViewCornerRadius
        mapView.layer.borderWidth = Constant.mapViewBorderWidth
    }

    func configure(locationCoordinate coordinate: CLLocationCoordinate2D?) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = coordinate {
            mapView.alpha = 1
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            let span = MKCoordinateSpan(latitudeDelta: Constant.latitudeDelta, longitudeDelta: Constant.longitudeDelta)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.addAnnotation(pin)
            mapView.setCenterCoordinate(coordinate, animated: false)
            mapView.setRegion(region, animated: false)
            return
        }
        mapView.alpha = 0
    }

    // MARK: - MKMapViewDelegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.pinTintColor = .lightBlue()
        view.setSelected(true, animated: true)
        view.animatesDrop = true
        return view
    }

    // MARK: - Private

    private func setupView() {
        titleLabel.font = UIFont.mediumMainFont(ofSize: 15)
        subtitleLabel.font = UIFont.regularMainFont(ofSize: 15)
    }
}
