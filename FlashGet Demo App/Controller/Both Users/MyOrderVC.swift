//
//  MyOrderVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit

class MyOrderVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
 
    @IBOutlet weak var proccessBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    
    var userType: String = ""
    var listType: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle2(button: proccessBtn)
        interfaceStyleFunc.setBtnStyle2(button: completedBtn)

    }
    
    
    @IBAction func proccessBtnPressed(_ sender: Any) {
        
        if userType == "Customer"{
            
            listType = "CustomerOnProcessingOrder"
            performSegue(withIdentifier: "MyOrderVCToOrderListVC", sender: self)
            
        }else if userType == "Carrier"{
            
            listType = "CarrierOnProcessingOrder"
            performSegue(withIdentifier: "MyOrderVCToOrderListVC", sender: self)
            
        }
     
    }
    
    @IBAction func completedBtnPressed(_ sender: Any) {
        
        if userType == "Customer"{
            
            listType = "CustomerCompletedOrder"
            performSegue(withIdentifier: "MyOrderVCToOrderListVC", sender: self)
            
        }else if userType == "Carrier"{
            
            listType = "CarrierCompletedOrder"
            performSegue(withIdentifier: "MyOrderVCToOrderListVC", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MyOrderVCToOrderListVC"{
            
            let destinationVC = segue.destination as! OrderListVC
            destinationVC.listType = self.listType
            destinationVC.userId = self.userId
            destinationVC.userType = userType
            
        }
        
    }
    

}
