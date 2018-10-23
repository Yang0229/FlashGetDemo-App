//
//  DataOfWeather.swift
//  FlashGet Demo App
//
//  Created by Tinker on 2018-10-10.
//  Copyright © 2018 Bo Yang. All rights reserved.
//

import Foundation

class DataOfWeather{
    
    var temprature: Int = 0
    var condition: Int = 0
    var cityName: String = ""
    var weatherIconName: String = ""
    
    func updateWeatherIcon(conditionId: Int) -> String{
        
        switch conditionId {
        case 0...232: return "thunderstorm"
        case 300...531: return "rain"
        case 600...622: return "snow"
        case 701...781: return "mist"
        case 800: return "sunny"
        case 801...804: return "clouds"
        default:
            return "thunderstorm"
        }
        
    }
    
}
