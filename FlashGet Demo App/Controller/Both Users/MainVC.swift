//
//  MainVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-08.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var SignOutBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var btnGroupStackView: UIStackView!
    @IBOutlet weak var makeOrderBtn: UIButton!
    @IBOutlet weak var myOrdersBtn: UIButton!
    @IBOutlet weak var accountInfoEditBtn: UIButton!
    @IBOutlet weak var resetPasswordBtn: UIButton!
    
    let dataOfOrders = DataOfOrders()
    let myTools = MyTools()
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    let databaseRef = Database.database().reference()
    var userType: String = ""
    var userFirstName: String = ""
    var userLastName: String = ""
    var userGender: String = ""
    var userId:String = ""
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).withAlphaComponent(0)
        helloLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        helloLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.3)
        
        setBg()
        
        setBtn()
        
        getCurrentUserInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(displayInfo), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Sign Out Confrim", message: "Are you sure to sign out current account?", preferredStyle: UIAlertController.Style.alert)
        let alertActionNo = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (alertAction) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        let alertActionYes = UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default) { (alertAction) in
            
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "mainVCToSignInVC", sender: self)
            } catch {
                
                print(error)
                
            }
            
        }
        
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionYes)
        present(alertController, animated: true, completion: nil)
 
    }
    
    
    @IBAction func firstBtnPressed(_ sender: Any) {
        
        if userType == "Customer"{
            
            performSegue(withIdentifier: "GoToMakeAnOrderVC", sender: self)
            
        }else if userType == "Carrier"{
            
            performSegue(withIdentifier: "MainVCToOrderListVC", sender: self)
            
        }
        
    }
    
    @IBAction func secondBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "MainVCToMyOrderVC", sender: self)
        
    }
    
    @IBAction func thirdBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToAccountEditVC", sender: self)
        
    }
    
    @IBAction func fourthBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToResetPasswordVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MainVCToOrderListVC"{
            
            let destinationVC = segue.destination as! OrderListVC
            destinationVC.listType = "CarrierTakeOrder"
            destinationVC.userType = self.userType
            timer.invalidate()
            
        }
        
        if segue.identifier == "MainVCToMyOrderVC"{
            
            let destinationVC = segue.destination as! MyOrderVC
            destinationVC.userType = self.userType
            destinationVC.userId = self.userId
            timer.invalidate()
            
        }
        
    }
    
    func setBg(){
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        var image = UIImage(named: "bg2")
        image?.draw(in: self.view.bounds)
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: image!)
        
    }
    
    func setBtn(){
        
        interfaceStyleFunc.setSmallBtn(button: makeOrderBtn)
        interfaceStyleFunc.setSmallBtn(button: myOrdersBtn)
        interfaceStyleFunc.setSmallBtn(button: accountInfoEditBtn)
        interfaceStyleFunc.setSmallBtn(button: resetPasswordBtn)
        
        makeOrderBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
        myOrdersBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
        resetPasswordBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
        accountInfoEditBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7)
        
    }
    
    
    func getCurrentUserInfo(){
        
        let currentUserEmail = Auth.auth().currentUser?.email as String!
        
        databaseRef.child("users").queryOrdered(byChild: "user_Email").queryEqual(toValue: currentUserEmail).observeSingleEvent(of: DataEventType.childAdded) { (dataSnapshot) in
            
            if let userInfoDic = dataSnapshot.value as? [String : Any]{
                
                self.userType = userInfoDic["user_Type"] as! String
                self.userGender = userInfoDic["user_Gender"] as! String
                self.userFirstName = userInfoDic["user_FirstName"] as! String
                self.userLastName = userInfoDic["user_LastName"] as! String
                self.userId = userInfoDic["user_Id"] as! String
                
            }
            
        }
        
    }
    
    @objc func displayInfo(){
        
        helloLabel.text = "Hello  \(userGender) \(userLastName)"
        
        if userType == "Customer"{
            
            makeOrderBtn.setImage(UIImage(named: "MakeOrder"), for: UIControl.State.normal)
            
            
        }else{
            
            makeOrderBtn.setImage(UIImage(named: "TakeOrder"), for: UIControl.State.normal)
            
        }
        
        myOrdersBtn.setImage(UIImage(named: "MyOrder"), for: UIControl.State.normal)
        accountInfoEditBtn.setImage(UIImage(named: "AccountInfo"), for: UIControl.State.normal)
        resetPasswordBtn.setImage(UIImage(named: "Password"), for: UIControl.State.normal)
        
    }


}
