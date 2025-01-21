//
//  ContactAddressRow.swift
//  ContactSearch
//
//  Created by Marco Abundo on 1/10/25.
//

import SwiftUI

struct ContactAddressRow: View {
    let contactAddress: ContactAddress

    var body: some View {
        VStack(alignment: .leading) {
            Text(contactAddress.fullName)

            if let postalAddressLabeledValue = contactAddress.postalAddressLabeledValue {
                let addressString = postalAddressLabeledValue.value.addressString
                Text(addressString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
