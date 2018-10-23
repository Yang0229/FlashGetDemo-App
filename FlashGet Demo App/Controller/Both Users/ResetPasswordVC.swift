//
//  ResetPasswordVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-08.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainLabel: UILabel!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var email: String = ""
    var oldPassword:String = ""
    var newPassword:String = ""
    var newPasswordAgain:String = ""
    let user = Auth.auth().currentUser
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle2(button: saveBtn)
        oldPasswordTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        email = (user?.email)!
        oldPassword = oldPasswordTextField.text!
        newPassword = passwordTextField.text!
        newPasswordAgain = passwordAgainTextField.text!
        
        if newPassword == newPasswordAgain{
            
            resetPassword(email: email, oldPassword: oldPassword, toNewPassword: newPassword)
            
        }else{
            
            let alertController = UIAlertController(title: "Error", message: "The new password and confirm password must be same, please have a check and correct.", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
                alertController.dismiss(animated: true, completion: nil)
                
            })
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    func resetPassword(email: String, oldPassword: String, toNewPassword: String){
    
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        user?.reauthenticate(with: credential, completion: { (error) in
            if error != nil{
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                    
                    alertController.dismiss(animated: true, completion: nil)
                    
                })
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            }else{
                
                self.user?.updatePassword(to: self.newPassword, completion: { (error) in
                    
                    if error != nil{
                        
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                            
                            alertController.dismiss(animated: true, completion: nil)
                            
                        })
                        
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else{
                        
                        let alertController = UIAlertController(title: "Successed", message: "Your password has been reset successful. You will be sign out automatically and please sign in again using your new password.", preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                            
                            alertController.dismiss(animated: true, completion: nil)
                            
                            do{
                                
                                try Auth.auth().signOut()
                                self.performSegue(withIdentifier: "ResetpasswordVCToSginInVC", sender: self)
                                
                            }catch{
                                
                                print(error.localizedDescription)
                                
                            }
                    
                        })
                        
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    
                })
                
            }
        })
        
    }
    
    
    //通过点击 return 键隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        oldPasswordTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordAgainTextField.resignFirstResponder()
        
        return true
        
    }
    
    //通过点击屏幕的空白区域隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    


}
