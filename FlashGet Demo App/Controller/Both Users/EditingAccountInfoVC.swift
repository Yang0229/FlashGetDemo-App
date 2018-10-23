//
//  EditingAccountInfoVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-08.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit

class EditingAccountInfoVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLibraryBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var photoTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle2(button: saveBtn)
        interfaceStyleFunc.setBtnStyle1(button: photoLibraryBtn)
        interfaceStyleFunc.setBtnStyle1(button: cameraBtn)
        
        photoTextField.delegate = self
        
    }
    
    
    
    //通过点击 return 键隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        photoTextField.resignFirstResponder()
        
        return true
        
    }
    
    //通过点击屏幕的空白区域隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    
    

}
