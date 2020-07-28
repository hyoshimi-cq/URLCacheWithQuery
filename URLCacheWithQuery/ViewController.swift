//
//  ViewController.swift
//  URLCacheWithQuery
//
//  Created by YoshimiHiromu on 2020/07/27.
//  Copyright © 2020 Yoshimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let hogeQuery = URLQueryItem(name: "hoge", value: "1")
    let fugaQuery = URLQueryItem(name: "fuga", value: "2")

    func sendRequest(_ request: URLRequest) {
        if let cache = URLCache.shared.cachedResponse(for: request) {
            print("キャッシュを使用 response: \(cache.response)")
            return
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response else {
                print("error: \(error)")
                return
            }

            print("キャッシュを使用していない response: \(response)")
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
        }.resume()
    }

    func createRequest(with queries: [URLQueryItem]) -> URLRequest? {
        guard var components = URLComponents(string: "https://caraquri.com/") else { return nil }
        components.queryItems = queries

        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }

    @IBAction func hogeFuga(_ sender: Any) {
        // hoge, fugaの順番にする
        guard let request = createRequest(with: [hogeQuery, fugaQuery]) else { return }
        sendRequest(request)
    }

    @IBAction func fugaHoge(_ sender: Any) {
        // fuga, hogeの順番にする
        guard let request = createRequest(with: [fugaQuery, hogeQuery]) else { return }
        sendRequest(request)
    }

    @IBAction func clearCache(_ sender: Any) {
        URLCache.shared.removeAllCachedResponses()
    }
}
