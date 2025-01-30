//
//  CNPostalAddressz+Extension.swift
//  ContactSearch
//
//  Created by Marco Abundo on 3/2/19.
//  Copyright 2019 shrtlist.com. All rights reserved.
//

import Contacts

extension CNPostalAddress {
    var addressString: String {
        let mutableAddress = CNMutablePostalAddress()
        mutableAddress.street = self.street
        mutableAddress.city = self.city
        mutableAddress.state = self.state
        mutableAddress.postalCode = self.postalCode
        mutableAddress.subLocality = self.subLocality
        mutableAddress.subAdministrativeArea = self.subAdministrativeArea
        // Exclude country (don't set `mutableAddress.country`)

        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: mutableAddress).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
