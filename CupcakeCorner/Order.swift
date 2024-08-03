//
//  Order.swift
//  CupcakeCorner
//
//  Created by Aaron Graves on 8/2/24.
//

import Foundation
import Observation

struct UserAddress: Codable {
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
}

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        /*case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"*/
        case _userAddress = "userAddress"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    /*var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""*/
    var userAddress: UserAddress
    /*var name: String {
        get {
            userAddress.name
        }
        set {
            userAddress.name = newValue
        }
    }
    var streetAddress: String {
        get {
            userAddress.streetAddress
        }
        set {
            userAddress.streetAddress = newValue
        }
    }
    var city: String {
        get {
            userAddress.city
        }
        set {
            userAddress.city = newValue
        }
    }
    var zip: String {
        get {
            userAddress.zip
        }
        set {
            userAddress.zip = newValue
        }
    }*/
    
    var hasValidAddress: Bool {
        //if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
        if userAddress.name.isReallyEmpty || userAddress.streetAddress.isReallyEmpty || userAddress.city.isReallyEmpty || userAddress.zip.isReallyEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // Complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    init() {
        // Read from UserDefaults to see if we have previously saved an address. If not, then return an empty struct
        if let address = UserDefaults.standard.data(forKey: "UserAddress") {
            if let decodedItems = try? JSONDecoder().decode(UserAddress.self, from: address) {
                userAddress = decodedItems
                return
            }
        }
        userAddress = UserAddress()
    }
    
    func saveAddress() {
        // Save data to user defaults
        if let encoded = try? JSONEncoder().encode(userAddress) {
            UserDefaults.standard.set(encoded, forKey: "UserAddress")
        }
    }
}

// We're checking if a string, ecluding spaces and newlines, is empty
extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
