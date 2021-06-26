//
//  ContactStore.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import SwiftUI
import ContactsUI

class ContactStore: ObservableObject {

    @Published var contactAddresses: [ContactAddress] = []
    @Published var error: Error? = nil

    func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }

            if granted {
                let keys = [CNContactViewController.descriptorForRequiredKeys()] as [CNKeyDescriptor]

                let request = CNContactFetchRequest(keysToFetch: keys)
                request.sortOrder = .familyName

                do {
                    var contactAddresses = [ContactAddress]()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        let postalAddresses = contact.postalAddresses

                        if !postalAddresses.isEmpty {
                            for (_, postalAddress) in postalAddresses.enumerated() {
                                let contactAddress = ContactAddress(contact: contact, postalAddressLabeledValue: postalAddress)
                                contactAddresses.append(contactAddress)
                            }
                        } else {
                            let contactAddress = ContactAddress(contact: contact)
                            contactAddresses.append(contactAddress)
                        }
                    })

                    DispatchQueue.main.async {
                        self.contactAddresses = contactAddresses
                    }
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
}
