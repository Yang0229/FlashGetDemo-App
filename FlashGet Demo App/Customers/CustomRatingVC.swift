//
//  CustomRatingVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class CustomRatingVC: UIViewController {

    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var starsStackView: UIStackView!
    @IBOutlet weak var star1Btn: UIButton!
    @IBOutlet weak var star2Btn: UIButton!
    @IBOutlet weak var star3Btn: UIButton!
    @IBOutlet weak var star4Btn: UIButton!
    @IBOutlet weak var star5Btn: UIButton!
    
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    
    let starOn = UIImage(named: "star1")
    let starOff = UIImage(named: "star0")
    
    var starRating = 0
    var listType: String = ""
    var orderId: String = ""
    var carrierIdString: String = ""
    var customerIdString: String = ""
    var userId: String = ""
    var userType: String = ""
    
    let dataOfOrders = DataOfOrders()
    let databeseRef = Database.database().reference()
    let interfaceStyleFunc = InterfaceStyleFunc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle2(button: confirmBtn)
        dataOfOrders.getAutoId(researchKey: "order_Id", equalToValue: orderId)
        setStarsImage()
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "RateVCToCustomerOrderDetailVC", sender: self)
        
    }
    
    @IBAction func confirmBtnPressed(_ sender: Any) {
        
        databeseRef.child("orders").child(dataOfOrders.autoId).child("order_Star").setValue(String(starRating))
        databeseRef.child("orders").child(dataOfOrders.autoId).child("order_RateContentForCustomer").setValue(customerIdString + "Rated")
        databeseRef.child("orders").child(dataOfOrders.autoId).child("order_RateContentForCarrier").setValue(carrierIdString + "Rated")
        
        performSegue(withIdentifier: "RateVCToCustomerOrderDetailVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RateVCToCustomerOrderDetailVC"{
            
            let destinationVC = segue.destination as! CustomOrderInfoVC
            
            destinationVC.listType = self.listType
            destinationVC.orderId = self.orderId
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            
        }
        
    }
    
    
    @IBAction func star1BtnPressed(_ sender: Any) {
        
        star1Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        
        star2Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star3Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star4Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star5Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        
        starRating = 1
        
    }
    
    @IBAction func star2BtnPressed(_ sender: Any) {
        
        star1Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star2Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        
        star3Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star4Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star5Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        
        starRating = 2
    }
    
    @IBAction func star3BtnPressed(_ sender: Any) {
        
        star1Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star2Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star3Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        
        star4Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star5Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        
        starRating = 3
        
    }
    
    @IBAction func star4BtnPressed(_ sender: Any) {
        
        star1Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star2Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star3Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star4Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        
        star5Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        
        starRating = 4
        
    }
    
    @IBAction func star5BtnPressed(_ sender: Any) {
        
        star1Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star2Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star3Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star4Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        star5Btn.setBackgroundImage(starOn, for: UIControl.State.normal)
        
        starRating = 5
        
    }
    
    
    
    
    func setStarsImage(){
        
        star1Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star2Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star3Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star4Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        star5Btn.setBackgroundImage(starOff, for: UIControl.State.normal)
        
    }
    
    
    


}
