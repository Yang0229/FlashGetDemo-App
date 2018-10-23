//
//  CarrierWantAnOrderVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class OrderListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    let databaseReference = Database.database().reference()
    var orderRequests: [DataSnapshot] = []
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var ordersTableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    var carrierLocation = CLLocationCoordinate2D()
    var itemPhotoImage: UIImage?
    let dataOfUsers = DataOfUsers()
    let dataOfOrders = DataOfOrders()
    
    var listType: String = ""
    var userId: String = ""
    var userType: String = ""
    var orderId: String = ""
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        print("ListType: \(listType)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("Current User Id: \(userId)")
        
        if listType == "CarrierTakeOrder"{
            
            getOrdersDataForCarrierTakeOrder()
            
        }else if listType == "CarrierOnProcessingOrder"{
            
            getOrdersDataForCarrierOnProcessingOrder()
            
        }else if listType == "CarrierCompletedOrder"{
            
            getOrdersDataForCarrierCompletedOrder()
            
        }else if listType == "CustomerOnProcessingOrder"{
            
            getOrdersDataForCustomerOnProcessingOrder()
            
        }else if listType == "CustomerCompletedOrder"{
            
            getOrdersDataForCustomerCompletedOrder()

        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
            performSegue(withIdentifier: "OrderListVCToMainVC", sender: self)
           
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        carrierLocation = (manager.location?.coordinate)!
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderRequests.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CarrierWantAnOrderCell
        
        let snapShot = orderRequests[indexPath.row]
 
        if let orderDic = snapShot.value as? [String : Any]{

            if let order_Id = orderDic["order_Id"] as? String{
            
                if let order_Reward = orderDic["order_ItemReward"] as? String{
                  
                    if let order_Distance = (orderDic["order_Distance"] as? NSString)?.doubleValue{
                        
                        if let order_SenderLat = (orderDic["order_SenderLat"] as? NSString)?.doubleValue{
                            
                            if let order_SenderLon = (orderDic["order_SenderLon"] as? NSString)?.doubleValue{
                                
                                        if let order_ItemPhotoName = orderDic["order_ItemPhotoName"] as? String{
                                            
                                            let storageRef = Storage.storage().reference()
                                            let itemPhotoRef = storageRef.child("itemPhoto/\(order_ItemPhotoName).jpeg")
                                            itemPhotoRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                                                
                                                if error != nil{

                                                }else{
                                                    
                                                    print("1")
                                                    self.itemPhotoImage = UIImage(data: data!)

                                                    let SenderCLLocation = CLLocation(latitude: order_SenderLat, longitude: order_SenderLon)
                                                    
                                                    let carrierCLLocation = CLLocation(latitude: self.carrierLocation.latitude, longitude: self.carrierLocation.longitude)
                                                    
                                                    let carrierDistance = carrierCLLocation.distance(from: SenderCLLocation)
                                                    let roundedCarrierDistance = round(carrierDistance / 10) / 100
                                                    let roundedOrderDistance = round(order_Distance / 10) / 100
                                                    
                                                    let order_IdDetail = order_Id
                                                    let order_RewardDetail = order_Reward
                                                    let order_DistanceDetail = "\(roundedOrderDistance) kms"
                                                    
                                                    if self.listType == "CarrierTakeOrder" || self.listType == "CarrierOnProcessingOrder"{
                                                        
                                                        let carrierDistanceDetail = "\(roundedCarrierDistance) kms away."
                                                        
                                                        cell.configureCell(itemImage: self.itemPhotoImage!, id: order_IdDetail, reward: order_RewardDetail, distance: order_DistanceDetail, away: carrierDistanceDetail)
                                                        
                                                    }else{
                                                        
                                                        let carrierDistanceDetail = ""
                                                        
                                                        cell.configureCell(itemImage: self.itemPhotoImage!, id: order_IdDetail, reward: order_RewardDetail, distance: order_DistanceDetail, away: carrierDistanceDetail)
                                                        
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
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snapShot = orderRequests[indexPath.row]
        
        if userType == "Carrier"{
            
            performSegue(withIdentifier: "carrierGoToOrderPage", sender: snapShot)
            
        }else{
            
            performSegue(withIdentifier: "OrderListVCToCustomerOrderInfoVC", sender: snapShot)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "carrierGoToOrderPage"{
            
            let destinationVC = segue.destination as! CarrierTakeAnOrderVC
            
            if let snapShot = sender as? DataSnapshot{
                
                if let orderDic = snapShot.value as? [String : Any]{
                    
                    if let order_Id = orderDic["order_Id"] as? String{
                        
                        destinationVC.orderId = order_Id
                        destinationVC.listType = self.listType
                        destinationVC.userType = self.userType
                        destinationVC.userId = self.userId
                        
                        
                    }
                    
                }
                
            }
                        
        }
        
        if segue.identifier == "OrderListVCToCustomerOrderInfoVC"{
            
            let destinationVC = segue.destination as! CustomOrderInfoVC
            
            if let snapShot = sender as? DataSnapshot{
                
                if let orderDic = snapShot.value as? [String : Any]{
                    
                    if let order_Id = orderDic["order_Id"] as? String{
                        
                        destinationVC.orderId = order_Id
                        destinationVC.listType = self.listType
                        destinationVC.userId = self.userId
                        destinationVC.userType = self.userType
                        
                    }
                    
                }
                
            }
            
        }
        
        if segue.identifier == "OrderListVCToMainVC"{
            
            let destinationVC = segue.destination as! MainVC
            destinationVC.userId = self.userId
            destinationVC.userType = userType
            
        }
        
        
    }
    
    
    func getOrdersDataForCarrierTakeOrder(){
        
        databaseReference.child("orders").queryOrdered(byChild: "order_Status").queryEqual(toValue: "Placed").observe(DataEventType.childAdded) { (dataSnapshot) in
            
            self.orderRequests.append(dataSnapshot)
            dataSnapshot.ref.removeAllObservers()
            self.ordersTableView.reloadData()
            
            }
            
        }
    
    func getOrdersDataForCarrierOnProcessingOrder(){
        
        databaseReference.child("orders").queryOrdered(byChild: "order_StatusContentForCarrier").queryEqual(toValue: userId + "Taken").observe(DataEventType.childAdded) { (dataSnapshot) in
            
            self.orderRequests.append(dataSnapshot)
            dataSnapshot.ref.removeAllObservers()
            self.ordersTableView.reloadData()
            
        }
        
    }
    
    func getOrdersDataForCarrierCompletedOrder(){
        
        databaseReference.child("orders").queryOrdered(byChild: "order_StatusContentForCarrier").queryEqual(toValue: userId + "Delivered").observe(DataEventType.childAdded) { (dataSnapshot) in
            
            self.orderRequests.append(dataSnapshot)
            dataSnapshot.ref.removeAllObservers()
            self.ordersTableView.reloadData()
            
        }
        
    }
    
    func getOrdersDataForCustomerOnProcessingOrder(){
        
        databaseReference.child("orders").queryOrdered(byChild: "order_StatusContentForCustomer").queryEqual(toValue: userId + "Taken").observe(DataEventType.childAdded) { (dataSnapshot) in
            
            self.orderRequests.append(dataSnapshot)
            dataSnapshot.ref.removeAllObservers()
            self.ordersTableView.reloadData()
            
        }
        
        databaseReference.child("orders").queryOrdered(byChild: "order_StatusContentForCustomer").queryEqual(toValue: userId + "Placed").observe(DataEventType.childAdded) { (dataSnapshot) in
            
            self.orderRequests.append(dataSnapshot)
            dataSnapshot.ref.removeAllObservers()
            self.ordersTableView.reloadData()
            
        }
        
    }
    
    func getOrdersDataForCustomerCompletedOrder(){
        
        databaseReference.child("orders").queryOrdered(byChild: "order_StatusContentForCustomer").queryEqual(toValue: userId + "Delivered").observe(DataEventType.childAdded) { (dataSnapshot) in
            
            self.orderRequests.append(dataSnapshot)
            dataSnapshot.ref.removeAllObservers()
            self.ordersTableView.reloadData()
            
        }
        
    }
    
    
    
    
        
}
