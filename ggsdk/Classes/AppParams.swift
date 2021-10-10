import Foundation

import SwiftyJSON

class AppParams : NSObject {

    var app_id: String!
    var app_status: Int!
    var app_status_name: String!
    
    var ad_id: String!
    var ad_status: Int!
    var ad_status_name: String!
    var ad_type: Int!
    var ad_type_name: String!
    
    var platform: String!
    
    var pid: Int!

    init(fromJSON json:JSON) {
        app_id = json["app_id"].stringValue
        app_status = json["app_status"].intValue
        app_status_name = json["app_status_name"].string
        
        ad_id = json["ad_id"].stringValue
        ad_status = json["ad_status"].intValue
        ad_status_name = json["ad_status_name"].stringValue
        ad_type = json["ad_type"].intValue
        ad_type_name = json["ad_type_name"].stringValue
        
        platform = json["platform"].stringValue
        
        pid = json["pid"].intValue
    }
    
}
