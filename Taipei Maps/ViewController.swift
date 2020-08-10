//
//  ViewController.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/8.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Cocoa
import MapKit
import CoreLocation


class ViewController: NSViewController, MKMapViewDelegate, NSSearchFieldDelegate {
    
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var mapsPopUpButton : NSPopUpButton!
    
    @IBOutlet var searchButton : NSButton!
    @IBOutlet var searchField : NSSearchField!
    
    @IBOutlet var placeButton : NSButton!
    @IBOutlet var myLocationButton : NSButton!
    
    @IBOutlet var messageView : NSView!
    @IBOutlet var messageLabel : NSTextField!
    @IBOutlet var messageIndicator : NSProgressIndicator!
    
    
    let siteCoordinate = CLLocationCoordinate2D(latitude: 25.046856, longitude: 121.516923) //台北車站
    let siteName = "台北車站"
    
    let mapTitles = ["公共飲水機", "自來水直飲臺",
                     "Taipei Free 熱點", "自行車停放區",
                     "垃圾清運點位", "行人清潔箱",
                     "台北市公廁", "新北市公廁"]
    
    let mapIDs    = ["waterDispenser", "tapWater",
                     "freeWifi", "bicycleParking",
                     "garbageTruck", "trashBin",
                     "tpToilet", "ntpcToilet" ]
    
    
    var myLocation = CLLocationCoordinate2D()
    var isMoveToUserLocation = true
    
    var currentSearchPlace : CLPlacemark?
    var currentSearchPlaceAnnotation : MKPointAnnotation?
    
    var showDataList : Array<Dictionary<String,Any>>?
    var showAnnotations = Array<MKAnnotation>()
    
    let tpApiFetchLimit  = 1000
    var tpApiFetchOffset = 0
    
    
    // MARK: - viewLoad
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Taipei Maps"
        
        var frame = self.view.window!.frame
        let initialSize = NSSize(width: 1000, height: 750)
        frame.size = initialSize
        self.view.window?.setFrame(frame, display: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchWaterDispenserData(datasetName: mapTitles[0])
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    // MARK: - Setup
    
    func setup() {
        // setup components
        setupMyLocation()
        setupMapsPopUpButton()
        setupSearchComponents()
        setupMessageViewComponents()
        
        // move to siteLocation
        moveToSiteLocation()
        
        // setup mapView
        mapView.showsUserLocation = true
    }
    
    func setupMyLocation() {
        // initial myLocation
        myLocation.latitude = siteCoordinate.latitude
        myLocation.longitude = siteCoordinate.longitude
        myLocationButton.title = "台北車站"
    }
    
    func setupMapsPopUpButton() {
        // clear
        mapsPopUpButton.removeAllItems()
        
        // add item
        for title in mapTitles {
            let str = "\(title)地圖"
            mapsPopUpButton.addItem(withTitle: str)
        }
        
        // select
        mapsPopUpButton.selectItem(at: 0)
    }
    
    func setupSearchComponents() {
        // search
        searchButton.title = "搜尋"
        searchField.placeholderString = "搜尋地址"
        
        // place
        placeButton.title = "標記的位置"
        placeButton.alphaValue = 0
    }

    func setupMessageViewComponents() {
        // view
        messageView.wantsLayer = true
        messageView.layer?.backgroundColor = NSColor.systemBlue.cgColor
        
        // label
        messageLabel.textColor = NSColor.white
        messageLabel.stringValue = ""
        
        // indicator
        if let filter = CIFilter(name: "CIColorControls") {
            filter.setDefaults()
            filter.setValue(1, forKey: "inputBrightness")
            messageIndicator.contentFilters = [filter]
            stopMessageIndicator()
        }
        
        // hide
        messageView.alphaValue = 0
    }
    
    // MARK: - Site Location
    
    func moveToSiteLocation() {
        let viewRegion = MKCoordinateRegion(center: siteCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
    }
    
    
    // MARK: - MKMapView Delegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location {
            print("緯度:\(location.coordinate.latitude), 經度: \(location.coordinate.longitude)")
            
            /*
            self.myLocation.latitude = location.coordinate.latitude
            self.myLocation.longitude = location.coordinate.longitude
            
            if self.isMoveToUserLocation == true {
                self.isMoveToUserLocation = false
                let viewRegion = MKCoordinateRegion(center: self.myLocation,
                                                    latitudinalMeters: 3000,
                                                    longitudinalMeters: 3000)
                let adjustedRegion = mapView.regionThatFits(viewRegion)
                mapView.setRegion(adjustedRegion, animated: true)
                self.myLocationButton.title = "我的位置"
            }*/
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation.isMember(of: WaterDispenserAnnotation.self) {
            var annoView = mapView.dequeueReusableAnnotationView(withIdentifier: "waterDispenserAnnotationView") as? WaterDispenserAnnotationView
            if annoView == nil {
                annoView = WaterDispenserAnnotationView(annotation: annotation, reuseIdentifier: "waterDispenserAnnotationView")
            }
            
            let anno = annotation as! WaterDispenserAnnotation
            setMapAnnotationView(annoView, annotation: anno)
            setCalloutViewWith(annotationView: annoView, attributedString: anno.infoToAttributedString())
            
            return annoView
        }
        else if annotation.isMember(of: TapWaterAnnotation.self) {
            var annoView = mapView.dequeueReusableAnnotationView(withIdentifier: "tapWaterAnnotationView") as? TapWaterAnnotationView
            if annoView == nil {
                annoView = TapWaterAnnotationView(annotation: annotation, reuseIdentifier: "tapWaterAnnotationView")
            }
            
            let anno = annotation as! TapWaterAnnotation
            setMapAnnotationView(annoView, annotation: anno)
            setCalloutViewWith(annotationView: annoView, attributedString: anno.infoToAttributedString())
            
            return annoView
        }
        else if annotation.isMember(of: FreeWifiAnnotation.self) {
            var annoView = mapView.dequeueReusableAnnotationView(withIdentifier: "freeWifiAnnotationView") as? FreeWifiAnnotationView
            if annoView == nil {
                annoView = FreeWifiAnnotationView(annotation: annotation, reuseIdentifier: "freeWifiAnnotationView")
            }
            
            let anno = annotation as! FreeWifiAnnotation
            setMapAnnotationView(annoView, annotation: anno)
            setCalloutViewWith(annotationView: annoView, attributedString: anno.infoToAttributedString())
            
            return annoView
        }
        
        return nil
    }
    
    
    // MARK: - MapAnnotationView / Detail Callout View
    
    func setMapAnnotationView(_ annotationView: TpMapAnnotationView?, annotation: TpMapAnnotation) {
        annotationView?.image      = annotation.image
        annotationView?.coordinate = annotation.coordinate
        annotationView?.info       = annotation.info
        
        weak var weakSelf = self
        annotationView?.selectedAction = { coordinate in
            weakSelf?.selectedAnnotation(annotation, coordinate: coordinate)
        }
    }
    
    func setCalloutViewWith(annotationView: MKAnnotationView?, attributedString: NSAttributedString) {
        annotationView?.detailCalloutAccessoryView = detailLabelWith(attributedString: attributedString)
        annotationView?.canShowCallout = true
        annotationView?.leftCalloutOffset  = CGPoint(x: -4, y: -27)
        annotationView?.rightCalloutOffset = CGPoint(x: 4, y: -27)
    }
    
    
    func detailLabelWith(attributedString: NSAttributedString) -> NSTextField {
        let label = NSTextField(labelWithAttributedString: attributedString)
        
        let labelWidth : CGFloat = 300
        let labelHeight = label.cell!.cellSize(forBounds: NSRect(x: 0, y: 0,
                                                                 width: labelWidth,
                                                                 height: CGFloat(Float.greatestFiniteMagnitude))).height
        
        label.frame = NSRect(x: 0, y: 0,
                             width: labelWidth,
                             height: (labelHeight + 10))
        
        return label
    }
    
    
    // MARK: - Selected Annotation
    
    func selectedAnnotation(_ annotation: MKAnnotation, coordinate: CLLocationCoordinate2D) {
        let moveToCoordinate = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                      longitude: coordinate.longitude)
        
        let viewRegion = MKCoordinateRegion(center: moveToCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
    }
    
    
    
    // MARK: - NSSearchField Delegate / NSTextField Delegate
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            print("<ENTER>")
            if control == searchField {
                searchPlace()
            }
            return true
        }
        return false
    }
    
    
    // MARK: - Search Place
    
    func searchPlace() {
        let keyword = searchField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        print("search keyword: \(keyword)。")
        
        removeCurrentSearchPlaceAnnotation()
        currentSearchPlace = nil
        placeButton.alphaValue = 0
        
        if keyword == "" {
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(keyword, in: nil, preferredLocale: nil) { placemarks, error in
            if let err = error {
                print("geocoder error: \(err.localizedDescription)")
                self.showGeocodeErrorAlert(keyword: keyword)
            } else {
                print("Placemarks: \(placemarks ?? [])")
                if let placemark = placemarks?[0] {
                    self.currentSearchPlace = placemark
                    self.moveToPlace()
                }
            }
        }
    }
    
    func removeCurrentSearchPlaceAnnotation() {
        if let annotation = currentSearchPlaceAnnotation {
            mapView.removeAnnotation(annotation)
            currentSearchPlaceAnnotation = nil
        }
    }
    
    func showGeocodeErrorAlert(keyword: String) {
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = "搜尋失敗"
        alert.informativeText = "搜尋的地址：\(keyword)"
        alert.alertStyle = .warning
        
        alert.beginSheetModal(for: self.view.window!, completionHandler: { modalResponse in
            print("modalResponse: \(modalResponse)")
        })
    }
    
    func moveToPlace() {
        if let place = currentSearchPlace, place.location != nil {
            let name = place.name ?? ""
            let country = place.country ?? ""
            let administrativeArea = place.administrativeArea ?? ""
            let subAdministrativeArea = place.subAdministrativeArea ?? ""
            let locality = place.locality ?? ""
            let subLocality = place.subLocality ?? ""
            let thoroughfare = place.thoroughfare ?? ""
            let subThoroughfare = place.subThoroughfare ?? ""
            
            print("name: \(name)")
            print("country: \(country)")
            print("administrativeArea: \(administrativeArea)")
            print("subAdministrativeArea: \(subAdministrativeArea)")
            print("locality: \(locality)")
            print("subLocality: \(subLocality)")
            print("thoroughfare: \(thoroughfare)")
            print("subThoroughfare: \(subThoroughfare)")
            
            let coordinate = CLLocationCoordinate2D(latitude: place.location!.coordinate.latitude,
                                                    longitude: place.location!.coordinate.longitude)
            
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000);
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            mapView.setRegion(adjustedRegion, animated: true)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            anno.title = "\(name)"
            anno.subtitle = "\(country)\(administrativeArea)\(subAdministrativeArea)\(locality)\(subLocality)\(thoroughfare)\(subThoroughfare)"
            
            mapView.addAnnotation(anno)
            mapView.selectAnnotation(anno, animated: true)
            
            currentSearchPlaceAnnotation = anno
            placeButton.alphaValue = 1
        }
    }
    
    
    // MARK: - MessageView / Indicator
    
    func startMessageIndicator() {
        messageIndicator.startAnimation(nil)
        messageIndicator.alphaValue = 1
    }
    
    func stopMessageIndicator() {
        messageIndicator.stopAnimation(nil)
        messageIndicator.alphaValue = 0
    }
    
    func showMessageView(message: String) {
        messageLabel.stringValue = message
        startMessageIndicator()
        messageView.alphaValue = 1
    }
    
    func dismissMessageView() {
        NSAnimationContext.runAnimationGroup({ _ in
            NSAnimationContext.current.duration = 0.25
            self.messageView.animator().alphaValue = 0
        }, completionHandler: {
            //done
            self.messageLabel.stringValue = ""
            self.stopMessageIndicator()
        })
    }
    
    
    // MARK: - IBAction
    
    @IBAction func pressedSearchButton(sender: NSButton) {
        searchPlace()
    }
    
    @IBAction func selectedMapsPopUpButton(sender: NSPopUpButton) {
        print("\(sender.titleOfSelectedItem ?? "") : \(sender.indexOfSelectedItem)")
        
        /*
         * "公共飲水機" : "waterDispenser",
         * "自來水直飲臺" : "tapWater",
         * "Taipei Free 熱點" : "freeWifi",
         * "自行車停放區" : "bicycleParking",
         * "垃圾清運點位" : "garbageTruck",
         * "行人清潔箱" : "trashBin",
         * "台北市公廁" : "tpToilet",
         * "新北市公廁" : "ntpcToilet"
         */
        
        let mapid = mapIDs[sender.indexOfSelectedItem]
        let name = mapTitles[sender.indexOfSelectedItem]
        
        switch mapid {
        case "waterDispenser":
            fetchWaterDispenserData(datasetName: name)
        case "tapWater":
            fetchTapWaterData(datasetName: name)
        case "freeWifi":
            fetchFreeWifiData(datasetName: name)
        case "bicycleParking":
            print("")
        case "garbageTruck":
            print("")
        case "trashBin":
            print("")
        case "tpToilet":
            print("")
        case "ntpcToilet":
            print("")
        default:
            break
        }
    }
    
    @IBAction func pressedMyLocationButton(sender: NSButton) {
        mapView.setCenter(myLocation, animated: true)
    }
    
    @IBAction func pressedPlaceButton(sender: NSButton) {
        if let place = currentSearchPlace, place.location != nil, currentSearchPlaceAnnotation != nil {
            let coordinate = CLLocationCoordinate2D(latitude: place.location!.coordinate.latitude,
                                                    longitude: place.location!.coordinate.longitude)
            
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1800, longitudinalMeters: 1800);
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            mapView.setRegion(adjustedRegion, animated: true)
            
            mapView.selectAnnotation(currentSearchPlaceAnnotation!, animated: true)
        }
    }
    
    
    // MARK: - Fetch Water Dispenser Data
    
    func fetchWaterDispenserData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        WaterDispenserDataset.fetch() { json in
            self.showDataList = nil
            
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.showDataList = results
            }
            
            self.showWaterDispenserMarkers()
            self.dismissMessageView()
        }
    }
    
    func showWaterDispenserMarkers() {
        guard let items = self.showDataList else { return }
        print("WaterDispenser count: \(items.count)")
        
        var annoArray = Array<WaterDispenserAnnotation>()
        
        for item in items {
            let latitude  = MyTools.doubleFrom(string: item["緯度"] as? String)
            let longitude = MyTools.doubleFrom(string: item["經度"] as? String)
            
            if latitude == 0 || longitude == 0 {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anno = WaterDispenserAnnotation(coordinate: coordinate)
            anno.image = NSImage(named: "wd_pin")
            anno.info = item
            
            annoArray.append(anno)
        }
        
        // clear Annotations
        mapView.removeAnnotations(showAnnotations)
        showAnnotations.removeAll()
        
        // add Annotations
        showAnnotations.append(contentsOf: annoArray)
        mapView.addAnnotations(showAnnotations)
    }
    
    
    // MARK: - Fetch Tap Water Data
    
    func fetchTapWaterData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        TapWaterDataset.fetch() { json in
            self.showDataList = nil
            
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.showDataList = results
            }
            
            self.showTapWaterMarkers()
            self.dismissMessageView()
        }
    }
    
    func showTapWaterMarkers() {
        guard let items = self.showDataList else { return }
        print("TapWater count: \(items.count)")
        
        var annoArray = Array<TapWaterAnnotation>()
        
        for item in items {
            let latitude : Double = MyTools.doubleFrom(string: item["緯度"] as? String)
            let longitude : Double = MyTools.doubleFrom(string: item["經度"] as? String)
            
            if latitude == 0 || longitude == 0 {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anno = TapWaterAnnotation(coordinate: coordinate)
            anno.image = NSImage(named: "water_pin")
            anno.info = item
            
            annoArray.append(anno)
        }
        
        // clear Annotations
        mapView.removeAnnotations(showAnnotations)
        showAnnotations.removeAll()
        
        // add Annotations
        showAnnotations.append(contentsOf: annoArray)
        mapView.addAnnotations(showAnnotations)
    }
    
    
    // MARK: - Fetch Free Wifi Data
    
    func fetchFreeWifiData(datasetName: String) {
        showMessageView(message: "正在下載 \(datasetName)資料集...")
        
        tpApiFetchOffset = 0
        self.showDataList = Array<Dictionary<String,Any>>()
        downloadFreeWifiDataset()
    }
    
    func downloadFreeWifiDataset() {
        FreeWifiDataset.fetch(limit: tpApiFetchLimit, offset: tpApiFetchOffset) { json in
            var resultsCount = 0
            
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.showDataList?.append(contentsOf: results)
                resultsCount = results.count
            }
            
            if resultsCount >= self.tpApiFetchLimit {
                self.tpApiFetchOffset += self.tpApiFetchLimit
                self.downloadFreeWifiDataset()
            }
            else {
                self.showFreeWifiMarkers()
                self.dismissMessageView()
            }
        }
    }
    
    func showFreeWifiMarkers() {
        guard let items = self.showDataList else { return }
        print("FreeWifi count: \(items.count)")
        
        var annoArray = Array<FreeWifiAnnotation>()
        
        for item in items {
            let latitude : Double = MyTools.doubleFrom(string: item["LATITUDE"] as? String)
            let longitude : Double = MyTools.doubleFrom(string: item["LONGITUDE"] as? String)
            
            if latitude == 0 || longitude == 0 {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anno = FreeWifiAnnotation(coordinate: coordinate)
            anno.image = NSImage(named: "wifi_pin2")
            anno.info = item
            
            annoArray.append(anno)
        }
        
        // clear Annotations
        mapView.removeAnnotations(showAnnotations)
        showAnnotations.removeAll()
        
        // add Annotations
        showAnnotations.append(contentsOf: annoArray)
        mapView.addAnnotations(showAnnotations)
    }
    
}

