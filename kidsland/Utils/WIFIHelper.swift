//
//  WIFIHelper.swift
//  kidsland
//
//  Created by 阳鸿 on 2021/9/1.
//

import Foundation
import NetworkExtension

class WifiHelper {
    
    static let shared = WifiHelper()
    private init() {}

    func getWifiList(){
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { arr in
            for a in arr{
            print(a)
            }
        }
    }
    
}
