//
//  CustomMakeOrderVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-08.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class CustomMakeOrderVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var itemPhotoImageView: UIImageView!
    @IBOutlet weak var photoLibraryBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var itemInfoBtn: UIButton!
    @IBOutlet weak var senderInfoBtn: UIButton!
    @IBOutlet weak var receiverInfoBtn: UIButton!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    @IBOutlet weak var itemInfoView: UIView!
    @IBOutlet weak var senderInfoView: UIView!
    @IBOutlet weak var receiverInfoView: UIView!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemCotegoryLabel: UILabel!
    @IBOutlet weak var itemCotegoryTextField: UITextField!
    @IBOutlet weak var itemWeightLabel: UILabel!
    @IBOutlet weak var itemWeightTextField: UITextField!
    @IBOutlet weak var itemRewardLabel: UILabel!
    @IBOutlet weak var itemRewardTextField: UITextField!
    @IBOutlet weak var itemInfoConfirmBtn: UIButton!
    
    @IBOutlet weak var senderFirstNameLabel: UILabel!
    @IBOutlet weak var senderFirstNameTextField: UITextField!
    @IBOutlet weak var senderLastNameLabel: UILabel!
    @IBOutlet weak var senderLastNameTextField: UITextField!
    @IBOutlet weak var senderPhoneLabel: UILabel!
    @IBOutlet weak var senderPhoneTextField: UITextField!
    @IBOutlet weak var senderAddressLabel: UILabel!
    @IBOutlet weak var senderAddressTextField: UITextField!
    @IBOutlet weak var senderRegionLabel: UILabel!
    @IBOutlet weak var senderRegionTextField: UITextField!
    @IBOutlet weak var senderZipLabel: UILabel!
    @IBOutlet weak var senderZipTextField: UITextField!
    @IBOutlet weak var senderOtherLabel: UILabel!
    @IBOutlet weak var senderOtherTextField: UITextField!
    @IBOutlet weak var senderPickTimeLabel: UILabel!
    @IBOutlet weak var senderDatePicker: UIDatePicker!
    @IBOutlet weak var senderConfirmBtn: UIButton!
    
    @IBOutlet weak var receiverFirstNameLabel: UILabel!
    @IBOutlet weak var receiverFirstNameTextField: UITextField!
    @IBOutlet weak var receiverLastNameLabel: UILabel!
    @IBOutlet weak var receiverLastNameTextField: UITextField!
    @IBOutlet weak var receiverPhoneLabel: UILabel!
    @IBOutlet weak var receiverPhoneTextField: UITextField!
    @IBOutlet weak var receiverAddressLabel: UILabel!
    @IBOutlet weak var receiverAddressTextField: UITextField!
    @IBOutlet weak var receiverRegionLabel: UILabel!
    @IBOutlet weak var receiverRegionTextField: UITextField!
    @IBOutlet weak var receiverZipLabel: UILabel!
    @IBOutlet weak var receiverZipTextField: UITextField!
    @IBOutlet weak var receiverOtherLabel: UILabel!
    @IBOutlet weak var receiverOtherTextField: UITextField!
    @IBOutlet weak var receiverDeliveryTimeLabel: UILabel!
    @IBOutlet weak var receiverDatePicker: UIDatePicker!
    @IBOutlet weak var receiverConfirmBtn: UIButton!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    
    let interfaceStyleFunc = InterfaceStyleFunc()
    let dataOfOrders = DataOfOrders()
    let myTools = MyTools()
    
    var isItemViewOpend : Bool = false
    var isSenderViewOpend : Bool = false
    var isReceiverViewOpend : Bool = false
    
    let imagePickerController = UIImagePickerController()
    let storage = Storage.storage()
    var imagePickerData: Data?
    var senderPickerTime: Date?
    var senderPickerTimeStamp: TimeInterval?
    var receiverPickerTime: Date?
    var receiverPickerTimeStamp: TimeInterval?
    
    var senderQRImage: UIImage?
    var receiverQRImage: UIImage?
    
    var userId: String = ""
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceStyleFunc.setBtnStyle1(button: photoLibraryBtn)
        interfaceStyleFunc.setBtnStyle1(button: cameraBtn)
        interfaceStyleFunc.setBtnStyle1(button: itemInfoBtn)
        interfaceStyleFunc.setBtnStyle1(button: senderInfoBtn)
        interfaceStyleFunc.setBtnStyle1(button: receiverInfoBtn)
        interfaceStyleFunc.setBtnStyle2(button: placeOrderBtn)
        interfaceStyleFunc.setBtnStyle2(button: itemInfoConfirmBtn)
        interfaceStyleFunc.setBtnStyle2(button: senderConfirmBtn)
        interfaceStyleFunc.setBtnStyle2(button: receiverConfirmBtn)
        
        scrollView.delegate = self
        imagePickerController.delegate = self
        getUserInfo()
     
        textFieldDelegate()

    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        hideViews()
        hideItemInfoContent()
        hideSenderInfoContent()
        hideReceiverInfoContent()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        resizeViews()
        adjustContentViewHeight(isItemViewOpend: isItemViewOpend, isSenderViewOpend: isSenderViewOpend, isReceiverViewOpend: isReceiverViewOpend)
        
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Leave Confirm", message: "Are you sure to back to the Main page now? The info that you entered will not be saved.", preferredStyle: UIAlertController.Style.alert)
        
        let alertActionNo = UIAlertAction(title: "Stay", style: UIAlertAction.Style.default) { (alertAction) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        let alertActionYes = UIAlertAction(title: "Leave", style: UIAlertAction.Style.default) { (alertAction) in
            
             self.performSegue(withIdentifier: "MakeOrderVCToMainVC", sender: self)
            
        }
        
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionYes)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // Photo Library & Camera Button Pressed
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
            
            imagePickerData = pickedImage.jpegData(compressionQuality: 0.5)!
            itemPhotoImageView.image = pickedImage
            itemPhotoImageView.contentMode = .scaleToFill
            imagePickerController.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    // Info Buttons Pressed
    @IBAction func itemInfoBtnPressed(_ sender: Any) {
        
        if !isItemViewOpend{
            
            isItemViewOpend = true
            openItemInfoView()
            senderInfoBtn.isEnabled = false
            receiverInfoBtn.isEnabled = false
            
        }else{
            
            isItemViewOpend = false
            closeItemInfoView()
            senderInfoBtn.isEnabled = true
            receiverInfoBtn.isEnabled = true
            
        }
 
    }
    
    @IBAction func senderInfoBtnPressed(_ sender: Any) {
        
        if !isSenderViewOpend{
            
            isSenderViewOpend = true
            openSenderInfoView()
            itemInfoBtn.isEnabled = false
            receiverInfoBtn.isEnabled = false
            
        }else{
            
            isSenderViewOpend = false
            closeSenderInfoView()
            itemInfoBtn.isEnabled = true
            receiverInfoBtn.isEnabled = true
         
        }
        
    }
    
    @IBAction func receiverInfoBtnPressed(_ sender: Any) {
        
        if !isReceiverViewOpend{
            
            isReceiverViewOpend = true
            openReceiverInfoView()
            itemInfoBtn.isEnabled = false
            senderInfoBtn.isEnabled = false
            
        }else{
            
            isReceiverViewOpend = false
            closeReceiverInfoView()
            itemInfoBtn.isEnabled = true
            senderInfoBtn.isEnabled = true
        
        }
        
    }
    
    
    
    // Confirm Button Pressed
    @IBAction func itemConfirmBtnPressed(_ sender: Any) {
        
        interfaceStyleFunc.emptyTextFieldCheck(sender: itemNameTextField, senderLabel: itemNameLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: itemCotegoryTextField, senderLabel: itemCotegoryLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: itemWeightTextField, senderLabel: itemWeightLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: itemRewardTextField, senderLabel: itemRewardLabel)
        if itemNameLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            itemCotegoryLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            itemWeightLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            itemRewardLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
            
            print("haha")
            itemInfoBtn.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            isItemViewOpend = false
            senderInfoBtn.isEnabled = true
            receiverInfoBtn.isEnabled = true
            closeItemInfoView()
            
        }else{
            
            itemInfoBtn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            
        }
    
    }
    
    @IBAction func senderConfirmBtnPressed(_ sender: Any) {
        
        interfaceStyleFunc.emptyTextFieldCheck(sender: senderFirstNameTextField, senderLabel: senderFirstNameLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: senderLastNameTextField, senderLabel: senderLastNameLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: senderPhoneTextField, senderLabel: senderPhoneLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: senderAddressTextField, senderLabel: senderAddressLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: senderRegionTextField, senderLabel: senderRegionLabel)
        //        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverZipTextField, senderLabel: receiverZipLabel)
        getLocationFromPostalCode(postalCode: senderZipTextField.text!, who: "sender")
        
        let currentTime = Date()
        let currentTimeInterval: TimeInterval = currentTime.timeIntervalSince1970
        let minTimeStamp = TimeInterval(currentTimeInterval)
        let minTime = Date(timeIntervalSince1970: minTimeStamp)
        senderDatePicker.minimumDate = minTime
        
        if Double(senderDatePicker.date.timeIntervalSince1970) > Double(currentTime.timeIntervalSince1970){
            
            senderPickTimeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }else{
            
            senderPickTimeLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            var alertController = UIAlertController()
            alertController = UIAlertController.init(title: "Invalid Delivery Time", message: "Your pick up time must later than the current time. Please correct your selection", preferredStyle: UIAlertController.Style.alert)
            var alertAction = UIAlertAction()
            alertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        if senderFirstNameLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            senderLastNameLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            senderPhoneLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            senderAddressLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            senderRegionLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            senderZipLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            senderPickTimeLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
            
            senderInfoBtn.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            
            isSenderViewOpend = false
            itemInfoBtn.isEnabled = true
            receiverInfoBtn.isEnabled = true
            closeSenderInfoView()
            
        }else{
            
            senderInfoBtn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            
        }
    }
    
    
    @IBAction func receiverConfirmBtnPressed(_ sender: Any) {
        
        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverFirstNameTextField, senderLabel: receiverFirstNameLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverLastNameTextField, senderLabel: receiverLastNameLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverPhoneTextField, senderLabel: receiverPhoneLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverAddressTextField, senderLabel: receiverAddressLabel)
        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverRegionTextField, senderLabel: receiverRegionLabel)
//        interfaceStyleFunc.emptyTextFieldCheck(sender: receiverZipTextField, senderLabel: receiverZipLabel)
        getLocationFromPostalCode(postalCode: receiverZipTextField.text!, who: "receiver")
        
        let currentTime = Date()
        let currentTimeInterval: TimeInterval = currentTime.timeIntervalSince1970
        let minTimeStamp = TimeInterval(Int(currentTimeInterval) - 1800)
        let minTime = Date(timeIntervalSince1970: minTimeStamp)
        receiverDatePicker.minimumDate = minTime
        
        if Double(senderDatePicker.date.timeIntervalSince1970) <= Double(receiverDatePicker.date.timeIntervalSince1970){
            
            receiverDeliveryTimeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }else{
            
            receiverDeliveryTimeLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            var alertController = UIAlertController()
            alertController = UIAlertController.init(title: "Invalid Delivery Time", message: "Your delivery time can not earlier than both the pick up time and current time. Please correct your selection", preferredStyle: UIAlertController.Style.alert)
            var alertAction = UIAlertAction()
            alertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        if receiverFirstNameLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            receiverLastNameLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            receiverPhoneLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            receiverAddressLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            receiverRegionLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            receiverZipLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) &&
            receiverDeliveryTimeLabel.textColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1){
            
            receiverInfoBtn.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            
                    isReceiverViewOpend = false
                    itemInfoBtn.isEnabled = true
                    senderInfoBtn.isEnabled = true
                    closeReceiverInfoView()
            
        }else{
            
            receiverInfoBtn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            
        }
        
    }
    
    
    
    // Place Order Button Pressed
    @IBAction func placeOrderBtnPressed(_ sender: Any) {
        
        var isInfoCompeleted: Bool = false
        var isItemPhotoCompeleted: Bool = false
        
        let alertController = UIAlertController(title: "Place Order Confirm", message: "Are you sure to place this order now? You can cancel any order you placed before it was taken by carrier.", preferredStyle: UIAlertController.Style.alert)
        let alertActionNo = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (alertAction) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
        let alertActionYes = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (alertAction) in
            
            if self.itemInfoBtn.backgroundColor == #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) && self.senderInfoBtn.backgroundColor == #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1) && self.receiverInfoBtn.backgroundColor == #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1){
                
                isInfoCompeleted = true
                
            }else{
                
                var alertController = UIAlertController()
                alertController = UIAlertController.init(title: "Info Not Completed", message: "Sorry, you have not complete all requried infomation. Please have a check!", preferredStyle: UIAlertController.Style.alert)
                var alertAction = UIAlertAction()
                alertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            if let itemImage = self.itemPhotoImageView.image{
                
                isItemPhotoCompeleted = true
                
            }else{
                
                var alertController = UIAlertController()
                alertController = UIAlertController.init(title: "Info Not Completed", message: "Sorry, you might forgot to upload a picture of the product.", preferredStyle: UIAlertController.Style.alert)
                var alertAction = UIAlertAction()
                alertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            if isInfoCompeleted == true && isItemPhotoCompeleted == true{
                
                self.getOrderInfo()
                self.getPlacedTime()
                self.calculateDistance()
                self.CreateQR()
                self.uploadToFirebase()
                
            }

        }
        
        alertController.addAction(alertActionNo)
        alertController.addAction(alertActionYes)
        
        present(alertController, animated: true, completion: nil)

    }
    
    
    
    
    
    

    func getPlacedTime(){
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm:ss"
        
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print(dataOfOrders.order_PlaceTime)
        self.dataOfOrders.order_PlaceTime = dateFormatter.string(from: now)
        self.dataOfOrders.order_PlaceTimeStamp = String(timeStamp)
    }

    
    
    func getOrderInfo(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm:ss"
        
        senderPickerTime = senderDatePicker.date
        receiverPickerTime = receiverDatePicker.date
        
        senderPickerTimeStamp = senderPickerTime!.timeIntervalSince1970
        receiverPickerTimeStamp = receiverPickerTime!.timeIntervalSince1970
        
        dataOfOrders.order_ItemName = itemNameTextField.text!
        dataOfOrders.order_ItemCategory = itemCotegoryTextField.text!
        dataOfOrders.order_ItemWeight = itemWeightTextField.text!
        dataOfOrders.order_ItemReward = itemRewardTextField.text!
        
        dataOfOrders.order_SenderFirstName = senderFirstNameTextField.text!
        dataOfOrders.order_SenderLastName = senderLastNameTextField.text!
        dataOfOrders.order_SenderPhone = senderPhoneTextField.text!
        dataOfOrders.order_SenderAddress = senderAddressTextField.text!
        dataOfOrders.order_SenderRegion = senderRegionTextField.text!
        dataOfOrders.order_SenderZipCode = senderZipTextField.text!
        dataOfOrders.order_SenderDesc = senderOtherTextField.text!
        dataOfOrders.order_SenderPickUpTime = dateFormatter.string(from: senderPickerTime!)
        dataOfOrders.order_SenderPickUpTimeStamp = String(Int(senderPickerTimeStamp!))
        
        dataOfOrders.order_ReceiverFirstName = receiverFirstNameTextField.text!
        dataOfOrders.order_ReceiverLastName = receiverLastNameTextField.text!
        dataOfOrders.order_ReceiverPhone = receiverPhoneTextField.text!
        dataOfOrders.order_ReceiverAddress = receiverAddressTextField.text!
        dataOfOrders.order_ReceiverRegion = receiverRegionTextField.text!
        dataOfOrders.order_ReceiverZipCode = receiverZipTextField.text!
        dataOfOrders.order_ReceiverDesc = receiverOtherTextField.text!
        dataOfOrders.order_ReceiverDeliveredTime = dateFormatter.string(from: receiverPickerTime!)
        dataOfOrders.order_ReceiverDeliveredTimeStamp = String(Int(receiverPickerTimeStamp!))
        
    }
    
    
    func getUserInfo(){
        
        let userRef = Database.database().reference().child("users")
        let email = Auth.auth().currentUser?.email
        userRef.queryOrdered(byChild: "user_Email").queryEqual(toValue: email).observe(DataEventType.childAdded) { (dataSnapshot) in
            
            if let userDic = dataSnapshot.value as? [String : Any]{
                
                if let user_Id = userDic["user_Id"] as? String{
                    
                    self.userId = user_Id
                    
                }
                
            }
            
        }
        
    }
    
    //    func handler(sender: UIDatePicker) {
    //        var dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm:ss"
    //        senderPickTime = dateFormatter.date
    //
    ////        var strDate = timeFormatter.string(from: senderDatePicker.date)
    //        // do what you want to do with the string.
    //    }
    
    
    
    func getLocationFromPostalCode(postalCode : String, who: String){ // who value type: sender Or receiver
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(postalCode) {
            (placemarks, error) -> Void in
            // Placemarks is an optional array of type CLPlacemarks, first item in array is best guess of Address
            
            if postalCode == ""{
                
                if who == "sender"{
                    
                    self.senderZipLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    
                }else if who == "receiver"{
                    
                    self.receiverZipLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                    
                }
            }
            
            if let placemark = placemarks?[0] {
                
                if placemark.postalCode == postalCode{
                    
                    let latitude: CLLocationDegrees = (placemark.location?.coordinate.latitude)!
                    let longitude: CLLocationDegrees = (placemark.location?.coordinate.longitude)!
                    
                    if who == "sender"{
                        
                        self.dataOfOrders.order_SenderLat = String(Double(latitude))
                        self.dataOfOrders.order_SenderLon = String(Double(longitude))
                        self.dataOfOrders.convertToCLLocation(lat: latitude, Lon: longitude, who: who)
                        self.senderZipLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        
                    }else if who == "receiver"{
                        
                        self.dataOfOrders.order_ReceiverLat = String(Double(latitude))
                        self.dataOfOrders.order_ReceiverLon = String(Double(longitude))
                        self.dataOfOrders.convertToCLLocation(lat: latitude, Lon: longitude, who: who)
                        self.receiverZipLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                        
                    }
                    
                }else{
                    if who == "sender"{
                    
                        var alertController = UIAlertController()
                        alertController = UIAlertController.init(title: "Invalid Postal code", message: "Please correct your Postal code.(Use the style like: M8V 0A5)", preferredStyle: UIAlertController.Style.alert)
                        var alertAction = UIAlertAction()
                        alertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else if who == "receiver"{
                        
                        var alertController = UIAlertController()
                        alertController = UIAlertController.init(title: "Invalid Postal code", message: "Please correct your Postal code.(Use the style like: M8V 0A5)", preferredStyle: UIAlertController.Style.alert)
                        var alertAction = UIAlertAction()
                        alertAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
        
                }
                
            }
        }
    }
    
    
    func calculateDistance(){
        
        if let location1 = dataOfOrders.order_senderLocation{
            
            if let location2 = dataOfOrders.order_receiverLocation{
                
                let distance: CLLocationDistance = location1.distance(from: location2)
                dataOfOrders.order_Distance = String(distance)
                
            }
        }
        
    }
    
    
    func CreateQR(){
        
        let randomNum1 = Int.random(in: 0...9999)
        let randomNum2 = Int.random(in: 0...9999)
        let senderQRContent: String = "\(randomNum1)" + dataOfOrders.order_PlaceTimeStamp + "\(randomNum2)" + "senderQR"
        let receiverQRContent: String = "\(randomNum1)" + dataOfOrders.order_PlaceTimeStamp + "\(randomNum2)" + "receiverQR"
        
        dataOfOrders.order_SenderQRContent = senderQRContent
        dataOfOrders.order_ReceiverQRContent = receiverQRContent
        
        senderQRImage = myTools.QrCodeGenerator(content: dataOfOrders.order_SenderQRContent)
        receiverQRImage = myTools.QrCodeGenerator(content: dataOfOrders.order_ReceiverQRContent)
        
    }
    
    
    
    func uploadToFirebase(){
        
        let randomNum1 = Int.random(in: 1000...9999)
        let randomNum2 = Int.random(in: 1000...9999)
        let randomNum3 = Int.random(in: 1000...9999)
        let randomNum4 = Int.random(in: 1000...9999)
        
        let orderId: String = dataOfOrders.order_PlaceTimeStamp + "\(randomNum1)"
        let randomNum2String = String(randomNum2)
        let randomNum3String = String(randomNum3)
        let randomNum4String = String(randomNum4)
        
        let rateContentForCustomer = userId + "NotRated"
        let statusContentForCustomer = userId + "Placed"

        dataOfOrders.order_ItemPhotoName = orderId + randomNum2String + "-ItemPhoto"
        
        dataOfOrders.order_SenderQRName = orderId + randomNum3String + "-SenderQR"
        dataOfOrders.order_ReceiverQRName = orderId + randomNum4String + "-ReceiverQR"
        
        let orderInfos: [String: Any] = ["order_Id": orderId,
                                         "order_Status": "Placed",
                                         "order_Distance": dataOfOrders.order_Distance,
                                         "order_PlaceTime": dataOfOrders.order_PlaceTime,
                                         "order_PlaceTimeStamp": dataOfOrders.order_PlaceTimeStamp,
                                         "order_ItemName": dataOfOrders.order_ItemName,
                                         "order_ItemCategory": dataOfOrders.order_ItemCategory,
                                         "order_ItemWeight": dataOfOrders.order_ItemWeight,
                                         "order_ItemReward": dataOfOrders.order_ItemReward,
                                         "order_SenderFirstName": dataOfOrders.order_SenderFirstName,
                                         "order_SenderLastName": dataOfOrders.order_SenderLastName,
                                         "order_SenderPhone": dataOfOrders.order_SenderPhone,
                                         "order_SenderAddress": dataOfOrders.order_SenderAddress,
                                         "order_SenderRegion": dataOfOrders.order_SenderRegion,
                                         "order_SenderZipCode": dataOfOrders.order_SenderZipCode,
                                         "order_SenderDesc": dataOfOrders.order_SenderDesc,
                                         "order_SenderPickUpTime": dataOfOrders.order_SenderPickUpTime,
                                         "order_SenderPickUpTimeStamp": dataOfOrders.order_SenderPickUpTimeStamp,
                                         "order_SenderLat": dataOfOrders.order_SenderLat,
                                         "order_SenderLon": dataOfOrders.order_SenderLon,
                                         "order_ReceiverFirstName": dataOfOrders.order_ReceiverFirstName,
                                         "order_ReceiverLastName": dataOfOrders.order_ReceiverLastName,
                                         "order_ReceiverPhone": dataOfOrders.order_ReceiverPhone,
                                         "order_ReceiverAddress": dataOfOrders.order_ReceiverAddress,
                                         "order_ReceiverRegion": dataOfOrders.order_ReceiverRegion,
                                         "order_ReceiverZipCode": dataOfOrders.order_ReceiverZipCode,
                                         "order_ReceiverDesc": dataOfOrders.order_ReceiverDesc,
                                         "order_ReceiverDeliveredTime": dataOfOrders.order_ReceiverDeliveredTime,
                                         "order_ReceiverDeliveredTimeStamp": dataOfOrders.order_ReceiverDeliveredTimeStamp,
                                         "order_SenderQRName": dataOfOrders.order_SenderQRName,
                                         "order_ReceiverQRName": dataOfOrders.order_ReceiverQRName,
                                         "order_SenderQRContent": dataOfOrders.order_SenderQRContent,
                                         "order_ReceiverQRContent": dataOfOrders.order_ReceiverQRContent,
                                         "order_ReceiverLat": dataOfOrders.order_ReceiverLat,
                                         "order_ReceiverLon": dataOfOrders.order_ReceiverLon,
                                         "order_CarrierId": "",
                                         "order_PickedTime": "",
                                         "order_PickedTimeStamp": "",
                                         "order_DeliveredTime": "",
                                         "order_ItemPhotoName": dataOfOrders.order_ItemPhotoName,
                                         "order_CustomerId": self.userId,
                                         "order_Star": "",
                                         "order_RateContentForCustomer": rateContentForCustomer,
                                         "order_RateContentForCarrier": "",
                                         "order_StatusContentForCustomer": statusContentForCustomer,
                                         "order_StatusContentForCarrier": "",
                                         "order_IsDeliveredLate": "",
                                         "order_IsPickedLate": ""]
//        print(orderInfos)
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("orders").childByAutoId().setValue(orderInfos)

        let storageRef = storage.reference()
        let itemPhotoRef = storageRef.child("itemPhoto").child(dataOfOrders.order_ItemPhotoName + ".jpeg")
        let senderQRRef = storageRef.child("senderQR").child(dataOfOrders.order_SenderQRName + ".jpeg")
        let receiverQRRef = storageRef.child("receiverQR").child(dataOfOrders.order_ReceiverQRName + ".jpeg")

        let uploadTask = itemPhotoRef.putData(imagePickerData!)
        let uploadTask1 = senderQRRef.putData((senderQRImage?.jpegData(compressionQuality: 0.5))!)
        let uploadTask2 = receiverQRRef.putData((receiverQRImage?.jpegData(compressionQuality: 0.5))!)
        
        let alertController = UIAlertController(title: "Congratulation", message: "Your order has been placed successful!", preferredStyle: UIAlertController.Style.alert)
        let alertActionOk = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
            
            alertController.dismiss(animated: true, completion: {
                
                self.performSegue(withIdentifier: "MakeOrderVCToMainVC", sender: self)
                
            })
            
        }
        alertController.addAction(alertActionOk)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func resizeViews(){
        
        itemInfoView.frame = CGRect(x: itemInfoView.frame.origin.x, y: itemInfoView.frame.origin.y, width: itemInfoView.frame.width, height: 60)
        senderInfoView.frame = CGRect(x: senderInfoView.frame.origin.x, y: senderInfoView.frame.origin.y, width: senderInfoView.frame.width, height: 60)
        receiverInfoView.frame = CGRect(x: receiverInfoView.frame.origin.x, y: receiverInfoView.frame.origin.y, width: receiverInfoView.frame.width, height: 60)
        
    }
    
    
    func hideViews(){
        
        itemInfoView.alpha = 0
        senderInfoView.alpha = 0
        receiverInfoView.alpha = 0
        
    }
    
    // Open Info Views
    func openItemInfoView(){
        
        itemInfoView.alpha = 1
        adjustContentViewHeight(isItemViewOpend: isItemViewOpend, isSenderViewOpend: isSenderViewOpend, isReceiverViewOpend: isReceiverViewOpend)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.itemInfoView.frame = CGRect(x: self.itemInfoView.frame.origin.x, y: self.itemInfoView.frame.origin.y, width: self.itemInfoView.frame.width, height: 460)
            self.senderInfoView.center.y += 400
            self.receiverInfoView.center.y += 400
            self.senderInfoBtn.center.y += 400
            self.receiverInfoBtn.center.y += 400
            self.placeOrderBtn.center.y += 400
            
        }) { (finished) in
            
            self.showItemInfoContent()
            
        }
        
    }
    
    
    func openSenderInfoView(){
        
        senderInfoView.alpha = 1
        
        adjustContentViewHeight(isItemViewOpend: isItemViewOpend, isSenderViewOpend: isSenderViewOpend, isReceiverViewOpend: isReceiverViewOpend)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.senderInfoView.frame = CGRect(x: self.senderInfoView.frame.origin.x, y: self.senderInfoView.frame.origin.y, width: self.senderInfoView.frame.width, height: 820)
            self.receiverInfoView.center.y += 760
            self.receiverInfoBtn.center.y += 760
            self.placeOrderBtn.center.y += 760
            
        }) { (finished) in
            
            self.showSenderInfoContent()
            
        }
        
    }
    
    
    func openReceiverInfoView(){
        
        receiverInfoView.alpha = 1
        
        adjustContentViewHeight(isItemViewOpend: isItemViewOpend, isSenderViewOpend: isSenderViewOpend, isReceiverViewOpend: isReceiverViewOpend)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.receiverInfoView.frame = CGRect(x: self.receiverInfoView.frame.origin.x, y: self.receiverInfoView.frame.origin.y, width: self.receiverInfoView.frame.width, height: 820)
            
            self.placeOrderBtn.center.y += 760
            
        }) { (finished) in
            
            self.showReceiverInfoContent()
            
        }
        
    }
    
    
    // Close Info Views
    func closeItemInfoView(){
        
        hideItemInfoContent()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.itemInfoView.frame = CGRect(x: self.itemInfoView.frame.origin.x, y: self.itemInfoView.frame.origin.y, width: self.itemInfoView.frame.width, height: 60)
            self.senderInfoView.center.y -= 400
            self.receiverInfoView.center.y -= 400
            self.senderInfoBtn.center.y -= 400
            self.receiverInfoBtn.center.y -= 400
            self.placeOrderBtn.center.y -= 400
            
        }) { (finished) in
            
            self.itemInfoView.alpha = 0
            self.adjustContentViewHeight(isItemViewOpend: self.isItemViewOpend, isSenderViewOpend: self.isSenderViewOpend, isReceiverViewOpend: self.isReceiverViewOpend)
            
        }
        
    }
    
    
    func closeSenderInfoView(){
        
        hideSenderInfoContent()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.senderInfoView.frame = CGRect(x: self.senderInfoView.frame.origin.x, y: self.senderInfoView.frame.origin.y, width: self.senderInfoView.frame.width, height: 60)
            self.receiverInfoView.center.y -= 760
            self.receiverInfoBtn.center.y -= 760
            self.placeOrderBtn.center.y -= 760
            
        }) { (finished) in
            
            self.senderInfoView.alpha = 0
            self.adjustContentViewHeight(isItemViewOpend: self.isItemViewOpend, isSenderViewOpend: self.isSenderViewOpend, isReceiverViewOpend: self.isReceiverViewOpend)
            
        }
        
    }
    
    
    func closeReceiverInfoView(){
        
        hideReceiverInfoContent()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.receiverInfoView.frame = CGRect(x: self.receiverInfoView.frame.origin.x, y: self.receiverInfoView.frame.origin.y, width: self.receiverInfoView.frame.width, height: 60)
            
            self.placeOrderBtn.center.y -= 760
            
        }) { (finished) in
            
            self.receiverInfoView.alpha = 0
            self.adjustContentViewHeight(isItemViewOpend: self.isItemViewOpend, isSenderViewOpend: self.isSenderViewOpend, isReceiverViewOpend: self.isReceiverViewOpend)
            
        }
        
    }
    
    
    // hide info content
    func hideItemInfoContent(){
        
        itemNameLabel.alpha = 0
        itemNameTextField.alpha = 0
        itemCotegoryLabel.alpha = 0
        itemCotegoryTextField.alpha = 0
        itemWeightLabel.alpha = 0
        itemWeightTextField.alpha = 0
        itemRewardLabel.alpha = 0
        itemRewardTextField.alpha = 0
        itemInfoConfirmBtn.alpha = 0
        
    }
    
    
    func hideSenderInfoContent(){
        
        senderFirstNameLabel.alpha = 0
        senderFirstNameTextField.alpha = 0
        senderLastNameLabel.alpha = 0
        senderLastNameTextField.alpha = 0
        senderPhoneLabel.alpha = 0
        senderPhoneTextField.alpha = 0
        senderAddressLabel.alpha = 0
        senderAddressTextField.alpha = 0
        senderRegionLabel.alpha = 0
        senderRegionTextField.alpha = 0
        senderZipLabel.alpha = 0
        senderZipTextField.alpha = 0
        senderOtherLabel.alpha = 0
        senderOtherTextField.alpha = 0
        senderPickTimeLabel.alpha = 0
        senderDatePicker.alpha = 0
        senderConfirmBtn.alpha = 0
        
    }
    
    func hideReceiverInfoContent(){
        
        receiverFirstNameLabel.alpha = 0
        receiverFirstNameTextField.alpha = 0
        receiverLastNameLabel.alpha = 0
        receiverLastNameTextField.alpha = 0
        receiverPhoneLabel.alpha = 0
        receiverPhoneTextField.alpha = 0
        receiverAddressLabel.alpha = 0
        receiverAddressTextField.alpha = 0
        receiverRegionLabel.alpha = 0
        receiverRegionTextField.alpha = 0
        receiverZipLabel.alpha = 0
        receiverZipTextField.alpha = 0
        receiverOtherLabel.alpha = 0
        receiverOtherTextField.alpha = 0
        receiverDeliveryTimeLabel.alpha = 0
        receiverDatePicker.alpha = 0
        receiverConfirmBtn.alpha = 0
        
    }
    
    
    // show info content
    func showItemInfoContent(){
        
        itemNameLabel.alpha = 1
        itemNameTextField.alpha = 1
        itemCotegoryLabel.alpha = 1
        itemCotegoryTextField.alpha = 1
        itemWeightLabel.alpha = 1
        itemWeightTextField.alpha = 1
        itemRewardLabel.alpha = 1
        itemRewardTextField.alpha = 1
        itemInfoConfirmBtn.alpha = 1
        
    }
    
    func showSenderInfoContent(){
        
        senderFirstNameLabel.alpha = 1
        senderFirstNameTextField.alpha = 1
        senderLastNameLabel.alpha = 1
        senderLastNameTextField.alpha = 1
        senderPhoneLabel.alpha = 1
        senderPhoneTextField.alpha = 1
        senderAddressLabel.alpha = 1
        senderAddressTextField.alpha = 1
        senderRegionLabel.alpha = 1
        senderRegionTextField.alpha = 1
        senderZipLabel.alpha = 1
        senderZipTextField.alpha = 1
        senderOtherLabel.alpha = 1
        senderOtherTextField.alpha = 1
        senderPickTimeLabel.alpha = 1
        senderDatePicker.alpha = 1
        senderConfirmBtn.alpha = 1
        
    }
    
    func showReceiverInfoContent(){
        
        receiverFirstNameLabel.alpha = 1
        receiverFirstNameTextField.alpha = 1
        receiverLastNameLabel.alpha = 1
        receiverLastNameTextField.alpha = 1
        receiverPhoneLabel.alpha = 1
        receiverPhoneTextField.alpha = 1
        receiverAddressLabel.alpha = 1
        receiverAddressTextField.alpha = 1
        receiverRegionLabel.alpha = 1
        receiverRegionTextField.alpha = 1
        receiverZipLabel.alpha = 1
        receiverZipTextField.alpha = 1
        receiverOtherLabel.alpha = 1
        receiverOtherTextField.alpha = 1
        receiverDeliveryTimeLabel.alpha = 1
        receiverDatePicker.alpha = 1
        receiverConfirmBtn.alpha = 1
        
    }
    
    // Adjust The Height Of ScrollView Content Area
    func adjustContentViewHeight(isItemViewOpend : Bool, isSenderViewOpend : Bool, isReceiverViewOpend : Bool){

        switch (isItemViewOpend, isSenderViewOpend, isReceiverViewOpend){

            case (false, false, false) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8

            case (true, false, false) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 400

            case (true, true, false) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 1160

            case (true, true, true) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 1920

            case (false, true, false) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 760

            case (false, true, true) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 1520

            case (false, false, true) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 760

            case (true, false, true) : self.contentViewHeight.constant = self.view.frame.height * 7 / 8 + 1160
        }

        self.view.layoutIfNeeded()

    }

    
    
    
    func textFieldDelegate(){
        
        itemNameTextField.delegate = self
        itemCotegoryTextField.delegate = self
        itemWeightTextField.delegate = self
        itemRewardTextField.delegate = self
        
        senderFirstNameTextField.delegate = self
        senderLastNameTextField.delegate = self
        senderPhoneTextField.delegate = self
        senderAddressTextField.delegate = self
        senderRegionTextField.delegate = self
        senderZipTextField.delegate = self
        senderOtherTextField.delegate = self
        
        receiverFirstNameTextField.delegate = self
        receiverLastNameTextField.delegate = self
        receiverPhoneTextField.delegate = self
        receiverAddressTextField.delegate = self
        receiverRegionTextField.delegate = self
        receiverZipTextField.delegate = self
        receiverOtherTextField.delegate = self
        
    }
    
    @IBAction func contentTouchDown(_ sender: Any) {
        
        self.contentView.endEditing(true)
        
    }
    
    
    //通过点击 return 键隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        itemNameTextField.resignFirstResponder()
        itemCotegoryTextField.resignFirstResponder()
        itemWeightTextField.resignFirstResponder()
        itemRewardTextField.resignFirstResponder()
        
        senderFirstNameTextField.resignFirstResponder()
        senderLastNameTextField.resignFirstResponder()
        senderPhoneTextField.resignFirstResponder()
        senderAddressTextField.resignFirstResponder()
        senderRegionTextField.resignFirstResponder()
        senderZipTextField.resignFirstResponder()
        senderOtherTextField.resignFirstResponder()

        receiverFirstNameTextField.resignFirstResponder()
        receiverLastNameTextField.resignFirstResponder()
        receiverPhoneTextField.resignFirstResponder()
        receiverAddressTextField.resignFirstResponder()
        receiverRegionTextField.resignFirstResponder()
        receiverZipTextField.resignFirstResponder()
        receiverOtherTextField.resignFirstResponder()

        return true
        
    }
    
    //通过点击屏幕的空白区域隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        contentView.endEditing(true)
        scrollView.endEditing(true)
        
    }
    


}
