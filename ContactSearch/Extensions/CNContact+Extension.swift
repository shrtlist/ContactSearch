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
        String(self.givenName.prefix(1) + self.familyName.prefix(1))
    }

    static var sample: CNContact {
        CNContact()
    }
}
