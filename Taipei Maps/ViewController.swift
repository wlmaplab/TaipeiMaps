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
    
    enum TpMapState {
        case taipei
        case newTaipei
    }
    
    enum ToiletCategory {
        case all
        case restroom
        case childroom
        case kindlyroom
    }
    
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var mapsPopUpButton : NSPopUpButton!
    
    @IBOutlet var searchButton : NSButton!
    @IBOutlet var searchField : NSSearchField!
    
    @IBOutlet var reloadButton : NSButton!
    @IBOutlet var placeButton : NSButton!
    @IBOutlet var myLocationButton : NSButton!
    
    @IBOutlet var messageView : NSView!
    @IBOutlet var messageLabel : NSTextField!
    @IBOutlet var messageIndicator : NSProgressIndicator!
    
    @IBOutlet var tpToiletSegmentedControl : NSSegmentedControl!
    @IBOutlet var descriptionBgView : NSView!
    @IBOutlet var descriptionLabel : NSTextField!
    @IBOutlet var recyclingInfoButton : NSButton!
    
    
    let taipeiSiteCoordinate = CLLocationCoordinate2D(latitude: 25.046856, longitude: 121.516923)  //台北車站
    let banqiaoSiteCoordinate = CLLocationCoordinate2D(latitude: 25.014349, longitude: 121.463756) //板橋車站
    let siteName = "台北車站"
    var mapState = TpMapState.taipei
    
    
    let mapTitles = ["公共飲水機", "自來水直飲臺",
                     "Taipei Free 熱點", "自行車停放區",
                     "垃圾清運點位", "行人清潔箱",
                     "台北市公廁", "新北市公廁",
                     "郵局營業據點"]
    
    let mapIDs    = ["waterDispenser", "tapWater",
                     "freeWifi", "bicycleParking",
                     "garbageTruck", "trashBin",
                     "tpToilet", "ntpcToilet",
                     "postOffices"]
    
    
    var waterDispenserList : Array<Dictionary<String,Any>>?
    var tapWaterList : Array<Dictionary<String,Any>>?
    
    var freeWifiList : Array<Dictionary<String,Any>>?
    var bicycleParkingList : Array<Dictionary<String,Any>>?
    
    var garbageTruckList : Array<Dictionary<String,Any>>?
    var trashBinList : Array<Dictionary<String,Any>>?
    
    var tpToiletList : Array<Dictionary<String,Any>>?
    var ntpcToiletList : Array<Dictionary<String,Any>>?
    var postOfficesList : Array<Dictionary<String,Any>>?
    
    
    var myLocation = CLLocationCoordinate2D()
    var hasUserLocation = false
    
    var currentSearchPlace : CLPlacemark?
    var currentSearchPlaceAnnotation : MKPointAnnotation?
    var showAnnotations = Array<MKAnnotation>()
    
    let tpApiFetchLimit  = 1000
    var tpApiFetchOffset = 0
    
    let ntpcApiFetchSize = 1000
    var ntpcApiFetchPage = 0
    
    var recyclingInfoWindowController : NSWindowController?
    var isViewComponentsSetupDone = false
    
    let placesSearcher = PlacesSearcher()
    
    
    // MARK: - viewLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        isViewComponentsSetupDone = false
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if isViewComponentsSetupDone == false {
            setup()
            isViewComponentsSetupDone = true
            loadDefaultMap()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        if let windowController = recyclingInfoWindowController {
            windowController.close()
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

    // MARK: - Load Default Map
    
    func loadDefaultMap() {
        if let mapid = SettingsHelper.readLastSelectedMapID(),
           let index = mapIDs.firstIndex(of: mapid)
        {
            print("read mapid: \(mapid), index: \(index)")
            mapsPopUpButton.selectItem(at: index)
            loadMapDataWith(index: index, isReload: true)
        } else {
            loadMapDataWith(index: 0, isReload: true)
        }
    }
    
    
    // MARK: - Setup
    
    func setup() {
        // setup components
        setupMapsPopUpButton()
        setupSearchComponents()
        setupMessageViewComponents()
        setupReloadButton()
        setupTpToiletSegmentedControl()
        setupDescriptionViewComponents()
        setupRecyclingInfoButton()
        
        // setup my location
        setupMyLocation()
        
        // move to siteLocation
        moveToSiteLocation()
        
        // setup mapView
        mapView.showsUserLocation = true
    }
    
    func setupMyLocation() {
        // initial myLocation
        switch mapState {
        case .taipei:
            myLocation.latitude  = taipeiSiteCoordinate.latitude
            myLocation.longitude = taipeiSiteCoordinate.longitude
            myLocationButton.title = "台北車站"
        case .newTaipei:
            myLocation.latitude  = banqiaoSiteCoordinate.latitude
            myLocation.longitude = banqiaoSiteCoordinate.longitude
            myLocationButton.title = "板橋車站"
        }
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
        placeButton.isHidden = true
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
    
    func setupReloadButton() {
        reloadButton.title = "重新整理"
    }
    
    func setupTpToiletSegmentedControl() {
        tpToiletSegmentedControl.setLabel("全部", forSegment: 0)
        tpToiletSegmentedControl.setLabel("無障礙廁所", forSegment: 1)
        tpToiletSegmentedControl.setLabel("親子廁間", forSegment: 2)
        tpToiletSegmentedControl.setLabel("貼心公廁", forSegment: 3)
        tpToiletSegmentedControl.isHidden = true
    }
    
    func setupDescriptionViewComponents() {
        // view
        descriptionBgView.wantsLayer = true
        descriptionBgView.layer?.backgroundColor = NSColor.white.cgColor
        descriptionBgView.layer?.cornerRadius = 5
        descriptionBgView.alphaValue = 0.9
        
        // label
        descriptionLabel.stringValue = ""
        descriptionLabel.font = NSFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = NSColor.darkGray
        
        // hide
        descriptionBgView.isHidden = true
    }
    
    func setupRecyclingInfoButton() {
        recyclingInfoButton.title = "資源回收分類方式"
        recyclingInfoButton.isHidden = true
    }
    
    
    // MARK: - Move to Site Location
    
    func moveToSiteLocation() {
        var coordinate = taipeiSiteCoordinate
        
        if mapState == .newTaipei {
            coordinate = banqiaoSiteCoordinate
        }
        
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: false)
    }
    
    
    // MARK: - MKMapView Delegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let location = userLocation.location {
            print("緯度:\(location.coordinate.latitude), 經度: \(location.coordinate.longitude)")
            
            myLocation.latitude = location.coordinate.latitude
            myLocation.longitude = location.coordinate.longitude
            
            if hasUserLocation == false {
                hasUserLocation = true
                let viewRegion = MKCoordinateRegion(center: myLocation,
                                                    latitudinalMeters: 1000,
                                                    longitudinalMeters: 1000)
                
                let adjustedRegion = mapView.regionThatFits(viewRegion)
                mapView.setRegion(adjustedRegion, animated: false)
                myLocationButton.title = "我的位置"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        if !annotation.isKind(of: TpMapAnnotation.self) { return nil }
        
        var annoViewIdentifier = ""
        
        if annotation.isMember(of: WaterDispenserAnnotation.self) {
            annoViewIdentifier = "waterDispenserAnnotationView"
        } else if annotation.isMember(of: TapWaterAnnotation.self) {
            annoViewIdentifier = "tapWaterAnnotationView"
        } else if annotation.isMember(of: FreeWifiAnnotation.self) {
            annoViewIdentifier = "freeWifiAnnotationView"
        } else if annotation.isMember(of: BicycleParkingAnnotation.self) {
            annoViewIdentifier = "bicycleParkingAnnotationView"
        } else if annotation.isMember(of: GarbageTruckAnnotation.self){
            annoViewIdentifier = "garbageTruckAnnotationView"
        } else if annotation.isMember(of: TrashBinAnnotation.self) {
            annoViewIdentifier = "trashBinAnnotationView"
        } else if annotation.isMember(of: TpToiletAnnotation.self) {
            annoViewIdentifier = "tpToiletAnnotationView"
        } else if annotation.isMember(of: NTpcToiletAnnotation.self) {
            annoViewIdentifier = "ntpcToiletAnnotationView"
        } else if annotation.isMember(of: PostOfficesAnnotation.self) {
            annoViewIdentifier = "postOfficesAnnotationView"
        }
        
        var annoView = mapView.dequeueReusableAnnotationView(withIdentifier: annoViewIdentifier) as? TpMapAnnotationView
        if annoView == nil {
            annoView = TpMapAnnotationView(annotation: annotation, reuseIdentifier: annoViewIdentifier)
        }
        
        let anno = annotation as! TpMapAnnotation
        setMapAnnotationView(annoView, annotation: anno)
        setCalloutViewWith(annotationView: annoView, attributedString: anno.infoToAttributedString())
        
        return annoView
    }
    
    
    // MARK: - MapAnnotationView / Detail Callout View
    
    func setMapAnnotationView(_ annotationView: TpMapAnnotationView?, annotation: TpMapAnnotation) {
        annotationView?.image      = annotation.image
        annotationView?.coordinate = annotation.coordinate
        annotationView?.info       = annotation.info
        
        annotationView?.selectedAction = { [weak self] (coordinate) in
            self?.selectedAnnotation(annotation, coordinate: coordinate)
        }
    }
    
    func setCalloutViewWith(annotationView: MKAnnotationView?, attributedString: NSAttributedString) {
        annotationView?.detailCalloutAccessoryView = detailLabelWith(attributedString: attributedString)
        annotationView?.canShowCallout = true
        annotationView?.leftCalloutOffset  = CGPoint(x: -4, y: -26)
        annotationView?.rightCalloutOffset = CGPoint(x: 4, y: -26)
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
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 550, longitudinalMeters: 550)
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
    
    func controlTextDidChange(_ obj: Notification) {
        if let textField = obj.object as? NSTextField {
            print(">> \(textField.stringValue)")
            placesSearcher.search(textField.stringValue) { [weak self] (results) in
                print(results)
            }
        }
    }
    
    
    // MARK: - Search Place
    
    func searchPlace() {
        let keyword = searchField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
        print("search keyword: \(keyword)。")
        
        removeCurrentSearchPlaceAnnotation()
        currentSearchPlace = nil
        placeButton.isHidden = true
        
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
            
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000);
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            mapView.setRegion(adjustedRegion, animated: true)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            anno.title = "\(name)"
            anno.subtitle = "\(country)\(administrativeArea)\(subAdministrativeArea)\(locality)\(subLocality)\(thoroughfare)\(subThoroughfare)"
            
            mapView.addAnnotation(anno)
            mapView.selectAnnotation(anno, animated: true)
            
            currentSearchPlaceAnnotation = anno
            placeButton.isHidden = false
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
    
    @IBAction func pressedSearchButton(_ sender: NSButton) {
        searchPlace()
    }
    
    @IBAction func selectedMapsPopUpButton(_ sender: NSPopUpButton) {
        print("\(sender.titleOfSelectedItem ?? "") : \(sender.indexOfSelectedItem)")
        loadMapDataWith(index: sender.indexOfSelectedItem, isReload: false)
    }
    
    @IBAction func pressedMyLocationButton(_ sender: NSButton) {
        mapView.setCenter(myLocation, animated: true)
    }
    
    @IBAction func pressedPlaceButton(_ sender: NSButton) {
        if let place = currentSearchPlace, place.location != nil, currentSearchPlaceAnnotation != nil {
            let coordinate = CLLocationCoordinate2D(latitude: place.location!.coordinate.latitude,
                                                    longitude: place.location!.coordinate.longitude)
            
            let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 700, longitudinalMeters: 700);
            let adjustedRegion = mapView.regionThatFits(viewRegion)
            mapView.setRegion(adjustedRegion, animated: true)
            
            mapView.selectAnnotation(currentSearchPlaceAnnotation!, animated: true)
        }
    }
    
    @IBAction func pressedReloadButton(_ sender: NSButton) {
        print("\(mapsPopUpButton.titleOfSelectedItem ?? "") : \(mapsPopUpButton.indexOfSelectedItem)")
        loadMapDataWith(index: mapsPopUpButton.indexOfSelectedItem, isReload: true)
    }
    
    @IBAction func selectedTpToiletSegmentedControl(_ sender: NSSegmentedControl) {
        print("segment: \(sender.selectedSegment), tag: \(sender.selectedTag())")
        showTpToiletMarkers()
    }
    
    @IBAction func pressedRecyclingInfoButon(_ sender: NSButton) {
        if let windowController = recyclingInfoWindowController {
            windowController.showWindow(nil)
        } else {
            let storyboardName = NSStoryboard.Name(stringLiteral: "Main")
            let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
            let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "TpMapInfoStoryboardID")

            if let infoWindowController = storyboard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {
                if let infoVC = infoWindowController.contentViewController as? InfoViewController {
                    infoVC.category = .recycling
                }
                
                infoWindowController.showWindow(nil)
                recyclingInfoWindowController = infoWindowController
            }
        }
    }
    
    
    // MARK: - Load Map Data
    
    func loadMapDataWith(index: Int, isReload: Bool) {
        /*
         * "公共飲水機" : "waterDispenser",
         * "自來水直飲臺" : "tapWater",
         * "Taipei Free 熱點" : "freeWifi",
         * "自行車停放區" : "bicycleParking",
         * "垃圾清運點位" : "garbageTruck",
         * "行人清潔箱" : "trashBin",
         * "台北市公廁" : "tpToilet",
         * "新北市公廁" : "ntpcToilet"
         * "郵局營業據點" : "postOffices"
         */
        
        let mapid = mapIDs[index]
        let name = mapTitles[index]
        
        mapState = .taipei
        tpToiletSegmentedControl.isHidden = true
        descriptionBgView.isHidden = true
        recyclingInfoButton.isHidden = true
        
        switch mapid {
        case "waterDispenser":
            loadWaterDispenser(title: name, isReload: isReload)
        case "tapWater":
            loadTapWater(title: name, isReload: isReload)
        case "freeWifi":
            loadFreeWifi(title: name, isReload: isReload)
        case "bicycleParking":
            loadBicycleParking(title: name, isReload: isReload)
        case "garbageTruck":
            loadGarbageTruck(title: name, isReload: isReload)
        case "trashBin":
            loadTrashBin(title: name, isReload: isReload)
        case "tpToilet":
            loadTpToilet(title: name, isReload: isReload)
        case "ntpcToilet":
            loadNTpcToilet(title: name, isReload: isReload)
            mapState = .newTaipei
        case "postOffices":
            loadPostOffices(title: name, isReload: isReload)
        default:
            break
        }
        changedMapAction(mapID: mapid)
    }
    
    func changedMapAction(mapID: String) {
        SettingsHelper.saveSelectedMapID(mapID)
        
        if hasUserLocation == false {
            setupMyLocation()
        }
        
        if let windowController = recyclingInfoWindowController {
            windowController.close()
            self.recyclingInfoWindowController = nil
        }
    }
    
    func resetShowAnnotations(_ annotations: Array<MKAnnotation>) {
        // clear Annotations
        mapView.removeAnnotations(showAnnotations)
        showAnnotations.removeAll()
        
        // add Annotations
        showAnnotations.append(contentsOf: annotations)
        mapView.addAnnotations(showAnnotations)
    }
    
    func showDataCountDescription(_ count: Int) {
        descriptionLabel.stringValue = "資料數量：\(count)"
        descriptionBgView.isHidden = false
    }
    
    
    // MARK: - Load or Fetch Water Dispenser Data
    
    func loadWaterDispenser(title: String, isReload: Bool) {
        if let list = waterDispenserList, list.count > 0, isReload == false {
            showWaterDispenserMarkers()
        } else {
            fetchWaterDispenserData(datasetName: title)
        }
    }
    
    func fetchWaterDispenserData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        WaterDispenserDataset.fetch() { csvText in
            self.waterDispenserList = nil
            
            var results = Array<Dictionary<String,Any>>()
            
            if let rows = csvText?.components(separatedBy: "\r\n") {
                //for i in 0..<rows.count { print("\(i)>\n \(rows[i])") }
                
                if rows.count >= 2 {
                    let fields = rows[0].components(separatedBy: ",")
                    for row in rows.dropFirst() {
                        let columns = row.components(separatedBy: ",")
                        if columns.count != fields.count { continue }
                        
                        var dict = Dictionary<String,String>()
                        for i in 0..<columns.count {
                            let key = fields[i].trimmingCharacters(in: .whitespacesAndNewlines)
                            let value = columns[i].trimmingCharacters(in: .whitespacesAndNewlines)
                            dict[key] = value
                        }
                        results.append(dict)
                    }
                }
            }
            
            self.waterDispenserList = results
            self.showWaterDispenserMarkers()
            self.dismissMessageView()
        }
    }
    
    func showWaterDispenserMarkers() {
        guard let items = waterDispenserList else { return }
        print("WaterDispenser count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<WaterDispenserAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "緯度", lngKey: "經度", imageName: "wd_pin")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Load or Fetch Tap Water Data
    
    func loadTapWater(title: String, isReload: Bool) {
        if let list = tapWaterList, list.count > 0, isReload == false {
            showTapWaterMarkers()
        } else {
            fetchTapWaterData(datasetName: title)
        }
    }
    
    func fetchTapWaterData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        tpApiFetchOffset = 0
        tapWaterList = Array<Dictionary<String,Any>>()
        downloadTapWaterDataset()
    }
    
    func downloadTapWaterDataset() {
        TapWaterDataset.fetch(limit: tpApiFetchLimit, offset: tpApiFetchOffset) { json in
            var resultsCount = 0
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.tapWaterList?.append(contentsOf: results)
                resultsCount = results.count
            }
            
            if resultsCount >= self.tpApiFetchLimit {
                self.tpApiFetchOffset += self.tpApiFetchLimit
                self.downloadTapWaterDataset()
            } else {
                self.showTapWaterMarkers()
                self.dismissMessageView()
            }
        }
    }
    
    func showTapWaterMarkers() {
        guard let items = tapWaterList else { return }
        print("TapWater count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<TapWaterAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "緯度", lngKey: "經度", imageName: "water_pin")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Load or Fetch Free Wifi Data
    
    func loadFreeWifi(title: String, isReload: Bool) {
        if let list = freeWifiList, list.count > 0, isReload == false {
            showFreeWifiMarkers()
        } else {
            fetchFreeWifiData(datasetName: title)
        }
    }
    
    func fetchFreeWifiData(datasetName: String) {
        showMessageView(message: "正在下載 \(datasetName)資料集...")
        tpApiFetchOffset = 0
        freeWifiList = Array<Dictionary<String,Any>>()
        downloadFreeWifiDataset()
    }
    
    func downloadFreeWifiDataset() {
        FreeWifiDataset.fetch(limit: tpApiFetchLimit, offset: tpApiFetchOffset) { json in
            var resultsCount = 0
            
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.freeWifiList?.append(contentsOf: results)
                resultsCount = results.count
            }
            
            if resultsCount >= self.tpApiFetchLimit {
                self.tpApiFetchOffset += self.tpApiFetchLimit
                self.downloadFreeWifiDataset()
            } else {
                self.showFreeWifiMarkers()
                self.dismissMessageView()
            }
        }
    }
    
    func showFreeWifiMarkers() {
        guard let items = freeWifiList else { return }
        print("FreeWifi count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<FreeWifiAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "LATITUDE", lngKey: "LONGITUDE", imageName: "wifi_pin2")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Load or Fetch Bicycle Parking Data
    
    func loadBicycleParking(title: String, isReload: Bool) {
        if let list = bicycleParkingList, list.count > 0, isReload == false {
            showBicycleParkingMarkers()
        } else {
            fetchBicycleParkingData(datasetName: title)
        }
    }
    
    func fetchBicycleParkingData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        tpApiFetchOffset = 0
        bicycleParkingList = Array<Dictionary<String,Any>>()
        downloadBicycleParkingDataset()
    }
    
    func downloadBicycleParkingDataset() {
        BicycleParkingDataset.fetch(limit: tpApiFetchLimit, offset: tpApiFetchOffset) { json in
            var resultsCount = 0
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.bicycleParkingList?.append(contentsOf: results)
                resultsCount = results.count
            }
            
            if resultsCount >= self.tpApiFetchLimit {
                self.tpApiFetchOffset += self.tpApiFetchLimit
                self.downloadBicycleParkingDataset()
            } else {
                self.showBicycleParkingMarkers()
                self.dismissMessageView()
            }
        }
    }
    
    func showBicycleParkingMarkers() {
        guard let items = bicycleParkingList else { return }
        print("BicycleParking count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<BicycleParkingAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "YW", lngKey: "XW", imageName: "bicycle_pin2")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Load or Fetch Garbage Truck Data
    
    func loadGarbageTruck(title: String, isReload: Bool) {
        if let list = garbageTruckList, list.count > 0, isReload == false {
            showGarbageTruckMarkers()
        } else {
            fetchGarbageTruckData(datasetName: title)
        }
    }
    
    func fetchGarbageTruckData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        GarbageTruckDataset.fetch(){ xmlText in
            self.garbageTruckList = nil
            
            if let text = xmlText, text != "" {
                //print(text)
                let data = Data(text.utf8)
                let reader = MyXMLReader()
                self.garbageTruckList = reader.read(data: data,
                                                    tagName: "Table",
                                                    fieldNames: ["Unit", "Title", "Content", "Lng", "Lat", "ModifyDate"])
            }
            
            self.showGarbageTruckMarkers()
            self.dismissMessageView()
        }
    }
    
    func showGarbageTruckMarkers() {
        guard let items = garbageTruckList else { return }
        print("GarbageTruck count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<GarbageTruckAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "Lat", lngKey: "Lng", imageName: "truck-pin")
        resetShowAnnotations(annoArray)
        
        if recyclingInfoButton.isHidden {
            recyclingInfoButton.isHidden = false
        }
    }
    
    
    // MARK: - Load or Fetch Trash Bin Data
    
    func loadTrashBin(title: String, isReload: Bool) {
        if let list = trashBinList, list.count > 0, isReload == false {
            showTrashBinMarkers()
        } else {
            fetchTrashBinData(datasetName: title)
        }
    }
    
    func fetchTrashBinData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        tpApiFetchOffset = 0
        trashBinList = Array<Dictionary<String,Any>>()
        
        downloadTrashBinDataset()
    }
    
    func downloadTrashBinDataset() {
        TrashBinDataset.fetch(limit: tpApiFetchLimit, offset: tpApiFetchOffset) { json in
            var resultsCount = 0
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.trashBinList?.append(contentsOf: results)
                resultsCount = results.count
            }
            
            if resultsCount >= self.tpApiFetchLimit {
                self.tpApiFetchOffset += self.tpApiFetchLimit
                self.downloadTrashBinDataset()
            } else {
                self.showTrashBinMarkers()
                self.dismissMessageView()
            }
        }
    }
    
    func showTrashBinMarkers() {
        guard let items = trashBinList else { return }
        print("TrashBin count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<TrashBinAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "緯度", lngKey: "經度", imageName: "trash_pin")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Load or Fetch Tp Toilet Data
    
    func loadTpToilet(title: String, isReload: Bool) {
        if let list = tpToiletList, list.count > 0, isReload == false {
            showTpToiletMarkers()
        } else {
            fetchTpToiletData(datasetName: title)
        }
    }
    
    func fetchTpToiletData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        TpToiletDataset.fetch() { xmlText in
            self.tpToiletList = nil
            
            if let text = xmlText, text != "" {
                //print(text)
                let data = Data(text.utf8)
                
                let fieldNames = ["Region",
                                  "Property",
                                  "Attribute",
                                  "ChiefOrg",
                                  "DepName",
                                  "Number",
                                  "Address",
                                  "FirstLevel",
                                  "SecondLevel",
                                  "ThirdLevel",
                                  "FourthLevel",
                                  "FifthLevel",
                                  "Restroom",
                                  "Childroom",
                                  "Kindlyroom",
                                  "Lng",
                                  "Lat",
                                  "EngName",
                                  "EngAddress"]
                
                let reader = MyXMLReader()
                self.tpToiletList = reader.read(data: data,
                                                tagName: "ToiletData",
                                                fieldNames: fieldNames)
            }
            
            self.showTpToiletMarkers()
            self.dismissMessageView()
        }
    }
    
    func showTpToiletMarkers() {
        guard let allItems = tpToiletList else { return }
        print("TpToilet all count: \(allItems.count)\n")
        
        let selectedSegment = tpToiletSegmentedControl.selectedSegment
        let items = filterTpToilet(allItems: allItems,
                                   category: toiletCategoryWith(segment: selectedSegment))
        
        print(">> selected segment: \(selectedSegment), \(tpToiletSegmentedControl.label(forSegment: selectedSegment) ?? "")")
        print(">> count: \(items.count)")
        
        showDataCountDescription(items.count)
        
        var annoArray = Array<TpToiletAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "Lat", lngKey: "Lng", imageName: "toilet_pin")
        resetShowAnnotations(annoArray)
        
        if tpToiletSegmentedControl.isHidden {
            tpToiletSegmentedControl.isHidden = false
        }
    }
    
    func toiletCategoryWith(segment: Int) -> ToiletCategory {
        switch segment {
        case 0:
            return .all
        case 1:
            return .restroom
        case 2:
            return .childroom
        case 3:
            return .kindlyroom
        default:
            return .all
        }
    }
    
    func filterTpToilet(allItems: Array<Dictionary<String,Any>>, category: ToiletCategory) -> Array<Dictionary<String,Any>> {
        switch category {
        case .all:
            return allItems
        case .restroom:
            return allItems.filter() { ($0["Restroom"] as! String).lowercased() == "y" }
        case .childroom:
            return allItems.filter() { ($0["Childroom"] as! String).lowercased() == "y" }
        case .kindlyroom:
            return allItems.filter() { ($0["Kindlyroom"] as! String).lowercased() == "y" }
        }
    }
    
    
    // MARK: - Load or Fetch NTpc Toilet Data
    
    func loadNTpcToilet(title: String, isReload: Bool) {
        if let list = ntpcToiletList, list.count > 0, isReload == false {
            showNTpcToiletMarkers()
        } else {
            fetchNTpcToiletData(datasetName: title)
        }
    }
    
    func fetchNTpcToiletData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        ntpcApiFetchPage = 0
        ntpcToiletList = Array<Dictionary<String,Any>>()
        downloadNTpcToiletDataset()
    }
    
    func downloadNTpcToiletDataset() {
        NTpcToiletDataset.fetch(page: ntpcApiFetchPage, size: ntpcApiFetchSize) { json in
            var jsonCount = 0
            if let json = json {
                self.ntpcToiletList?.append(contentsOf: json)
                jsonCount = json.count
            }
            
            if jsonCount >= self.ntpcApiFetchSize {
                self.ntpcApiFetchPage += 1
                self.downloadNTpcToiletDataset()
            } else {
                self.showNTpcToiletMarkers()
                self.dismissMessageView()
            }
        }
    }
    
    func showNTpcToiletMarkers() {
        guard let items = ntpcToiletList else { return }
        print("NTpcToilet count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<NTpcToiletAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "twd97X", lngKey: "twd97Y", imageName: "ntpc_toilet_pin")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Load or Fetch Post Offices Data
    
    func loadPostOffices(title: String, isReload: Bool) {
        if let list = postOfficesList, list.count > 0, isReload == false {
            showPostOfficesMarkers()
        } else {
            fetchPostOfficesData(datasetName: title)
        }
    }
    
    func fetchPostOfficesData(datasetName: String) {
        showMessageView(message: "正在下載\(datasetName)資料集...")
        
        PostOfficesDataset.fetch() { json in
            self.postOfficesList = nil
            
            if let json = json {
                self.postOfficesList = json
            }
            self.showPostOfficesMarkers()
            self.dismissMessageView()
        }
    }
    
    func showPostOfficesMarkers() {
        guard let allItems = postOfficesList else { return }
        print("PostOffices all count: \(allItems.count)")
        
        var items = Array<Dictionary<String,Any>>()
        
        for item in allItems {
            let city = (item["縣市"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if city == "臺北市" || city == "台北市" || city == "新北市" {
                items.append(item)
            }
        }
        
        print(">> items count: \(items.count)")
        showDataCountDescription(items.count)
        
        var annoArray = Array<PostOfficesAnnotation>()
        createAnnotations(&annoArray, items: items, latKey: "緯度", lngKey: "經度", imageName: "post_pin2")
        resetShowAnnotations(annoArray)
    }
    
    
    // MARK: - Generic Functions
    
    func createAnnotations<T: TpMapAnnotation>(_ annotations: inout Array<T>,
                                               items: Array<Dictionary<String,Any>>,
                                               latKey: String,
                                               lngKey: String,
                                               imageName: String)
    {
        for item in items {
            let latitude : Double = MyTools.doubleFrom(string: item[latKey] as? String)
            let longitude : Double = MyTools.doubleFrom(string: item[lngKey] as? String)
            
            if latitude == 0 || longitude == 0 {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let anno = T(coordinate: coordinate)
            anno.image = NSImage(named: imageName)
            anno.info = item
            
            annotations.append(anno)
        }
    }
    
}

