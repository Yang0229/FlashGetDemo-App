//
//  QRVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class QRVC: UIViewController {

    @IBOutlet weak var QrImageView: UIImageView!
    @IBOutlet weak var senderQrBtn: UIButton!
    @IBOutlet weak var receiverQrBtn: UIButton!
    
    
    
    let dataOfOrders = DataOfOrders()
    var listType: String = ""
    var orderId: String = ""
    var userId: String = ""
    var userType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataOfOrders.getOrderDataFromFirebase(researchedKey: "order_Id", equalToValue: orderId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    @IBAction func senderQrBtnPressed(_ sender: Any) {
        
        senderQrBtn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        senderQrBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        receiverQrBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        receiverQrBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        
        QrImageView.image = dataOfOrders.order_SenderQrImage
        print(dataOfOrders.order_SenderQrImage)
        
    }
    
    @IBAction func receiverQrBtnPressed(_ sender: Any) {
        
        receiverQrBtn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        receiverQrBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        senderQrBtn.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        senderQrBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        
        QrImageView.image = dataOfOrders.order_ReceiverQrImage
        print(dataOfOrders.order_ReceiverQrImage)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "QRVCToCustomerOrderDetailVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "QRVCToCustomerOrderDetailVC"{
            
            let destinationVC = segue.destination as! CustomOrderInfoVC
            
            destinationVC.listType = listType
            destinationVC.orderId = self.orderId
            destinationVC.userId = self.userId
            destinationVC.userType = self.userType
            
        }
        
    }

}
