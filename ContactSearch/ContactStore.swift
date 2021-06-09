//
//  ContactStore.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import SwiftUI
import Contacts
import ContactsUI

class ContactStore: ObservableObject {

    @Published var contacts: [ContactAddress] = []
    @Published var error: Error? = nil

    func fetchContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }

            if granted {
                let keys = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactPostalAddressesKey as CNKeyDescriptor, CNContactViewController.descriptorForRequiredKeys(), CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                request.sortOrder = .familyName

                do {
                    var contactsArray = [ContactAddress]()
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        let postalAddresses = contact.postalAddresses

                        if !postalAddresses.isEmpty {
                            for (_, postalAddress) in postalAddresses.enumerated() {
                                let contactAddress = ContactAddress(contact: contact, postalAddressLabeledValue: postalAddress)
                                contactsArray.append(contactAddress)
                            }
                        } else {
                            let contactAddress = ContactAddress(contact: contact)
                            contactsArray.append(contactAddress)
                        }
                    })

                    DispatchQueue.main.async {
                        self.contacts = contactsArray
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
