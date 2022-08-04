//
//  WebServices.swift
//  Things
//
//  Created by Aashini Sharma on 2022-08-02.
//

import Foundation

enum WebServices {
    
    // MARK: - Sign Up
    // ===============
    static func getThingsList(parameters: [String:Any],
                       success: @escaping (_ list: [ThingsData]) -> Void,
                       failure: @escaping (NSError) -> Void){
        let tempData  = [ThingsData(name: "Things 1",isSelected: false),
                         ThingsData(name: "Things 2",isSelected: false),
                         ThingsData(name: "Things 3",isSelected: false),
                         ThingsData(name: "Things 4",isSelected: false),
                         ThingsData(name: "Things 5",isSelected: false),
                         ThingsData(name: "Things 6",isSelected: false),
                         ThingsData(name: "Things 7",isSelected: false)]
        CommonFunctions.delay(delay: 0.5){
            success(tempData)
        }
    }
    
}

extension NSError {

    convenience init(localizedDescription: String) {
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }

    convenience init(code: Int, localizedDescription: String) {
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}

