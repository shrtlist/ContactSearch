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
        HStack {
            profileImage

            VStack(alignment: .leading) {
                Text(contactAddress.fullName)

                if let postalAddressLabeledValue = contactAddress.postalAddressLabeledValue {
                    let addressString = postalAddressLabeledValue.value.addressString
                    Text(addressString)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    @ViewBuilder
    private var profileImage: some View {
        if let data = contactAddress.contact.thumbnailImageData {
            if let image = UIImage(data: data) {
                ThumbnailImage(image: image)
            }
        } else {
            InitialsView(contact: contactAddress.contact)
        }
    }
}
