//
//  ScanQRVC.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-09.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class ScanQRVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var scanView: UIView!
    
    let dataOfOrders = DataOfOrders()
    
    var captureSession: AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var frameView: UIView?
    
    var orderId: String = ""
    var senderQRContent: String = ""
    var receiverQRContent: String = ""
    var orderStatus: String = ""
    var carrierId: String = ""
    var customerId: String = ""
    
    var currentTime: String = ""
    var currentTimeStamp: Double = 0.00
    var scanContent: String = ""

    var listType: String = ""
    var autoId = ""
    var userType: String = ""
    var userId: String = ""
    
    let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       frameView = UIView()
        
        getQR()
        
        dataOfOrders.getOrderDataFromFirebase(researchedKey: "order_Id", equalToValue: orderId)
        
        self.databaseRef.child("orders").queryOrdered(byChild: "order_Id").queryEqual(toValue: self.orderId).observeSingleEvent(of: DataEventType.value, with: { (dataSnapshot) in
            
            for snap in dataSnapshot.children {
                let userSnap = snap as! DataSnapshot
                self.autoId = userSnap.key //the uid of each user
                
            }
            
        })
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
        
    }
    
    
    func matchQRContent(){
        
        if orderStatus == "Taken"{
            
            if scanContent == senderQRContent{
                
                let alerController = UIAlertController(title: "Pick Up Confirm", message: "Are you sure to pick up this package now?", preferredStyle: UIAlertController.Style.alert)
                
                let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (alertAction) in
                    
                    self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                    
                }
                
                let confirmAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (alertAction) in
                    
                    self.getCurrentTime()
                    
                    if self.currentTimeStamp > (self.dataOfOrders.order_SenderPickUpTimeStamp as NSString).doubleValue{
                        
                        self.databaseRef.child("orders").child(self.autoId).child("order_IsPickedLate").setValue(self.dataOfOrders.order_CarrierId + "Yes")
                        
                    }else{
                        
                        self.databaseRef.child("orders").child(self.autoId).child("order_IsPickedLate").setValue(self.dataOfOrders.order_CarrierId + "No")
                        
                    }
                    
                    self.databaseRef.child("orders").child(self.autoId).child("order_Status").setValue("Picked")
                    self.databaseRef.child("orders").child(self.autoId).child("order_PickedTime").setValue(self.currentTime)
                    
                    self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                    
                }
                
                alerController.addAction(cancelAction)
                alerController.addAction(confirmAction)
                
                present(alerController, animated: true, completion: nil)
                
            }
            
        }else if orderStatus == "Picked"{
            
            if scanContent == receiverQRContent{
                
                let alerController = UIAlertController(title: "Delivery Confirm", message: "Are you sure to delivery this package now?", preferredStyle: UIAlertController.Style.alert)
                
                let cancelAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { (alertAction) in
                    
                    self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                    
                }
                
                let confirmAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (alertAction) in
                    
                    self.getCurrentTime()
                    
                    if self.currentTimeStamp > (self.dataOfOrders.order_ReceiverDeliveredTimeStamp as NSString).doubleValue{
                        
                        self.databaseRef.child("orders").child(self.autoId).child("order_IsDeliveredLate").setValue(self.dataOfOrders.order_CarrierId + "Yes")
                        
                    }else{
                        
                        self.databaseRef.child("orders").child(self.autoId).child("order_IsDeliveredLate").setValue(self.dataOfOrders.order_CarrierId + "No")
                        
                    }
                    
                    self.databaseRef.child("orders").child(self.autoId).child("order_Status").setValue("Delivered")
                    self.databaseRef.child("orders").child(self.autoId).child("order_DeliveredTime").setValue(self.currentTime)
                    self.databaseRef.child("orders").child(self.autoId).child("order_RateContentForCustomer").setValue(self.customerId + "WaitForRated")
                    self.databaseRef.child("orders").child(self.autoId).child("order_RateContentForCarrier").setValue(self.carrierId + "WaitForRated")
                    self.databaseRef.child("orders").child(self.autoId).child("order_StatusContentForCustomer").setValue(self.customerId + "Delivered")
                    self.databaseRef.child("orders").child(self.autoId).child("order_StatusContentForCarrier").setValue(self.carrierId + "Delivered")
                    
                    self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                    
                }
                
                alerController.addAction(cancelAction)
                alerController.addAction(confirmAction)
                
                present(alerController, animated: true, completion: nil)
                
            }
            
        }else if orderStatus == "Placed"{
            
            let alerController = UIAlertController(title: "Invalid Qr Code", message: "Sorry, this order are not be taken now.", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
                
                self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                
            }
            
            alerController.addAction(cancelAction)
            
            present(alerController, animated: true, completion: nil)
            
        }else if orderStatus == "Delivered"{
            
            let alerController = UIAlertController(title: "Invalid Qr Code", message: "Sorry, this order has already been delivered.", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
                
                self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                
            }
            
            alerController.addAction(cancelAction)
            
            present(alerController, animated: true, completion: nil)
            
        }else if orderStatus == "Canceled"{
            
            let alerController = UIAlertController(title: "Invalid Qr Code", message: "Sorry, this order has already been canceld.", preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (alertAction) in
                
                self.performSegue(withIdentifier: "scanQRVCToCarrierTakeAnOrderVC", sender: self)
                
            }
            
            alerController.addAction(cancelAction)
            
            present(alerController, animated: true, completion: nil)
            
        }
        
    }
    
    func getCurrentTime(){
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/mm/dd HH:mm:ss"
        
        currentTime = dateFormatter.string(from: now)
        currentTimeStamp = now.timeIntervalSince1970

    }
    
    
    func getQR(){
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession.addInput(input)
            
        }catch{
            
            print("Could not capture camera")
            
        }
        
        captureSession.startRunning()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = CGRect(x: 0, y: 0, width: scanView.frame.width, height: scanView.frame.height)
        scanView.layer.addSublayer(previewLayer!)
        previewLayer?.videoGravity = .resizeAspectFill
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        if let detectView = frameView{
            
            detectView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            detectView.layer.borderWidth = 2.0
            scanView.addSubview(detectView)
            scanView.bringSubviewToFront(detectView)
            
        }
    
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0{
            
            frameView?.frame = CGRect.zero
            
            return
            
        }
        
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
            
            if let qrCodeObject = previewLayer?.transformedMetadataObject(for: metadataObj){
                
                frameView?.frame = qrCodeObject.bounds
                
            }
            
            if let qrCodeContent = metadataObj.stringValue {
                
                self.scanContent = qrCodeContent
                self.matchQRContent()
                
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "scanQRVCToCarrierTakeAnOrderVC"{
            
            let destinationVC = segue.destination as! CarrierTakeAnOrderVC
            
            destinationVC.listType = self.listType
            destinationVC.userType = self.userType
            destinationVC.userId = self.userId
            destinationVC.orderId = self.orderId
            
        }
    }

}
