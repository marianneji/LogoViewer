//
//  DomainService.swift
//  LogoViewer
//
//  Created by Graphic Influence on 08/10/2019.
//  Copyright © 2019 OpenClassrooms. All rights reserved.
//

import Foundation

class DomainService {
    static var shared = DomainService()
    private init() {}

    private let logoURL = "https://logo.clearbit.com/"
    private var task: URLSessionDataTask?

    func getLogo(domain: String, callback: @escaping (Bool, Logo?) -> Void) {

        let resultURL = "\(logoURL)\(domain)?size=500" // Get the logoURL + the domain add in textField, add size to get a better quality of image
        let request = URLRequest(url: URL(string: resultURL)!)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                let logo = Logo(imageData: data)
                callback(true, logo)
            }
        }
        task?.resume()
    }
}
