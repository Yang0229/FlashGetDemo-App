//
//  ContentOfDifferentLanguage.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-21.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import Foundation

class ContentOfDifferentLanguage{
    
    var currentLanguage: String = "en-CA" // zh-Hans-CA
    
    
    func getLanguageType(){
        let def = UserDefaults.standard
        let allLanguages: [String] = def.object(forKey: "AppleLanguages") as! [String]
        let chooseLanguage = allLanguages.first

    }
    
}
