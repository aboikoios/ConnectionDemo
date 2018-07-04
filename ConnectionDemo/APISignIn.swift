//
//  APISignIn.swift
//

import UIKit

class APISignIn: APIBase {

    var token: String?
    
    init(phone: String, pin: String) {
        super.init()
        let device = UIDevice.current.model
        let params: RequestParameters = ["phone" : phone, "pin" : pin, "platform" : "iOS", "device" : device]
        createPOST(urlSuffix: "api/signin", parameters: params)
    }
    
    override func processSuccess(_ json: Data) {
        if let token = tokenFrom(json) {
            self.token = token
        } else {
            self.isSuccessfull = false
            self.statusDescription = "Token is missing"
        }
    }
    
    private func tokenFrom(_ json: Data) -> String? {
        return nil
    }
    
}
