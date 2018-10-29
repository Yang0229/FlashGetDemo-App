//
//  WelcomeVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-06.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import Alamofire
import SwiftyJSON
import CoreLocation

class SignInVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var areYouForgotPWStack: UIStackView!
    @IBOutlet weak var emailPasswordStack: UIStackView!
    @IBOutlet weak var areYouMemberStack: UIStackView!
    @IBOutlet weak var weatherStack: UIStackView!
    @IBOutlet weak var typeStack: UIStackView!
    @IBOutlet weak var customWelcomeBtn: UIButton!
    @IBOutlet weak var carrierWelcomeBtn: UIButton!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherCityName: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var notMemberLabel: UILabel!
    @IBOutlet weak var signUpNowBtn: UIButton!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    let dataOfUsers = DataOfUsers()
    let dataOfWeather = DataOfWeather()
    let locationManager = CLLocationManager()
    let userRef = Database.database().reference().child("users")
    
    let bgImageView = UIImageView()
    var userType: String = ""
    let openWeatherMapLinkage = "https://api.openweathermap.org/data/2.5/weather"
    let appid = "b37fe87a24cb97689e963da973aaf9cf"
    var latitudeString: String?
    var longitudeString: String?
    //43.627021, -79.478491
    var userFirstName: String = ""
    var userLastName: String = ""
    var userGender: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        locationManager.delegate = self
        HideView2()

        setBgImageView()
        setWeatherIcon()
        setBtnAndTextfieldStyle()
        setBottonImageView()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        animationOfBgImageView()
        checkLocationManagerStatus()

    }

    
    func checkLocationManagerStatus(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            
            getUserLocation()
            let keys: [String : String] = ["lat": latitudeString!, "lon": longitudeString!, "appid": self.appid]
            getWeatherData(url: openWeatherMapLinkage, keys: keys)
            
        }else{
            
            let alertController = UIAlertController(title: "打开定位开关", message:"定位服务未开启,请进入系统设置>隐私>定位服务中打开开关,并允许xxx使用定位服务", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "去设置", style: .default) { (action) in
                
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                
            }
            alertController.addAction(tempAction)
            alertController.addAction(callAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func getUserLocation(){
        
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        
        if let location: CLLocation = locationManager.location{
            
            latitudeString = String(location.coordinate.latitude)
            longitudeString = String(location.coordinate.longitude)
            
        }
        
    }
    
    
 func getWeatherData(url: String, keys: [String : String]){
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: keys, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess{
                
                let weatherJSONData : JSON = JSON(response.result.value)
                
                self.updateWeatherData(jsonData: weatherJSONData)
                
            }else{
                
                print("2")
                
            }
            
        }
        
    }
    
    func updateWeatherData(jsonData: JSON){
        
        if let temprature = jsonData["main"]["temp"].double {
            
            dataOfWeather.temprature = Int(temprature - 273.15)
            dataOfWeather.cityName = jsonData["name"].stringValue
            dataOfWeather.condition = jsonData["weather"][0]["id"].intValue
            dataOfWeather.weatherIconName = dataOfWeather.updateWeatherIcon(conditionId: dataOfWeather.condition)
            
            self.weatherIcon.image = UIImage(named: dataOfWeather.weatherIconName)
            self.weatherTemp.text = "\(dataOfWeather.temprature)"+"˚C"
            self.weatherCityName.text = dataOfWeather.cityName
            
        }
        
    }
    
    
    @IBAction func customBtnPressed(_ sender: Any) {
        
        userType = "Customer"
        
        switchToView2()
        
    }
    
    @IBAction func carrierBtnPressed(_ sender: Any) {
        
        userType = "Carrier"
        
        switchToView2()
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        switchToView1()
        
    }

    @IBAction func signInBtnPressed(_ sender: Any) {
        
        //Determine if the email and password are empty or not
        if emailTextfield.text == "" || passwordTextfield.text == ""{
            
            let title = "Sign In Error"
            let message = "The email or password can not be empty"
            displayAlert(title: title, message: message, errorString: "")
            print(userType)
            
            
        }else{
            
            let email = emailTextfield.text
            let password = passwordTextfield.text
            
            //Sign up method
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                
                if error != nil{
                    
                    //Sign up failed
                    let title = "Sign In Error"
                    
                    let errorString = String(describing: (error as!NSError).userInfo["error_name"]!)
                    
                    self.displayAlert(title: title, message: (error?.localizedDescription)!, errorString: errorString)
                    
                }else{

                    self.userRef.queryOrdered(byChild: "user_Email").queryEqual(toValue: email).observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
                 
                        if let userInfoDic = dataSnapshot.value as? [String : Any]{
                
                            if let userTypeCorrect = userInfoDic["user_Type"] as? String{
                                
                                if let user_FirstName = userInfoDic["user_FirstName"] as? String{
                                    
                                    if let user_LastName = userInfoDic["user_LastName"] as? String{
                                        
                                        if let user_Gender = userInfoDic["user_Gender"] as? String{
                                            
                                            if userTypeCorrect == self.userType{
                                                
                                                //Sign up successful
                                                //                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                                //                    changeRequest?.displayName = self.userType
                                                //                    changeRequest?.commitChanges(completion: nil)
                                                self.userFirstName = user_FirstName
                                                self.userLastName = user_LastName
                                                self.userGender = user_Gender
                                                
                                                self.performSegue(withIdentifier: "signInVCToMianVC", sender: self)
                                                
                                            }else{
                                                print("4")
                                                let alertController = UIAlertController(title: "Sign In Error", message: "This account are not exist.", preferredStyle: UIAlertController.Style.alert)
                                                let alertActionOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) in
                                                    
                                                    alertController.dismiss(animated: true, completion: nil)
                                                    
                                                })
                                                
                                                alertController.addAction(alertActionOK)
                                                self.present(alertController, animated: true, completion: nil)
                                      
                                            }
                                        
                                        }
                             
                                    }
                          
                                }
                                
                            }
                            
                        }
                        
                    }, withCancel: nil)
                    
                }
                
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInVCToMianVC"{
            
            let destinationVC = segue.destination as! MainVC
            destinationVC.userType = self.userType
            destinationVC.userFirstName = self.userFirstName
            destinationVC.userLastName = self.userLastName
            destinationVC.userGender = self.userGender
            
        }
    }


    
    
    func displayAlert(title: String, message: String, errorString: String){
        
        var alertController = UIAlertController()
        
        if errorString == "ERROR_USER_NOT_FOUND"{
            
            alertController = UIAlertController(title: title, message: "This user does not exist, do you want to create a account?", preferredStyle: UIAlertController.Style.alert)
            
            let alertActionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
            let alertActionOK = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (UIAlertAction) in
                
                self.performSegue(withIdentifier: "signInVCToSignUpVC", sender: self)
                
            }
            
            alertController.addAction(alertActionCancel)
            alertController.addAction(alertActionOK)
            
        }else{
            
            alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(alertActionOK)
            
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func setBottonImageView(){
        
        bottomImageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
    
    func setWeatherIcon(){
        
        weatherIcon.contentMode = .scaleAspectFit
        weatherIcon.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
    
    func setBtnAndTextfieldStyle(){
        
        customWelcomeBtn.layer.cornerRadius = 10
        carrierWelcomeBtn.layer.cornerRadius = 10
        signUpBtn.layer.cornerRadius = 10
        
        customWelcomeBtn.layer.borderWidth = 1
        carrierWelcomeBtn.layer.borderWidth = 1
        signUpBtn.layer.borderWidth = 1
        emailTextfield.layer.borderWidth = 1
        passwordTextfield.layer.borderWidth = 1
        
        customWelcomeBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        carrierWelcomeBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        signUpBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        emailTextfield.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        passwordTextfield.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        customWelcomeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        carrierWelcomeBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        signUpBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        emailTextfield.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        passwordTextfield.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        emailTextfield.attributedPlaceholder = NSAttributedString(string: "Please enter you email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Please enter you password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    }
    
    
    func setBgImageView(){
        
        bgImageView.image = UIImage(named: "bgImage")
        bgImageView.frame = CGRect(x: 0, y: 0, width: ((bgImageView.image?.size.width)! * self.view.frame.height / (bgImageView.image?.size.height)!), height: ((bgImageView.image?.size.height)! * self.view.frame.height / (bgImageView.image?.size.height)!))
        
        view.addSubview(bgImageView)
        view.sendSubviewToBack(bgImageView)
        
    }
    
    
    func animationOfBgImageView(){
        
        UIView.animate(withDuration: 20, delay: 0, options: [UIView.AnimationOptions.repeat, .autoreverse], animations: {
            
            self.bgImageView.center.x = self.bgImageView.center.x - (self.bgImageView.image?.size.width)! + self.view.frame.width
            
            
        }, completion: nil)
        
    }
    
    
    func switchToView2(){
        
        upperView.center.y -= upperView.frame.height
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.bottomImageView.center.y += self.bottomImageView.frame.height
            
            self.weatherTemp.alpha = 0
            self.weatherCityName.alpha = 0
            self.weatherIcon.alpha = 0
            
            self.typeStack.alpha = 0
            self.customWelcomeBtn.alpha = 0
            self.carrierWelcomeBtn.alpha = 0
            
            self.areYouMemberStack.alpha = 0
            self.notMemberLabel.alpha = 0
            self.signUpNowBtn.alpha = 0
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.25) {
                
                self.upperView.center.y += self.upperView.frame.height
                self.bottomImageView.center.y -= self.bottomImageView.frame.height
                
                self.upperView.alpha = 0.3
                self.backbtn.alpha = 1
                
                self.emailPasswordStack.alpha = 1
                self.emailTextfield.alpha = 1
                self.passwordTextfield.alpha = 1
                self.signUpBtn.alpha = 1
                
                self.areYouForgotPWStack.alpha = 1
                
            }
            
        }
        
    }
    
    
    func switchToView1(){
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.upperView.center.y -= self.upperView.frame.height
            self.bottomImageView.center.y += self.bottomImageView.frame.height
            
            self.upperView.alpha = 0
            self.backbtn.alpha = 0
            
            self.emailTextfield.alpha = 0
            self.passwordTextfield.alpha = 0
            self.signUpBtn.alpha = 0
            
            self.areYouForgotPWStack.alpha = 0
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.25) {
                
                self.upperView.center.y += self.upperView.frame.height
                self.bottomImageView.center.y -= self.bottomImageView.frame.height
                
                self.weatherTemp.alpha = 1
                self.weatherCityName.alpha = 1
                self.weatherIcon.alpha = 1
                
                self.typeStack.alpha = 1
                self.customWelcomeBtn.alpha = 1
                self.carrierWelcomeBtn.alpha = 1
                
                self.areYouMemberStack.alpha = 1
                self.notMemberLabel.alpha = 1
                self.signUpNowBtn.alpha = 1
                
            }
            
        }
        
    }
    
    
    func HideView2(){
        
        upperView.alpha = 0
        backbtn.alpha = 0
        
        emailPasswordStack.alpha = 0
        emailTextfield.alpha = 0
        passwordTextfield.alpha = 0
        signUpBtn.alpha = 0
        
        self.areYouForgotPWStack.alpha = 0
        
    }
    
    
    //通过点击 return 键隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        
        return true
        
    }
    
    //通过点击屏幕的空白区域隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    

}
