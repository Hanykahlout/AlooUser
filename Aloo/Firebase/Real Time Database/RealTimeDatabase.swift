//
//  RealTimeDatabase.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 06/12/2021.
//

import Foundation
import FirebaseDatabase

class RealTimeDatabase{
    
    public static var shard: RealTimeDatabase = {
        let realTimeDatabase = RealTimeDatabase()
        return realTimeDatabase
    }()
    
    private var database: DatabaseReference!
    
    private init(){
        database = Database.database().reference()
    }
    
    func getStatusValue(id:String,callback:@escaping (Int)->Void){
        database.child("orders").child(id).observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let status = value?["status"] as? Int ?? 0
            callback(status)
        }
    }
    

}
