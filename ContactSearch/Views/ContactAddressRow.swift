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
                addressText
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

    @ViewBuilder
    private var addressText: some View {
        let addressText = contactAddress.postalAddressLabeledValue?.value.addressString ?? "No Address"
        Text(addressText)
            .font(.caption)
            .foregroundColor(.gray)
    }
}
