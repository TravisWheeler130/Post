//
//  Post.swift
//  Post
//
//  Created by Travis Wheeler on 9/30/19.
//  Copyright © 2019 Travis Wheeler. All rights reserved.
//

import Foundation

struct Post: Codable {
    /*
     text : "###"
     timestamp : 1544592680.2133331
     username : "ffsda"
     */
    let text: String
    var timestamp: TimeInterval = Date().timeIntervalSince1970
    let username: String
    // queryTimeStamp -part 2
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.text = text
        self.username = username
        self.timestamp = timestamp
    }
    //Computer Property
      var queryTimestamp: TimeInterval {
          return self.timestamp - 0.00001
      }
}
