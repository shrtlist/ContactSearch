//
//  CNContact+Extensions.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import Foundation
import Contacts

extension CNContact {
    /// - returns: The formatted name of a contact if there is one and "No Name", otherwise.
    var formattedName: String {
        if let name = CNContactFormatter.string(from: self, style: .fullName) {
            return name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return "No Name"
    }

    /// Determines whether a contact is a person or organization.
    var isPerson: Bool {
        return (self.contactType == .person)
    }
}
