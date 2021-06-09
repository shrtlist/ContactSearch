//
//  ContactAddress.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import Contacts

struct ContactAddress: Identifiable {
    let id: String
    let contact: CNContact
    var postalAddressLabeledValue: CNLabeledValue<CNPostalAddress>?

    init(contact: CNContact, postalAddressLabeledValue: CNLabeledValue<CNPostalAddress>? = nil) {
        self.contact = contact
        self.postalAddressLabeledValue = postalAddressLabeledValue

        if let addressIdentifier = postalAddressLabeledValue?.identifier {
            id = addressIdentifier
        } else {
            id = contact.identifier
        }
    }

    var addressString: String? {
        return postalAddressLabeledValue?.value.debugDescription
    }

    var formattedName: String {
        return contact.formattedName
    }

    var label: String? {
        return postalAddressLabeledValue?.label
    }

    var formattedNameAndAddressLabel: String {
        var name = formattedName

        if let label = label {
            let localizedLabel = CNLabeledValue<CNPostalAddress>.localizedString(forLabel: label)
            name.append(" (\(localizedLabel))")
        }

        return name
    }
}
