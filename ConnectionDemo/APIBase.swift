//
//  APIBase.swift
//

import UIKit

class APIStatus {
    var isSuccessfull = false
    var statusDescription: String?
}

class APIBase: APIStatus {
    
    typealias RequestParameters = [String : String]
    typealias Response = [String : AnyObject]
    
    // MARK: - Request builders
    
    func createPOST(urlSuffix: String, parameters: RequestParameters) {
        request = makeRequest(urlSuffix: urlSuffix)
        request?.httpMethod = "POST"
        request?.httpBody = jsonParameters(from: parameters)
        request?.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func createGET(urlSuffix: String) {
        request = makeRequest(urlSuffix: urlSuffix)
        request?.httpMethod = "GET"
    }
    
    // MARK: -
    
    func connect(processResponse: @escaping () -> Void) {
        guard let request = self.request else {
            // error("request is nil. Please define request in API subclass")
            isSuccessfull = false
            DispatchQueue.main.async {
                processResponse()
            }
            return
        }
        dataTask = defaultSession.dataTask(with: request) {
            data, response, error in
            if let error = error {
                self.isSuccessfull = false
                self.statusDescription = error.localizedDescription
                DispatchQueue.main.async {
                    processResponse()
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                self.isSuccessfull = false
                DispatchQueue.main.async {
                    processResponse()
                }
                return
            }
            self.isSuccessfull = httpResponse.statusCode == 200

            // TODO: Convert Data to more convenient JSON object, e.x. SwiftyJSON
            if let json = data {
                if self.isSuccessfull {
                    self.processSuccess(json)
                } else {
                    self.processFail(json)
                }
            }
            DispatchQueue.main.async {
                processResponse()
            }
        }
        dataTask?.resume()
    }

    // MARK: - Overridables
    
    func processSuccess(_ json: Data) {
        // default processSuccess
    }
    
    func processFail(_ json: Data) {
        // default processFail
        guard let errorArray = errorArrayFrom(json) else {
            return
        }
        if let statusDescriptionString = errorArray.first {
            statusDescription = statusDescriptionString
        }
    }

    // MARK: - Implementation
    
    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    private var dataTask: URLSessionDataTask?
    private var request: URLRequest?

    private func makeRequest(urlSuffix: String) -> URLRequest {
        let baseURL = "http://backend.com/"
        let apiKey = "api key"
        let urlString = baseURL + urlSuffix
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        return request
    }
    
    private func jsonParameters(from parameters: RequestParameters) -> Data? {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(parameters)
            return json
        } catch {
            return nil
        }
    }
    
    private func errorArrayFrom(_ json: Data) -> Array<String>? {
        return nil
    }
    
}
