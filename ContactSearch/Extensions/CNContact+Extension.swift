//
//  CNContact+Extensions.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import Contacts

extension CNContact {
    /// The formatted name of a contact.
    var formattedName: String {
        CNContactFormatter().string(from: self) ?? "No Name"
    }

    /// The contact name's initials.
    var initials: String {
        var contactInitials = String(self.givenName.prefix(1) + self.familyName.prefix(1))

        if contactInitials.isEmpty {
            contactInitials = String(self.organizationName.prefix(1))
        }
        return contactInitials
    }

    static var sample: CNContact {
        CNContact()
    }
}
