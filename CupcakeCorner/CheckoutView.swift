//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Aaron Graves on 8/3/24.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    var body: some View {
        Text(order.name)
    }
}

#Preview {
    CheckoutView(order: Order())
}
