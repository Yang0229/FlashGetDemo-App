//
//  CarrierTakeAnOrderVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class CarrierTakeAnOrderVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scanQRBtn: UIButton!
    @IBOutlet weak var statusIcon: UIImageView!
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var orderNeedPickdTime: UILabel!
    @IBOutlet weak var orderNeedDeliverdTime: UILabel!
    @IBOutlet weak var customerId: UILabel!
    @IBOutlet weak var orderDistance: UILabel!
    @IBOutlet weak var rewardAmount: UILabel!
    @IBOutlet weak var pickedTime: UILabel!
    @IBOutlet weak var deliveredTime: UILabel!
    @IBOutlet weak var ratingStar: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var takeOrderBtn: UIButton!
    @IBOutlet weak var navBtn: UIButton!
    
    
    let datebaseRef = Database.database().reference()
    let interfaceStyleFunc = InterfaceStyleFunc()
    
    let locationManager = CLLocationManager()
    var carrierCLLocation = CLLocationCoordinate2D()
    var senderCLLocation = CLLocationCoordinate2D()
    var receiverCLLocation = CLLocationCoordinate2D()
    
    var orderStatus: String = ""
    var orderId: String = ""
    var customerID: String = ""
    var carrierID: String = ""
    var senderQRContent: String = ""
    var receiverQRContent: String = ""
    
    var itemName: String = ""
    var itemCategory: String = ""
    var itemWeight: String = ""
    var senderFirstName: String = ""
    var senderLastName: String = ""
    var senderPhone: String = ""
    var senderAddress: String = ""
    var senderDesc: String = ""
    var senderPickTime: String = ""
    var receiverFirstName: String = ""
    var receiverLastName: String = ""
    var receiverPhone: String = ""
    var receiverAddress: String = ""
    var receiverDesc: String = ""
    var receiverDeliveryTime: String = ""
    
    var listType: String = ""
    var userType: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle1(button: navBtn)
        interfaceStyleFunc.setBtnStyle1(button: detailBtn)
        interfaceStyleFunc.setBtnStyle1(button: scanQRBtn)
        interfaceStyleFunc.setBtnStyle1(button: takeOrderBtn)
        
        mapView.delegate = self
        
        getCurrentUserId()
        
        scanQRBtn.isHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        setTakeAndNavBtn()
        
        orderIdLabel.text = orderId
        getDataFromFirebase()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMap()
        setTakeAndNavBtn()
        setScanBtn()
        
        let senderAnnotation = MKPointAnnotation()
        let receiverAnnotation = MKPointAnnotation()
        let carrierAnnotation = MKPointAnnotation()
        
        senderAnnotation.coordinate = senderCLLocation
        senderAnnotation.title = "Sender"
        senderAnnotation.subtitle = senderAddress
        
        receiverAnnotation.coordinate = receiverCLLocation
        receiverAnnotation.title = "Receiver"
        receiverAnnotation.subtitle = receiverAddress
        
        carrierAnnotation.coordinate = self.carrierCLLocation
        carrierAnnotation.title = "Your Location"
        
        print(senderCLLocation.latitude)
        print(senderCLLocation.longitude)
        
        print(receiverCLLocation.latitude)
        print(receiverCLLocation.longitude)
        
        mapView.addAnnotation(senderAnnotation)
        mapView.addAnnotation(receiverAnnotation)
        mapView.addAnnotation(carrierAnnotation)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "TakeOrderVCToOrderListVC", sender: self)
        
    }
    
    
    @IBAction func takeOrderBtnPressed(_ sender: Any) {
        
        let alerController = UIAlertController(title: "Take Order Confirm", message: "Are you sure to take this order?", preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (alertAction) in
            
            alerController.dismiss(animated: true, completion: nil)
            
        }
        
        let confirmAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (alertAction) in
            
            let orderStatusContentForCustomer = self.customerID + "Taken"
            let orderStatusContentForCarrier = self.carrierID + "Taken"
            var autoId = ""
            self.datebaseRef.child("orders").queryOrdered(byChild: "order_Id").queryEqual(toValue: self.orderId).observeSingleEvent(of: DataEventType.value, with: { (dataSnapshot) in
                
                for snap in dataSnapshot.children {
                    let userSnap = snap as! DataSnapshot
                    autoId = userSnap.key //the uid of each user

                    self.datebaseRef.child("orders").child(autoId).child("order_Status").setValue("Taken")
                    self.datebaseRef.child("orders").child(autoId).child("order_CarrierId").setValue(self.carrierID)
                    self.datebaseRef.child("orders").child(autoId).child("order_StatusContentForCustomer").setValue(orderStatusContentForCustomer)
                    self.datebaseRef.child("orders").child(autoId).child("order_StatusContentForCarrier").setValue(orderStatusContentForCarrier)
                    self.getDataFromFirebase()
                    self.setTakeAndNavBtn()
                    self.setScanBtn()
                    
                    let alertController = UIAlertController(title: "Congratulations", message: "You take the order successful", preferredStyle: UIAlertController.Style.alert)
                    
                    let alertActionOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) in
                    
                        alertController.dismiss(animated: true, completion: {
                            
                            self.performSegue(withIdentifier: "TakeOrderVCToOrderListVC", sender: self)
                            
                        })
                        
                    })
                    
                    alertController.addAction(alertActionOK)
                    self.present(alertController, animated: true, completion: nil)

                }
                
            })
        }
        
        alerController.addAction(cancelAction)
        alerController.addAction(confirmAction)
        
        present(alerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func orderDetailBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToOrderDetailsVC", sender: self)
        
    }
    
    
    @IBAction func navBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Choose the destination", message: "Please choose the destination below:", preferredStyle: UIAlertController.Style.actionSheet)
        
        let alertActionSender = UIAlertAction(title: "To Sender", style: UIAlertAction.Style.default) { (alertAction) in
            
            let destinationCLLocation = CLLocation(latitude: self.senderCLLocation.latitude, longitude: self.senderCLLocation.longitude)
            
            CLGeocoder().reverseGeocodeLocation(destinationCLLocation, completionHandler: { (clplacemarks, error) in
                
                if error != nil{
                    
                    print(error)
                    
                }else{
                    
                    if let placemarks = clplacemarks{
                        
                        if placemarks.count > 0{
                            
                            let placeMark = MKPlacemark(placemark: placemarks[0])
                            let mapItem = MKMapItem(placemark: placeMark)
                            mapItem.name = self.senderFirstName + self.senderLastName
                            mapItem.phoneNumber = self.senderAddress
                            
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                            
                        }
                        
                    }
                    
                }
                
            })
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        let alertActionReceiver = UIAlertAction(title: "To Receiver", style: UIAlertAction.Style.default) { (alertAction) in
            
            let destinationCLLocation = CLLocation(latitude: self.receiverCLLocation.latitude, longitude: self.receiverCLLocation.longitude)
            
            CLGeocoder().reverseGeocodeLocation(destinationCLLocation, completionHandler: { (clplacemarks, error) in
                
                if error != nil{
                    
                    print(error)
                    
                }else{
                    
                    if let placemarks = clplacemarks{
                        
                        if placemarks.count > 0{
                            
                            let placeMark = MKPlacemark(placemark: placemarks[0])
                            let mapItem = MKMapItem(placemark: placeMark)
                            mapItem.name = self.receiverFirstName + self.receiverLastName
                            mapItem.phoneNumber = self.receiverAddress
                            
                            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
                            
                        }
                        
                    }
                    
                }
                
            })
            
            alertController.dismiss(animated: true, completion: nil)
    
        }
            

        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (alertAction) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(alertActionSender)
        alertController.addAction(alertActionReceiver)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func scanQrBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToScanVC", sender: self)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToOrderDetailsVC"{
            
            let destinationVC = segue.destination as! OrderDetailsVC
            
            destinationVC.orderID = self.orderId
            destinationVC.userId = self.userId
            destinationVC.listType = self.listType
            destinationVC.userType = self.userType
            
        }
        
        if segue.identifier == "GoToScanVC"{
            
            let destinationVC = segue.destination as! ScanQRVC
            
            destinationVC.orderId = self.orderId
            destinationVC.carrierId = self.carrierID
            destinationVC.customerId = self.customerID
            destinationVC.orderStatus = self.orderStatus
            destinationVC.senderQRContent = self.senderQRContent
            destinationVC.receiverQRContent = self.receiverQRContent
            
            destinationVC.listType = self.listType
            destinationVC.userType = self.userType
            destinationVC.userId = self.userId
            
        }
        
        if segue.identifier == "TakeOrderVCToOrderListVC"{
            
            let destinationVC = segue.destination as! OrderListVC
            
            destinationVC.orderId = self.orderId
            destinationVC.listType = self.listType
            destinationVC.userType = self.userType
            destinationVC.userId = self.userId
            
        }
        
    }
    

    func setScanBtn(){
        
        if orderStatus == "Taken" || orderStatus == "Picked"{
            
            self.scanQRBtn.isEnabled = true
            self.scanQRBtn.isHidden = false
            
        }else{
            
            self.scanQRBtn.isEnabled = false
            self.scanQRBtn.isHidden = true
            
        }
        
    }
    
    
    func setTakeAndNavBtn(){
        
        if orderStatus == "Placed"{
            
            self.navBtn.isHidden = true
            self.navBtn.isEnabled = false
            
            self.takeOrderBtn.isHidden = false
            self.takeOrderBtn.isEnabled = true
            
        }else if orderStatus == "Canceld" && orderStatus == "Delivered"{
            
            self.navBtn.isHidden = true
            self.navBtn.isEnabled = false
            
            self.takeOrderBtn.isHidden = true
            self.takeOrderBtn.isEnabled = false
            
            self.detailBtn.frame = navBtn.frame
            
        }else{
            
            self.navBtn.isHidden = false
            self.navBtn.isEnabled = true
            
            self.takeOrderBtn.isHidden = true
            self.takeOrderBtn.isEnabled = false
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        carrierCLLocation = (manager.location?.coordinate)!
        
    }
    
    
    func setMap(){
        
        let span = MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)
        let region = MKCoordinateRegion(center: self.carrierCLLocation, span: span)
        mapView.setRegion(region, animated: false)
        
    }
    

    func getCurrentUserId(){
        
        let currentUserEmail = Auth.auth().currentUser?.email
        
        datebaseRef.child("users").queryOrdered(byChild: "user_Email").queryEqual(toValue: currentUserEmail).observe(DataEventType.childAdded) { (dataSnapshot) in
            
            if let currentUserInfo = dataSnapshot.value as? [String : Any]{
                
                if let currentUserId = currentUserInfo["user_Id"] as? String{
                    
                    self.carrierID = currentUserId
                    
                }
                
            }
            
        }
        
    }
    

    func getDataFromFirebase(){
        
        datebaseRef.child("orders").queryOrdered(byChild: "order_Id").queryEqual(toValue: orderId).observe( DataEventType.childAdded) { (dataSnapshot) in
            
            print(self.orderId)
            
            if let orderDic = dataSnapshot.value as? [String : Any]{
                print("8")
                if let order_Status = orderDic["order_Status"] as? String{
                  print("8")
                    if let order_SenderPickUpTime = orderDic["order_SenderPickUpTime"] as? String{
                     print("8")
                        if let order_ReceiverDeliveredTime = orderDic["order_ReceiverDeliveredTime"] as? String{
                           print("8")
                                if let order_Reward = orderDic["order_ItemReward"] as? String{
                                 print("8")
                                    if let order_Distance = (orderDic["order_Distance"] as? NSString)?.doubleValue{
                                     print("8")
                                        if let order_SenderLat = (orderDic["order_SenderLat"] as? NSString)?.doubleValue{
                                          print("8")
                                            if let order_SenderLon = (orderDic["order_SenderLon"] as? NSString)?.doubleValue{
                                            print("8")
                                                if let order_ReceiverLat = (orderDic["order_ReceiverLat"] as? NSString)?.doubleValue{
                                                print("8")
                                                    if let order_ReceiverLon = (orderDic["order_ReceiverLon"] as? NSString)?.doubleValue{
                                                     print("8")
                                                        if let order_PickedTime = orderDic["order_PickedTime"] as? String{
                                                        print("8")
                                                            if let order_DeliveredTime = orderDic["order_DeliveredTime"] as? String{
                                                           print("8")
                                                                print("8")
                                                                    if let order_Star = orderDic["order_Star"] as? String{
                                                                    print("8")
                                                                        if let order_SenderAddress = orderDic["order_SenderAddress"] as? String{
                                                                         print("8")
                                                                            if let order_SenderRegion = orderDic["order_SenderRegion"] as? String{
                                                                             print("8")
                                                                                if let order_ReceiverAddress = orderDic["order_ReceiverAddress"] as? String{
                                                                                    print("8")
                                                                                    if let order_ReceiverRegion = orderDic["order_ReceiverRegion"] as? String{
                                                                                        print("8")
                                                                                        if let order_SenderZipCode = orderDic["order_SenderZipCode"] as? String{
                                                                                            print("8")
                                                                                            if let order_ReceiverZipCode = orderDic["order_ReceiverZipCode"] as? String{
                                                                                                print("8")
                                                                                                if let order_SenderQRContent = orderDic["order_SenderQRContent"] as? String{
                                                                                                    print("8")
                                                                                                    if let order_ReceiverQRContent = orderDic["order_ReceiverQRContent"] as? String{
                                                                                                        print("8")
                                                                                                        if let order_CustomerId = orderDic["order_CustomerId"] as? String{
                                                                                             print("8")
                                                                                                            if let order_ItemName = orderDic["order_ItemName"] as? String{
                                                                                                       print("8")
                                                                                                                if let order_ItemCategory = orderDic["order_ItemCategory"] as? String{
                                                                                                                 print("8")
                                                                                                                    if let order_ItemWeight = orderDic["order_ItemWeight"] as? String{
                                                                                                                        print("8")
                                                                                                                        if let order_SenderFirstName = orderDic["order_SenderFirstName"] as? String{
                                                                                                                            print("8")
                                                                                                                            if let order_SenderLastName = orderDic["order_SenderLastName"] as? String{
                                                                                                                                print("8")
                                                                                                                                if let order_ReceiverFirstName = orderDic["order_ReceiverFirstName"] as? String{
                                                                                                                                    print("8")
                                                                                                                                    if let order_ReceiverLastName = orderDic["order_ReceiverLastName"] as? String{
                                                                                                                                        print("8")
                                                                                                                                        if let order_SenderPhone = orderDic["order_SenderPhone"] as? String{
                                                                                                                                            print("8")
                                                                                                                                            if let order_ReceiverPhone = orderDic["order_ReceiverPhone"] as? String{
                                                                                                                                                print("8")
                                                                                                                                                if let order_SenderOther = orderDic["order_SenderDesc"] as? String{
                                                                                                                                                    print("8")
                                                                                                                                                    if let order_ReceiverOther = orderDic["order_ReceiverDesc"] as? String{
                                                                                                                                                        print("8")
                                                                                                                                                                                                                                                                    let senderCLLocation = CLLocationCoordinate2D(latitude: order_SenderLat, longitude: order_SenderLon)
                                                                                                                                                                                                                                                                    let receiverCLLocation = CLLocationCoordinate2D(latitude: order_ReceiverLat, longitude: order_ReceiverLon)
                                                                                                                                                                                                                                                                    let roundedDistance = round(order_Distance / 10) / 100
                                                                                                                                                        
                                                                                                                                                        self.customerID = order_CustomerId
                   
                                                                                                                                                        self.itemName = order_ItemName
                                                                                                                                                        
                                                                                                                                                        self.itemCategory = order_ItemCategory
                                                                                                                                                  
                                                                                                                                                        self.itemWeight = order_ItemWeight
                                                                                                                                                        
                                                                                                                                                        self.senderFirstName = order_SenderFirstName
                                                                                                                                                        
                                                                                                                                                        self.senderLastName = order_SenderLastName
                                                                                                                                                        
                                                                                                                                                        self.receiverFirstName = order_ReceiverFirstName
                                                                                                                                                        
                                                                                                                                                        self.receiverLastName = order_ReceiverLastName
                                                                                                                                                        
                                                                                                                                                        self.senderPhone = order_SenderPhone
                                                                                                                                                        
                                                                                                                                                        self.receiverPhone = order_ReceiverPhone
                                                                                                                                                        
                                                                                                                                                        self.senderDesc = order_SenderOther
                                                                                                                                                        
                                                                                                                                                        self.receiverDesc = order_ReceiverOther
                                                                                                                                                        
                                                                                                                                                        self.senderPickTime = order_SenderPickUpTime
                                                                                                                                                        
                                                                                                                                                        self.receiverDeliveryTime = order_ReceiverDeliveredTime
                                                                                                                                                        
                                                                                                                                                                                                                                                                         self.senderCLLocation = senderCLLocation
                                                                                                                                                                                                                                                                    self.receiverCLLocation = receiverCLLocation
                                                                                                                                                                                                                                                                    self.orderStatus = order_Status
                                                                                                                                                                                                                                                                    self.customerID = order_CustomerId
                                                                                                                                                                                                                                                                    self.senderQRContent = order_SenderQRContent
                                                                                                                                                                                                                                                                    self.receiverQRContent = order_ReceiverQRContent
                                                                                                                                                        
                                                                                                                                                                                                                                                                    self.orderStatusLabel.text = order_Status
                                                                                                                                                                                                                                                                    self.orderNeedPickdTime.text = order_SenderPickUpTime
                                                                                                                                                                                                                                                                    self.orderNeedDeliverdTime.text = order_ReceiverDeliveredTime
                                                                                                                                                                                                                                                                    self.customerId.text = order_CustomerId
                                                                                                                                                                                                                                                                    self.orderDistance.text = "\(roundedDistance) kms"
                                                                                                                                                                                                                                                                    self.rewardAmount.text = "$ \(order_Reward)"
                                                                                                                                                                                                                                                                    self.pickedTime.text = order_PickedTime
                                                                                                                                                                                                                                                                    self.deliveredTime.text = order_DeliveredTime
                                                                                                                                                                                                                                                                    self.ratingStar.text = order_Star
                                                                                                                                                        
                                                                                                                                                                                                                                                                    self.senderAddress = "\(order_SenderAddress),\(order_SenderRegion),\(order_SenderZipCode)"
                                                                                                                                                                                                                                                                    self.receiverAddress = "\(order_ReceiverAddress),\(order_ReceiverRegion),\(order_ReceiverZipCode)"
                                                                                                                                                        
                                                                                                                                                        self.view.reloadInputViews()
                                                                                                                                                        
                                                                                                                                                    }
                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                                
                                                                                                                                            }
                                                                                                                                            
                                                                                                                                        }
                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    
                                                                                                                                }
                                                                                                                                
                                                                                                                            }
                                                                                                                            
                                                                                                                        }
                                                                                                                        
                                                                                                                    }
                                                                                                                }
                                                                                                                
                                                                                                            }
                                                                                                            
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
    
    

    
    
    
    
    

}
