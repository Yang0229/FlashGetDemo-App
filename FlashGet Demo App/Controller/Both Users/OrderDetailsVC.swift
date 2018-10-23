//
//  OrderDetailsVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-15.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailsVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemCategoryLabel: UILabel!
    @IBOutlet weak var itemWeightLabel: UILabel!
    
    @IBOutlet weak var senderFirstNameLabel: UILabel!
    @IBOutlet weak var senderLastNameLabel: UILabel!
    @IBOutlet weak var senderPhoneLabel: UILabel!
    @IBOutlet weak var senderAddressLabel: UILabel!
    @IBOutlet weak var senderOtherLabel: UILabel!
    @IBOutlet weak var senderPickTimeLabel: UILabel!
    
    @IBOutlet weak var receiverFirstNameLabel: UILabel!
    @IBOutlet weak var receiverLastNameLabel: UILabel!
    @IBOutlet weak var receiverPhoneLabel: UILabel!
    @IBOutlet weak var receiverAddressLabel: UILabel!
    @IBOutlet weak var receiverOtherLabel: UILabel!
    @IBOutlet weak var receiverDeliveryTimeLabel: UILabel!
    
    
    let datebaseRef = Database.database().reference()
    
    var orderID: String = ""
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
    var userId:String = ""
    var userType: String = ""
    
    var listType: String = ""
    var isfromCustomer: Bool = false
    let dataOfOrders = DataOfOrders()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayInfo), userInfo: nil, repeats: true)
        dataOfOrders.getOrderDataFromFirebase(researchedKey: "order_Id", equalToValue: orderID)
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        if isfromCustomer{
            
            performSegue(withIdentifier: "OrderDetailsVCToCustomerOrderInfoVC", sender: self)
            
        }else{
            
            performSegue(withIdentifier: "DetailVCToTakeOrderVC", sender: self)
            
        }
        
        timer.invalidate()
        
    }
    
    
    @objc func displayInfo(){
        
        let senderAddressContent = "\(dataOfOrders.order_SenderAddress), \(dataOfOrders.order_SenderRegion), \(dataOfOrders.order_SenderZipCode)"
        let receiverAddressContent = "\(dataOfOrders.order_ReceiverAddress), \(dataOfOrders.order_ReceiverRegion), \(dataOfOrders.order_ReceiverZipCode)"
        
        itemNameLabel.text = dataOfOrders.order_ItemName
        itemCategoryLabel.text = dataOfOrders.order_ItemCategory
        itemWeightLabel.text = dataOfOrders.order_ItemWeight
        
        senderFirstNameLabel.text = dataOfOrders.order_SenderFirstName
        senderLastNameLabel.text = dataOfOrders.order_SenderLastName
        senderPhoneLabel.text = dataOfOrders.order_SenderPhone
        senderAddressLabel.text = senderAddressContent
        senderOtherLabel.text = dataOfOrders.order_SenderDesc
        senderPickTimeLabel.text = dataOfOrders.order_SenderPickUpTime
        receiverFirstNameLabel.text = dataOfOrders.order_ReceiverFirstName
        receiverLastNameLabel.text = dataOfOrders.order_ReceiverLastName
        receiverPhoneLabel.text = dataOfOrders.order_ReceiverPhone
        receiverAddressLabel.text = receiverAddressContent
        receiverOtherLabel.text = dataOfOrders.order_ReceiverDesc
        receiverDeliveryTimeLabel.text = dataOfOrders.order_ReceiverDeliveredTime
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailVCToTakeOrderVC"{
            
            let destinationVC = segue.destination as! CarrierTakeAnOrderVC
            
            destinationVC.orderId = self.orderID
            destinationVC.listType = self.listType
            destinationVC.userType = self.userType
            destinationVC.userId = self.userId
            
        }
        
        if segue.identifier == "OrderDetailsVCToCustomerOrderInfoVC"{
            
            let destinationVC = segue.destination as! CustomOrderInfoVC
            
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            destinationVC.orderId = self.orderID
            destinationVC.listType = self.listType
            
        }
        
    }

    

}
