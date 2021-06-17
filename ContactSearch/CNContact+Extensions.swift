//
//  CNContact+Extensions.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import Foundation
import Contacts

extension CNContact {
    /// - returns: Combined contact name components and "No Name", otherwise.
    var fullName: String {
        if let name = CNContactFormatter.string(from: self, style: .fullName) {
            return name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return "No Name"
    }
}
