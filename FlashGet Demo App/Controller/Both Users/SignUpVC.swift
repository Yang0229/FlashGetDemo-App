//
//  signUpVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-07.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var typeBtnStackView: UIStackView!
    @IBOutlet weak var customBtn: UIButton!
    @IBOutlet weak var carrierBtn: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLibraryBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var mrBtn: UIButton!
    @IBOutlet weak var mrsBtn: UIButton!
    @IBOutlet weak var missBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainLabel: UILabel!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionPicker: UIPickerView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    
    let imagePickerController = UIImagePickerController()
    
    var userType: String?
    var userGender: String?
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    let dataOfUsers = DataOfUsers()
    
    var imagePickerData: Data?
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle2(button: signUpBtn)
        interfaceStyleFunc.setBtnStyle1(button: photoLibraryBtn)
        interfaceStyleFunc.setBtnStyle1(button: cameraBtn)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordAgainTextField.delegate = self
        phoneTextField.delegate = self
        answerTextField.delegate = self
        questionPicker.delegate = self
        questionPicker.dataSource = self
        imagePickerController.delegate = self
        
        setBtn()
        setPhotoImageView()
    
    }

 
    
    @IBAction func customBtnPressed(_ sender: Any) {
        
        customBtn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        customBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
            
        carrierBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        carrierBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        
        userType = "Customer"
        
        
    }
    
    @IBAction func carrierBtnPressed(_ sender: Any) {
            
        carrierBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        carrierBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
            
        customBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        customBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        
        userType = "Carrier"
        
    }
    
    
    @IBAction func photoLibraryBtnPressed(_ sender: Any) {
        
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
        imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        imagePickerController.allowsEditing = false
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imagePickerData = pickedImage.jpegData(compressionQuality: 0.5)
            photoImageView.image = pickedImage
            photoImageView.contentMode = .scaleToFill
            imagePickerController.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    @IBAction func mrBtnPressed(_ sender: Any) {
        
        self.mrBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.mrBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        
        self.mrsBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        self.mrsBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        self.missBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        self.missBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        
        userGender = "Mr."
        
    }
    
    @IBAction func mrsBtnPressed(_ sender: Any) {
        
        self.mrsBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.mrsBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        
        self.mrBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        self.mrBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        self.missBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        self.missBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        
        userGender = "Mrs."
        
    }
    
    @IBAction func missBtnPressed(_ sender: Any) {
        
        self.missBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        self.missBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: UIControl.State.normal)
        
        self.mrBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        self.mrBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        self.mrsBtn.backgroundColor = #colorLiteral(red: 0.6666069031, green: 0.6667050123, blue: 0.6665856242, alpha: 1)
        self.mrsBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControl.State.normal)
        
        userGender = "Miss."
        
    }

    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        getRegisterTime()
        getUserInfo()
        Auth.auth().createUser(withEmail: dataOfUsers.user_Email, password: passwordTextField.text!) { (user, error) in
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.dataOfUsers.user_Type
            changeRequest?.commitChanges { (error) in
            }
            
            print("sign up successful!")
            
        }
        uploadToFirebase()
        
        
    }
    
    
    
    func getRegisterTime(){
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm:ss"
        
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        self.dataOfUsers.user_RegisterTime = dateFormatter.string(from: now)
        self.dataOfUsers.user_RegisterTimeStamp = String(timeStamp)
    }
    
    
    func getUserInfo(){
        
        dataOfUsers.user_Type = userType!
        dataOfUsers.user_FirstName = firstNameTextField.text!
        dataOfUsers.user_LastName = lastNameTextField.text!
        dataOfUsers.user_Email = emailTextField.text!
        dataOfUsers.user_Phone = phoneTextField.text!
        dataOfUsers.user_Question = dataOfUsers.queetionsCN[questionPicker.selectedRow(inComponent: 0)]
        dataOfUsers.user_Answer = answerTextField.text!
        dataOfUsers.user_Gender = userGender!
        
        
    }
    
    
    func uploadToFirebase(){
    
        let randomNum = Int.random(in: 0...9999)
        let userId: String = dataOfUsers.user_RegisterTimeStamp + "\(randomNum)"
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userInfos: [String: Any] = ["user_Type": dataOfUsers.user_Type,
                                        "user_FirstName": dataOfUsers.user_FirstName,
                                        "user_LastName": dataOfUsers.user_LastName,
                                        "user_Email": dataOfUsers.user_Email,
                                        "user_Question": dataOfUsers.user_Question,
                                        "user_Answer": dataOfUsers.user_Answer,
                                        "user_Phone": dataOfUsers.user_Phone,
                                        "user_RegisterTime": dataOfUsers.user_RegisterTime,
                                        "user_RegisterTimeStamp": dataOfUsers.user_RegisterTimeStamp,
                                        "user_Gender": dataOfUsers.user_Gender,
                                        "user_Id": userId]
        
        ref.child("users").childByAutoId().setValue(userInfos)
        
        
        let storageRef = storage.reference()
        let userPhotoRef = storageRef.child("UserPhoto/\(userId).jpeg")
        
        let uploadTask = userPhotoRef.putData(imagePickerData!)
        
    }
    
    
    @IBAction func answerTextFieldBeginEditing(_ sender: Any) {
        
        interfaceStyleFunc.moveUpViewWhenKeyboardAppeared(uiview: contentView, moveValue: 300)
        
    }
    
    @IBAction func answerTextFieldEndEditing(_ sender: Any) {
        
        interfaceStyleFunc.moveDownViewWhenKeyboardDisAppeared(uiview: contentView, moveValue: 300)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataOfUsers.queetionsCN.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let content = dataOfUsers.queetionsCN[row]
        
        return content
    }
  
    
    func setBtn(){
        
        interfaceStyleFunc.setCornerRadi(uiview: customBtn, cornerName: [.topLeft, .bottomLeft], width: 10, height: 10)
        interfaceStyleFunc.setCornerRadi(uiview: carrierBtn, cornerName: [.topRight, .bottomRight], width: 10, height: 10)
        
        interfaceStyleFunc.setCornerRadi(uiview: mrBtn, cornerName: [.topLeft, .bottomLeft], width: 10, height: 10)
        interfaceStyleFunc.setCornerRadi(uiview: missBtn, cornerName: [.topRight, .bottomRight], width: 10, height: 10)
        
        interfaceStyleFunc.setSmallBtn(button: photoLibraryBtn)
        interfaceStyleFunc.setSmallBtn(button: cameraBtn)
        
    }
    
    func setPhotoImageView(){
        
        photoImageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }

    
    @IBAction func contentViewTouchDown(_ sender: Any) {
        
        self.contentView.endEditing(true)
        
    }
    
    //通过点击 return 键隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordAgainTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        answerTextField.resignFirstResponder()
        
        return true
        
    }
    
    //通过点击屏幕的空白区域隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        contentView.endEditing(true)
        scrollView.endEditing(true)
        
    }
    
    
    

}
