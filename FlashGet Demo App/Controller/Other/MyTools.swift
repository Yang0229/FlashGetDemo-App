//
//  QrCodeGenerator.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-13.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class MyTools{
    
    let dataOfUsers = DataOfUsers()
    let dataOfOrders = DataOfOrders()
    
    
    let userDatabaseRef = Database.database().reference().child("users")
    let orderDatabaseRef = Database.database().reference().child("orders")
    
    let StorageRef = Storage.storage().reference()
    
    
    var currentUserInfos: NSDictionary = [:]
    var phoneArray: [Any] = [1]

    let logo = UIImage(named: "thunder")
    let imageWidth = CGFloat(480.0)
    
    
    
    func QrCodeGenerator(content: String) -> UIImage{
        
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        qrFilter?.setDefaults()
        
        // 将字符串转换成
        let infoData =  content.data(using: .utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        qrFilter?.setValue(infoData, forKey: "inputMessage")
        
        // 获得滤镜输出的图像
        let  outputImage = qrFilter?.outputImage
        
        // 设置缩放比例
        let scale = imageWidth / outputImage!.extent.size.width;
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let transformImage = qrFilter!.outputImage!.transformed(by: transform)
        
        // 获取Image
        let image = UIImage(ciImage: transformImage)
        
        // 无logo时  返回普通二维码image
        guard let QRCodeLogo = logo else { return image }
        
        // logo尺寸与frame
        let logoWidth = image.size.width/4
        let logoFrame = CGRect(x: (image.size.width - logoWidth) /  2, y: (image.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        
        // 绘制二维码
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 绘制中间logo
        QRCodeLogo.draw(in: logoFrame)
        
        //返回带有logo的二维码
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return QRCodeImage!
       
    }
    
    
    
    func getCurrentUserInfo(){
        
        var userDatabaseRef: DatabaseReference!
        userDatabaseRef = Database.database().reference()

        let currentEmail: String = (Auth.auth().currentUser?.email)!

        userDatabaseRef.child("users").observe(.value) { (snapshotAll) in

            if let result = snapshotAll.children.allObjects as? [DataSnapshot]{

                for child in result {

                    print(currentEmail)

                    let userAutoId = child.key as String

                    userDatabaseRef.child("users").queryOrdered(byChild: "user_Email").queryEqual(toValue: currentEmail).observe( .value, with: { (snapshot) in

                        if let value = snapshot.value as? NSDictionary{

                            if let infos = value["\(userAutoId)"] as? NSDictionary{

                                let newPhone = infos["user_Phone"] as! NSString
                                self.phoneArray.append(newPhone)

                            }

                        }

                    })

                }

            }

        }
        
        print(phoneArray)
        
    }
    
    
    
    
                    
                    
}

