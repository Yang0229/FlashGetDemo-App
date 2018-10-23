//
//  WelcomeVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-07.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeVC: UIViewController {
    
    let bgImageView = UIImageView()
    let locationManager = CLLocationManager()
    
    var latitudeString: String?
    var longitudeString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBgImageView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        getUserLocation()
        welcomeAnimation()

    }
    
    
    func setBgImageView(){
        
        bgImageView.image = UIImage(named: "bgImage")
        bgImageView.frame = CGRect(x: 0, y: 0, width: (bgImageView.image?.size.width)!, height: (bgImageView.image?.size.height)!)
        
        view.addSubview(bgImageView)
        view.sendSubviewToBack(bgImageView)
        
    }
    
    
    func welcomeAnimation(){
        
        let thunderPic = UIImageView()
        let darkGeryBGPic = UIImageView()
        
        darkGeryBGPic.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        darkGeryBGPic.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        
        thunderPic.frame = CGRect(x: CGFloat((self.view.frame.width/2)-64), y: CGFloat((self.view.frame.height/2)-48), width: 128, height: 128)
        thunderPic.image = UIImage(named: "thunder2")
        thunderPic.contentMode = .scaleAspectFit
        
        view.addSubview(darkGeryBGPic)
        view.addSubview(thunderPic)
        view.bringSubviewToFront(darkGeryBGPic)
        view.bringSubviewToFront(thunderPic)
        
        UIView.animate(withDuration: 0.4, animations: {
            
            thunderPic.transform = CGAffineTransform(scaleX: 1, y: 2)
            
        }) { (finished) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                thunderPic.transform = CGAffineTransform.identity
                
            }, completion: { (finished) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    thunderPic.transform = CGAffineTransform(scaleX: 3, y: 1)
                    
                }, completion: { (finished) in
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        thunderPic.transform = CGAffineTransform.identity
                        
                    }, completion: { (finished) in
                        
                        UIView.animate(withDuration: 0.4, animations: {
                            
                            thunderPic.transform = CGAffineTransform(scaleX: 15, y: 15)
                            thunderPic.alpha = 0
                            darkGeryBGPic.alpha = 0
                            
                        }, completion: { (finished) in
                            
                            thunderPic.isHidden = true
                            darkGeryBGPic.isHidden = true
                            self.performSegue(withIdentifier: "GoToSignUpVC", sender: self)
                            
                        })
                        
                    })
                    
                })
                
            })
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToSignUpVC"{
            
            let destinationVC = segue.destination as! SignInVC
            destinationVC.latitudeString = self.latitudeString
            destinationVC.longitudeString = self.longitudeString
            
        }
    }
    
    
    
}
