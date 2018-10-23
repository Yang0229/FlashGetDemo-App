//
//  DataOfOrders.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-10.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class DataOfOrders{
    
    let orderDatabaseRef = Database.database().reference().child("orders")
    let storageRef = Storage.storage().reference()
    
    // Data of Database
    var order_CarrierId: String = ""
    var order_DeliverdTime: String = ""
    var order_DeliverdTimeStamp: String = ""
    var order_Distance: String = ""
    var order_Id: String = ""
    var order_ItemCategory: String = ""
    var order_ItemName: String = ""
    var order_ItemPhotoName: String = ""
    var order_ItemReward: String = ""
    var order_ItemWeight: String = ""
    var order_PickedTime: String = ""
    var order_PickedTimeStamp: String = ""
    var order_PlaceTime: String = ""
    var order_PlaceTimeStamp: String = ""
    var order_RateContentForCarrier: String = ""
    var order_RateContentForCustomer: String = ""
    var order_ReceiverAddress: String = ""
    var order_ReceiverDeliveredTime: String = ""
    var order_ReceiverDeliveredTimeStamp: String = ""
    var order_ReceiverFirstName: String = ""
    var order_ReceiverLastName: String = ""
    var order_ReceiverLat: String = ""
    var order_ReceiverLon: String = ""
    var order_ReceiverDesc: String = ""
    var order_ReceiverPhone: String = ""
    var order_ReceiverQRContent: String = ""
    var order_ReceiverQRName: String = ""
    var order_ReceiverRegion: String = ""
    var order_ReceiverZipCode: String = ""
    var order_SenderAddress: String = ""
    var order_SenderFirstName: String = ""
    var order_SenderLastName: String = ""
    var order_SenderLat: String = ""
    var order_SenderLon: String = ""
    var order_SenderDesc: String = ""
    var order_SenderPhone: String = ""
    var order_SenderPickUpTime: String = ""
    var order_SenderPickUpTimeStamp: String = ""
    var order_SenderQRContent: String = ""
    var order_SenderQRName: String = ""
    var order_SenderRegion: String = ""
    var order_SenderZipCode: String = ""
    var order_Star: String = ""
    var order_Status: String = "" // 0: Placed, 1: Taken, 2: Picked, 3: Delivered, 4:Canceled
    var order_StatusContentForCarrier: String = ""
    var order_StatusContentForCustomer: String = ""
    var order_CustomerId: String = ""
    var order_IsPickedLate: String = ""
    var order_IsDeliveredLate: String = ""
    
    // Data of Storage
    var order_itemPhotoImage: UIImage?
    var order_SenderQrImage: UIImage?
    var order_ReceiverQrImage: UIImage?
    
    
    // Location Data
    var order_senderLocation: CLLocation?
    var order_receiverLocation: CLLocation?
    
    var orderDataSnapshot: [DataSnapshot] = []
    var orderDic: [String : Any] = [:]
    
    var autoId: String = ""
    
    
    
    func getAutoId(researchKey: String, equalToValue: Any){
        
        orderDatabaseRef.queryOrdered(byChild: researchKey).queryEqual(toValue: equalToValue).observeSingleEvent(of: DataEventType.value, with: { (dataSnapshot) in
            
            for snap in dataSnapshot.children {
                let userSnap = snap as! DataSnapshot
                self.autoId = userSnap.key //the uid of each user
                
            }
            
        })
        
    }
    
    
    
    
    func convertToCLLocation(lat: CLLocationDegrees, Lon: CLLocationDegrees, who: String){
        
        if who == "sender"{
            
            order_senderLocation = CLLocation(latitude: lat, longitude: Lon)
            
        }else if who == "receiver"{
            
            order_receiverLocation = CLLocation(latitude: lat, longitude: Lon)
            
        }
        
    }
    
    
    
    func getOrderDataFromFirebase(researchedKey: String, equalToValue: Any){
        
        orderDatabaseRef.queryOrdered(byChild: researchedKey).queryEqual(toValue: equalToValue).observeSingleEvent(of: DataEventType.childAdded) { (dataSnapshot) in
            
        self.orderDataSnapshot.append(dataSnapshot)
            
            if let orderDic = dataSnapshot.value as? [String : Any]{
                self.orderDic = orderDic
                
                if let order_CarrierId = orderDic["order_CarrierId"] as? String{
                    
                    if let order_DeliveredTime = orderDic["order_DeliveredTime"] as? String{
                        
                        if let order_Distance = orderDic["order_DeliveredTime"] as? String{
                            
                            if let order_Id = orderDic["order_Id"] as? String{
                                
                                if let order_ItemCategory = orderDic["order_ItemCategory"] as? String{
                                    
                                    if let order_ItemName = orderDic["order_ItemName"] as? String{
                                        
                                        if let order_ItemPhotoName = orderDic["order_ItemPhotoName"] as? String{
                                            
                                            if let order_ItemReward = orderDic["order_ItemReward"] as? String{
                                                
                                                if let  order_ItemWeight = orderDic["order_ItemWeight"] as? String{
                                                    
                                                    if let order_PickedTime = orderDic["order_PickedTime"] as? String{
                                                        
                                                        if let order_PickedTimeStamp = orderDic["order_PickedTimeStamp"] as? String{
                                                            
                                                            if let order_PlaceTime = orderDic["order_PlaceTime"] as? String{
                                                                
                                                                if let order_PlaceTimeStamp = orderDic["order_PlaceTimeStamp"] as? String{
                                                                    
                                                                    if let order_RateContentForCarrier = orderDic["order_RateContentForCarrier"] as? String{
                                                                        
                                                                        if let order_RateContentForCustomer = orderDic["order_RateContentForCustomer"] as? String{
                                                                            
                                                                            if let order_ReceiverFirstName = orderDic["order_ReceiverFirstName"] as? String{
                                                                                
                                                                                if let order_ReceiverLastName = orderDic["order_ReceiverLastName"] as? String{
                                                                                    
                                                                                    if let order_ReceiverLat = orderDic["order_ReceiverLat"] as? String{
                                                                                        
                                                                                        if let order_ReceiverLon = orderDic["order_ReceiverLon"] as? String{
                                                                                            
                                                                                            if let order_ReceiverDesc = orderDic["order_ReceiverDesc"] as? String{
                                                                                                
                                                                                                if let order_ReceiverPhone = orderDic["order_ReceiverPhone"] as? String{
                                                                                                    
                                                                                                    if let order_ReceiverQRContent = orderDic["order_ReceiverQRContent"] as? String{
                                                                                                        
                                                                                                        if let order_ReceiverQRName = orderDic["order_ReceiverQRName"] as? String{
                                                                                                            
                                                                                                            if let order_ReceiverRegion = orderDic["order_ReceiverRegion"] as? String{
                                                                                                                
                                                                                                                if let order_ReceiverZipCode = orderDic["order_ReceiverZipCode"] as? String{
                                                                                                                    
                                                                                                                    if let order_SenderAddress = orderDic["order_SenderAddress"] as? String{
                                                                                                                        
                                                                                                                        if let order_SenderFirstName = orderDic["order_SenderFirstName"] as? String{
                                                                                                                            
                                                                                                                            if let order_SenderLastName = orderDic["order_SenderLastName"] as? String{
                                                                                                                                
                                                                                                                                if let order_SenderLat = orderDic["order_SenderLat"] as? String{
                                                                                                                                    
                                                                                                                                    if let order_SenderLon = orderDic["order_SenderLon"] as? String{
                                                                                                                                        
                                                                                                                                        if let order_SenderDesc = orderDic["order_SenderDesc"] as? String{
                                                                                                                                            
                                                                                                                                            if let order_SenderPhone = orderDic["order_SenderPhone"] as? String{
                                                                                                                                                
                                                                                                                                                if let order_SenderPickUpTime = orderDic["order_SenderPickUpTime"] as? String{
                                                                                                                                                    
                                                                                                                                                    if let order_SenderPickUpTimeStamp = orderDic["order_SenderPickUpTimeStamp"] as? String{
                                                                                                                                                        
                                                                                                                                                        if let order_SenderQRContent = orderDic["order_SenderQRContent"] as? String{
                                                                                                                                                            
                                                                                                                                                            if let order_SenderQRName = orderDic["order_SenderQRName"] as? String{
                                                                                                                                                                
                                                                                                                                                                if let order_SenderRegion = orderDic["order_SenderRegion"] as? String{
                                                                                                                                                                    
                                                                                                                                                                    if let order_SenderZipCode = orderDic["order_SenderZipCode"] as? String{
                                                                                                                                                                        
                                                                                                                                                                        if let order_Star = orderDic["order_Star"] as? String{
                                                                                                                                                                            
                                                                                                                                                                            if let order_Status = orderDic["order_Status"] as? String{
                                                                                                                                                                                
                                                                                                                                                                                if let order_StatusContentForCarrier = orderDic["order_StatusContentForCarrier"] as? String{
                                                                                                                                                                                    
                                                                                                                                                                                    if let order_StatusContentForCustomer = orderDic["order_StatusContentForCustomer"] as? String{
                                                                                                                                                                                        
                                                                                                                                                                                        if let order_CustomerId = orderDic["order_CustomerId"] as? String{
                                                                                                                                                                                            
                                                                                                                                                                                            if let order_IsPickedLate = orderDic["order_IsPickedLate"] as? String{
                                                                                                                                                                                                
                                                                                                                                                                                                if let order_IsDeliveredLate = orderDic["order_IsDeliveredLate"] as? String{
                                                                                                                                                                                                    
                                                                                                                                                                                                    if let order_ReceiverAddress = orderDic["order_ReceiverAddress"] as? String{
                                                                                                                                                                                                        
                                                                                                                                                                                                        if let order_ReceiverDeliveredTime = orderDic["order_ReceiverDeliveredTime"] as? String{
                                                                                                                                                                                                            
                                                                                                                                                                                                            if let order_ReceiverDeliveredTimeStamp = orderDic["order_ReceiverDeliveredTimeStamp"] as? String{
                                                                                                                                                                                                                
                                                                                                                                                                                                                self.storageRef.child("itemPhoto/\(order_ItemPhotoName).jpeg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                                                                                                                                                                                                                    
                                                                                                                                                                                                                    if error != nil{
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        print(error?.localizedDescription)
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }else{
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        self.order_itemPhotoImage = UIImage(data: data!)
                                                                                                                                                                                                                        print("Get Item Photo Successful!")
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                    
                                                                                                                                                                                                                })
                                                                                                                                                                                                                
                                                                                                                                                                                                                self.storageRef.child("senderQR/\(order_SenderQRName).jpeg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                                                                                                                                                                                                                    
                                                                                                                                                                                                                    if error != nil{
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        print(error?.localizedDescription)
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }else{
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        self.order_SenderQrImage = UIImage(data: data!)
                                                                                                                                                                                                                        print("Get Sender Qr Successful!")
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                    
                                                                                                                                                                                                                })
                                                                                                                                                                                                                
                                                                                                                                                                                                                self.storageRef.child("receiverQR/\(order_ReceiverQRName).jpeg").getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                                                                                                                                                                                                                    
                                                                                                                                                                                                                    if error != nil{
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        print(error?.localizedDescription)
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }else{
                                                                                                                                                                                                                        
                                                                                                                                                                                                                        self.order_ReceiverQrImage = UIImage(data: data!)
                                                                                                                                                                                                                        print("Get Receiver Qr Successful!")
                                                                                                                                                                                                                        
                                                                                                                                                                                                                    }
                                                                                                                                                                                                                    
                                                                                                                                                                                                                })
                                                                                                                                                                                                                
                                                                                                                                                                                                                self.order_CarrierId = order_CarrierId
                                                                                                                                                                                                                self.order_DeliverdTime = order_DeliveredTime
                                                                                                                                                                                                                self.order_Distance = order_Distance
                                                                                                                                                                                                                self.order_Id = order_Id
                                                                                                                                                                                                                self.order_ItemCategory = order_ItemCategory
                                                                                                                                                                                                                self.order_ItemName = order_ItemName
                                                                                                                                                                                                                self.order_ItemPhotoName = order_ItemPhotoName
                                                                                                                                                                                                                self.order_ItemReward = order_ItemReward
                                                                                                                                                                                                                self.order_ItemWeight = order_ItemWeight
                                                                                                                                                                                                                self.order_PickedTime = order_PickedTime
                                                                                                                                                                                                                self.order_PickedTimeStamp = order_PickedTimeStamp
                                                                                                                                                                                                                self.order_PlaceTime = order_PlaceTime
                                                                                                                                                                                                                self.order_PlaceTimeStamp = order_PlaceTimeStamp
                                                                                                                                                                                                                self.order_RateContentForCarrier = order_RateContentForCarrier
                                                                                                                                                                                                                self.order_RateContentForCustomer = order_RateContentForCustomer
                                                                                                                                                                                                                self.order_ReceiverAddress = order_ReceiverAddress
                                                                                                                                                                                                                self.order_ReceiverDeliveredTime = order_ReceiverDeliveredTime
                                                                                                                                                                                                                self.order_ReceiverDeliveredTimeStamp = order_ReceiverDeliveredTimeStamp
                                                                                                                                                                                                                self.order_ReceiverFirstName = order_ReceiverFirstName
                                                                                                                                                                                                                self.order_ReceiverLastName = order_ReceiverLastName
                                                                                                                                                                                                                self.order_ReceiverLat = order_ReceiverLat
                                                                                                                                                                                                                self.order_ReceiverLon = order_ReceiverLon
                                                                                                                                                                                                                self.order_ReceiverDesc = order_ReceiverDesc
                                                                                                                                                                                                                self.order_ReceiverPhone = order_ReceiverPhone
                                                                                                                                                                                                                self.order_ReceiverQRContent = order_ReceiverQRContent
                                                                                                                                                                                                                self.order_ReceiverQRName = order_ReceiverQRName
                                                                                                                                                                                                                self.order_ReceiverRegion = order_ReceiverRegion
                                                                                                                                                                                                                self.order_ReceiverZipCode = order_ReceiverZipCode
                                                                                                                                                                                                                self.order_SenderAddress = order_SenderAddress
                                                                                                                                                                                                                self.order_SenderFirstName = order_SenderFirstName
                                                                                                                                                                                                                self.order_SenderLastName = order_SenderLastName
                                                                                                                                                                                                                self.order_SenderLat = order_SenderLat
                                                                                                                                                                                                                self.order_SenderLon = order_SenderLon
                                                                                                                                                                                                                self.order_SenderDesc = order_SenderDesc
                                                                                                                                                                                                                self.order_SenderPhone = order_SenderPhone
                                                                                                                                                                                                                self.order_SenderPickUpTime = order_SenderPickUpTime
                                                                                                                                                                                                                self.order_SenderPickUpTimeStamp = order_SenderPickUpTimeStamp
                                                                                                                                                                                                                self.order_SenderQRContent = order_SenderQRContent
                                                                                                                                                                                                                self.order_SenderQRName = order_SenderQRName
                                                                                                                                                                                                                self.order_SenderRegion = order_SenderRegion
                                                                                                                                                                                                                self.order_SenderZipCode = order_SenderZipCode
                                                                                                                                                                                                                self.order_Star = order_Star
                                                                                                                                                                                                                self.order_Status = order_Status
                                                                                                                                                                                                                self.order_StatusContentForCarrier = order_StatusContentForCarrier
                                                                                                                                                                                                                self.order_StatusContentForCustomer = order_StatusContentForCustomer
                                                                                                                                                                                                                self.order_CustomerId = order_CustomerId
                                                                                                                                                                                                                self.order_IsPickedLate = order_IsPickedLate
                                                                                                                                                                                                                self.order_IsDeliveredLate = order_IsDeliveredLate
                                                                                                                                                                                                                print("Get Order Data Successful!")
                                                                                                                                                                                                                
                                                                                                                                                                                                                
                                                                                                                                                                                                                
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
                
            }
            
        }
        
    }

    
    
    
}


