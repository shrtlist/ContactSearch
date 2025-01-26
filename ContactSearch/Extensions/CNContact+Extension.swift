//
//  CNContact+Extensions.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import Foundation
import Contacts

extension CNContact {
    /// The combined contact name components.
    var fullName: String {
        if let name = CNContactFormatter.string(from: self, style: .fullName) {
            return name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return "No Name"
    }

    /// The formatted name of a contact.
    var formattedName: String {
        CNContactFormatter().string(from: self) ?? "No Name"
    }

    /// The contact name's initials.
    var initials: String {
        String(self.givenName.prefix(1) + self.familyName.prefix(1))
    }

    static var sample: CNContact {
        CNContact()
    }
}
