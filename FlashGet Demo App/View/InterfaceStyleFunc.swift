//
//  InterfaceStyleFunc.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-07.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import UIKit
import Foundation

class InterfaceStyleFunc {
    
    func setCornerRadi(uiview : UIView, cornerName : UIRectCorner, width : CGFloat, height : CGFloat){
        
        let widthAndHeight = CGSize(width : width, height : height)
        let maskPath = UIBezierPath(roundedRect: uiview.bounds, byRoundingCorners: cornerName, cornerRadii: widthAndHeight)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = uiview.bounds
        maskLayer.path = maskPath.cgPath
        
        uiview.layer.mask = maskLayer
        
    }
    
    
    func moveUpViewWhenKeyboardAppeared(uiview: UIView, moveValue : CGFloat){
        
        let view = uiview
            
            UIView.animate(withDuration: 0.2) {
                
                view.center.y -= moveValue
                
        }
        
    }
    
    
    func moveDownViewWhenKeyboardDisAppeared(uiview: UIView, moveValue : CGFloat){
        
        let view = uiview
        UIView.animate(withDuration: 0.2) {
            
            view.center.y += moveValue
            
        }
        
    }
    
    
    func setBtnStyle1(button: UIButton){
        
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        
    }
    
    func setBtnStyle2(button: UIButton){
        
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        
    }
    
    func setBigBtnStyle2(button: UIButton){
        
        button.layer.cornerRadius = 10
//        button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
//        button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        button.layer.borderWidth = 1
        
    }
    
    
    func setSmallBtn(button: UIButton){
        
        button.layer.cornerRadius = 10
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.layer.borderWidth = 2
        
    }
    
    func emptyTextFieldCheck(sender: UITextField, senderLabel: UILabel){
        
        if sender.text != ""{
            
            senderLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }else{
            
            senderLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
        }
        
    }
    
}
