//
//  CarrierInfoVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit

class CarrierInfoVC: UIViewController {

    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    

    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var infoLabelStackView: UIStackView!
    @IBOutlet weak var carrierId: UILabel!
    @IBOutlet weak var registerTimeLabel: UILabel!
    @IBOutlet weak var finishedNum: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var pickUpPunctualityRateLabel: UILabel!
    @IBOutlet weak var deliveryPunctualityRateLabel: UILabel!
    
    let dataOfOrders = DataOfOrders()
    let dataOfUsers = DataOfUsers()
    var listType: String = ""
    var orderIdString: String = ""
    var carrierIdString:String = ""
    var userId: String = ""
    var userType: String = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataOfUsers.getUserDataFromFirebase(researchKey: "user_Id", equalToValue: carrierIdString)
        dataOfUsers.getCarrierRateInfo(carrierId: carrierIdString)
        dataOfUsers.getPickedOnTimeRateInfo(carrierId: carrierIdString)
        dataOfUsers.getDeliveredOnTimeRateInfo(carrierId: carrierIdString)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayLabel), userInfo: nil, repeats: true)
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "CarrierInfoVCToCustomerOrderDetailVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CarrierInfoVCToCustomerOrderDetailVC"{
            
            let destinationVC = segue.destination as! CustomOrderInfoVC
            
            destinationVC.listType = self.listType
            destinationVC.orderId = self.orderIdString
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            
            timer.invalidate()
            
        }
        
    }

    @objc func displayLabel(){
        
        dataOfUsers.calulateRate()
        dataOfUsers.calculatePickedRate()
        dataOfUsers.calculateDeliveredRate()
        
        let roundedPickRate = round(dataOfUsers.user_PickedOnTimeRateDouble * 10000) / 100
        let roundedDeliveryRate = round(dataOfUsers.user_DeliveredOnTimeRateDouble * 10000) / 100
        
        userPhotoImageView.image = dataOfUsers.user_UserPhotoImage
        carrierId.text = carrierIdString
        registerTimeLabel.text = dataOfUsers.user_RegisterTime
        ratingLabel.text = String(dataOfUsers.user_UserRatingDouble)
        finishedNum.text = String(dataOfUsers.finishedDataSnapshotForDelivered.count)
        pickUpPunctualityRateLabel.text = "\(String(roundedPickRate)) %"
        deliveryPunctualityRateLabel.text = "\(String(roundedDeliveryRate)) %"
        
//        print("pickedOnTime: \(dataOfUsers.user_PickedOnTimeDouble)")
//        print("pickedOnTimeRate: \(dataOfUsers.user_PickedOnTimeRateDouble)")
//        print("deOnTime: \(dataOfUsers.user_DeliveredOnTimeDouble)")
//        print("deOnTimeRate: \(dataOfUsers.user_DeliveredOnTimeRateDouble)")
//        print("starSum: \(dataOfUsers.starSum)")
//        print("starRate: \(dataOfUsers.user_UserRatingDouble)")
//        print(Double(dataOfUsers.pickedOnTimeDataSnapshot.count))
        
    }

}
