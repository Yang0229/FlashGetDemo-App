//
//  CustomOrderInfoVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class CustomOrderInfoVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var infoLabelStackView: UIStackView!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pickUpTimeLabel: UILabel!
    @IBOutlet weak var deliveredTimeLabel: UILabel!
    @IBOutlet weak var carrierId: UILabel!
    @IBOutlet weak var orderDistance: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var qrBtn: UIButton!
    @IBOutlet weak var orderDetailsBtn: UIButton!
    @IBOutlet weak var carrierInfoBtn: UIButton!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var ratingBtn: UIButton!
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    
    let myTools = MyTools()
    var orderId: String = ""
    var userId: String = ""
    var userType: String = ""
    var orderStatus: String = ""
    var customerId: String = ""
    var orderRateContentForCustomer: String = ""
    var orderStatusContentForCustomer: String = ""
    var listType: String = ""
    var isfromCustomer: Bool = true
    var carrierIdString:String = ""
    
    let dataOfOrders = DataOfOrders()
    let databaseRef = Database.database().reference()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle1(button: qrBtn)
        interfaceStyleFunc.setBtnStyle1(button: ratingBtn)
        interfaceStyleFunc.setBtnStyle1(button: cancelOrderBtn)
        interfaceStyleFunc.setBtnStyle1(button: carrierInfoBtn)
        interfaceStyleFunc.setBtnStyle1(button: orderDetailsBtn)
        
        dataOfOrders.getOrderDataFromFirebase(researchedKey: "order_Id", equalToValue: orderId)
        dataOfOrders.getAutoId(researchKey: "order_Id", equalToValue: orderId)
        
        print(orderId)
        
        qrBtn.isHidden = true
        ratingBtn.isHidden = true
        orderDetailsBtn.isHidden = true
        carrierInfoBtn.isHidden = true
        cancelOrderBtn.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayInfoAndBtn), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CustomerOrderInfoVCToOrderListVC", sender: self)
        
    }
    
    
    @IBAction func qrBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CustomerOrderInfoVCToQRVC", sender: self)
        
    }
    
    @IBAction func orderDetailBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CustomerOrderInfoVCToOrderInfoVC", sender: self)
        
    }
    
    @IBAction func carrierInfoBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CustomerOrderInfoVCToCarrierInfoVC", sender: self)
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Order Cancel Confirm", message: "Are you sure to cancel this order which has aready been placed? This operation can not be withdrawn.", preferredStyle: UIAlertController.Style.alert)
        
        let alertActionYes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (alertAction) in
            
            self.databaseRef.child("orders").child(self.dataOfOrders.autoId).removeValue()
            
            self.performSegue(withIdentifier: "CustomerOrderInfoVCToMyOrderVC", sender: self)
            
        }
        
        let alertActionNo = UIAlertAction(title: "No", style: UIAlertAction.Style.default) { (alertAction) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionYes)
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func ratingBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CustomerOrderInfoVCToRateVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CustomerOrderInfoVCToOrderListVC"{
            
            let destinationVC = segue.destination as! OrderListVC
            destinationVC.listType = self.listType
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            timer.invalidate()
            
        }
        
        if segue.identifier == "CustomerOrderInfoVCToCarrierInfoVC"{
            
            let destinationVC = segue.destination as! CarrierInfoVC
            destinationVC.listType = self.listType
            destinationVC.orderIdString = self.orderId
            destinationVC.carrierIdString = self.carrierIdString
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            
        }
        
        if segue.identifier == "CustomerOrderInfoVCToRateVC"{
            
            let destinationVC = segue.destination as! CustomRatingVC
            destinationVC.listType = self.listType
            destinationVC.customerIdString = self.customerId
            destinationVC.carrierIdString = self.carrierIdString
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            destinationVC.orderId = self.orderId
            
        }
        
        if segue.identifier == "CustomerOrderInfoVCToQRVC"{
            
            let destinationVC = segue.destination as! QRVC
            destinationVC.orderId = self.orderId
            destinationVC.listType = self.listType
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            
        }
        
        if segue.identifier == "CustomerOrderInfoVCToOrderInfoVC"{
            
            let destinationVC = segue.destination as! OrderDetailsVC
            destinationVC.listType = self.listType
            destinationVC.isfromCustomer = self.isfromCustomer
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            destinationVC.orderID = self.orderId
            
        }
        
    }
    
    
    @objc func displayInfoAndBtn(){
        
        orderIdLabel.text = dataOfOrders.order_Id
        statusLabel.text = dataOfOrders.order_Status
        pickUpTimeLabel.text = dataOfOrders.order_PickedTime
        deliveredTimeLabel.text = dataOfOrders.order_DeliverdTime
        carrierId.text = dataOfOrders.order_CarrierId
        orderDistance.text = dataOfOrders.order_Distance
        rewardLabel.text = "$ \(dataOfOrders.order_ItemReward)"
        ratingLabel.text = dataOfOrders.order_Star
        
        customerId = dataOfOrders.order_CustomerId
        carrierIdString = dataOfOrders.order_CarrierId
        orderStatus = dataOfOrders.order_Status
        orderRateContentForCustomer = dataOfOrders.order_RateContentForCustomer
        orderStatusContentForCustomer = dataOfOrders.order_StatusContentForCustomer
        
        if orderStatus == "Placed"{
            
            cancelOrderBtn.frame = carrierInfoBtn.frame
            
            ratingBtn.isHidden = true
            qrBtn.isHidden = false
            orderDetailsBtn.isHidden = false
            carrierInfoBtn.isHidden = true
            cancelOrderBtn.isHidden = false
            
        }else if orderStatusContentForCustomer == customerId + "Taken"{
            
            ratingBtn.isHidden = true
            qrBtn.isHidden = false
            orderDetailsBtn.isHidden = false
            carrierInfoBtn.isHidden = false
            cancelOrderBtn.isHidden = true
            
        }else if orderRateContentForCustomer == customerId + "WaitForRated"{
            
            ratingBtn.isHidden = false
            qrBtn.isHidden = true
            orderDetailsBtn.isHidden = false
            carrierInfoBtn.isHidden = false
            cancelOrderBtn.isHidden = true
            
        }else if orderRateContentForCustomer == customerId + "Rated"{
            
            orderDetailsBtn.frame = ratingBtn.frame
            
            ratingBtn.isHidden = true
            qrBtn.isHidden = true
            orderDetailsBtn.isHidden = false
            carrierInfoBtn.isHidden = true
            cancelOrderBtn.isHidden = true
            
        }
 
    }
    
}


