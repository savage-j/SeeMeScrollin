//
//  RSSParser.swift
//  SeeMeScrollin
//
//  Created by Jordan Carlson on 4/18/17.
//  Copyright © 2017 savagej. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireRSSParser

public enum NetworkResponseStatus {
    case success
    case error(string: String?)
}
public class RSSParser {
    public static func getRSSFeedResponse(path: String, completionHandler: @escaping (_ response: RSSFeed?,_ status: NetworkResponseStatus) -> Void) {
        Alamofire.request(path).responseRSS() { response in
            if let rssFeedXML = response.result.value {
                completionHandler(rssFeedXML, .success)
            } else {
                completionHandler(nil, .error(string: response.result.error?.localizedDescription))
            }
        }
    }
}
