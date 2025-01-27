//
//  AddressController.swift
//  Sidewalk
//
//  Created by Marco Abundo on 3/2/19.
//  Copyright 2019 shrtlist.com. All rights reserved.
//

import Contacts

extension CNPostalAddress {
    var addressString: String {
        return CNPostalAddressFormatter.string(from: self, style: .mailingAddress)
    }
}
