//
//  AddressController.swift
//  Sidewalk
//
//  Created by Marco Abundo on 3/2/19.
//  Copyright 2019 shrtlist.com. All rights reserved.
//

import UIKit
import Contacts

extension CNPostalAddress {
    var addressString: String {
        let formattedString = CNPostalAddressFormatter.string(from: self, style: .mailingAddress)
        return formattedString.replacingOccurrences(of: "\n", with: ", ")
    }
}
