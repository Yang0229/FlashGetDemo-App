//
//  DataOfUsers.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-10.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DataOfUsers{

    // Reference
    let userDatabaseRef = Database.database().reference().child("users")
    let orderDatabaseRef = Database.database().reference().child("orders")
    let StorageRef = Storage.storage().reference()
    
    // Data of Database
    var user_Answer: String = ""
    var user_Email: String = ""
    var user_FirstName: String = ""
    var user_Gender: String = ""
    var user_Id: String = ""
    var user_LastName: String = ""
    var user_Phone: String = ""
    var user_Question: String = ""
    var user_RegisterTime: String = ""
    var user_RegisterTimeStamp: String = ""
    var user_Type: String = ""
    
    
    
    // Locatin Data
    var user_UserPhotoImage: UIImage?
    var queetionsCN: [String] = ["你的出生城市?", "你的第一辆车的颜色?", "你的第一个宠物的名字?", "你的小学的名字?"]
    var user_FinshedDouble: Double = 0.00
    var user_FinshedDoubleForPicked: Double = 0.00
    var user_FinshedDoubleForDelivered: Double = 0.00
    var user_PickedOnTimeDouble: Double = 0.00
    var user_DeliveredOnTimeDouble: Double = 0.00
    var user_PickedOnTimeRateDouble: Double = 0.00
    var user_DeliveredOnTimeRateDouble: Double = 0.00
    var user_UserRatingDouble: Double = 0.00
    var userDataSnapshot: [DataSnapshot] = []
    var userDic: [String : Any] = [:]
    
    var finishedDataSnapshot: [DataSnapshot] = []
    var finishedDataSnapshotForPicked: [DataSnapshot] = []
    var finishedDataSnapshotForDelivered: [DataSnapshot] = []
    var orderRatedSnapshot: [DataSnapshot] = []
    
    var pickedOnTimeDataSnapshot: [DataSnapshot] = []
    var deliveredOnTimeDataSnapshot: [DataSnapshot] = []
    
    var currentRatedOrderDic: [String : Any] = [:]
    var starSum: Double = 0
    
    
    
    func getCarrierRateInfo(carrierId: String){
        
        orderDatabaseRef.queryOrdered(byChild: "order_RateContentForCarrier").queryEqual(toValue: carrierId + "Rated").observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
            
            self.orderRatedSnapshot.append(dataSnapshot)
            self.currentRatedOrderDic = dataSnapshot.value as! [String : Any]
            if let rateNum = (self.currentRatedOrderDic["order_Star"] as? NSString)?.doubleValue{
                
                self.starSum += rateNum
                
            }
            
        }, withCancel: nil)
        
    }
    
    
    func getPickedOnTimeRateInfo(carrierId: String){
        
        orderDatabaseRef.queryOrdered(byChild: "order_StatusContentForCarrier").queryEqual(toValue: carrierId + "Delivered").observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
            
            self.finishedDataSnapshotForPicked.append(dataSnapshot)
            
        }, withCancel: nil)
        
        orderDatabaseRef.queryOrdered(byChild: "order_IsPickedLate").queryEqual(toValue: carrierId + "No").observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
            
            self.pickedOnTimeDataSnapshot.append(dataSnapshot)
            
        }, withCancel: nil)
      
    }
    
    
    func getDeliveredOnTimeRateInfo(carrierId: String){
        
        orderDatabaseRef.queryOrdered(byChild: "order_StatusContentForCarrier").queryEqual(toValue: carrierId + "Delivered").observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
            
            self.finishedDataSnapshotForDelivered.append(dataSnapshot)
            
        }, withCancel: nil)
        
        orderDatabaseRef.queryOrdered(byChild: "order_IsDeliveredLate").queryEqual(toValue: carrierId + "No").observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
            
            self.deliveredOnTimeDataSnapshot.append(dataSnapshot)
        }, withCancel: nil)
        
    }
    
    func calulateRate(){
        
        user_UserRatingDouble = starSum / Double(orderRatedSnapshot.count)
        
    }
    
    func calculatePickedRate(){
        
        user_FinshedDoubleForPicked = Double(finishedDataSnapshotForPicked.count)
        user_PickedOnTimeDouble = Double(pickedOnTimeDataSnapshot.count)
        user_PickedOnTimeRateDouble = user_PickedOnTimeDouble / user_FinshedDoubleForPicked
    }
    
    func calculateDeliveredRate(){
        
        user_FinshedDoubleForDelivered = Double(finishedDataSnapshotForDelivered.count)
        user_DeliveredOnTimeDouble = Double(deliveredOnTimeDataSnapshot.count)
        user_DeliveredOnTimeRateDouble = user_DeliveredOnTimeDouble / user_FinshedDoubleForDelivered
        
    }

    
    
    func getUserDataFromFirebase(researchKey: String, equalToValue: Any){
        
        userDatabaseRef.queryOrdered(byChild: researchKey).queryEqual(toValue: equalToValue).observeSingleEvent(of: DataEventType.childAdded, with: { (dataSnapshot) in
            
            self.userDataSnapshot.append(dataSnapshot)
            
            if let userDic = dataSnapshot.value as? [String : Any]{
                self.userDic = userDic
                
                if let user_Answer = userDic["user_Answer"] as? String{
                    
                    if let user_Email = userDic["user_Email"] as? String{
                        
                        if let user_FirstName = userDic["user_FirstName"] as? String{
                            
                            if let user_Gender = userDic["user_Gender"] as? String{
                                
                                if let user_Id = userDic["user_Id"] as? String{
                                    
                                    if let user_LastName = userDic["user_LastName"] as? String{
                                        
                                        if let user_Phone = userDic["user_Phone"] as? String{
                                            
                                            if let user_Question = userDic["user_Question"] as? String{
                                                
                                                if let user_RegisterTime = userDic["user_RegisterTime"] as? String{
                                                    
                                                    if let user_RegisterTimeStamp = userDic["user_RegisterTimeStamp"] as? String{
                                                        
                                                        if let user_Type = userDic["user_Type"] as? String{
                                                            
                                                            self.StorageRef.child("UserPhoto/\(user_Id).jpeg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                                                                
                                                                if error != nil{
                                                                    
                                                                    print(error?.localizedDescription)
                                                                    
                                                                }else{
                                                                    
                                                                    self.user_UserPhotoImage = UIImage(data: data!)
                                                                
                                                                    self.user_Answer = user_Answer
                                                                    self.user_Email = user_Email
                                                                    self.user_FirstName = user_FirstName
                                                                    self.user_Gender = user_Gender
                                                                    self.user_Id = user_Id
                                                                    self.user_LastName = user_LastName
                                                                    self.user_Phone = user_Phone
                                                                    self.user_Question = user_Question
                                                                    self.user_RegisterTime = user_RegisterTime
                                                                    self.user_RegisterTimeStamp = user_RegisterTimeStamp
                                                                    self.user_Type = user_Type
                                                                    
                                                                }
                                                                
                                                            })
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }, withCancel: nil)
        
    }
    
    
    
    
    
    
    
    
    
}
