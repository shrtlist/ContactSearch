//
//  ContactStore.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import SwiftUI
import ContactsUI

@MainActor
class ContactStore: ObservableObject {

    @Published var searchText = ""
    @Published var contactAddresses: [ContactAddress] = []
    @Published var isLoading = false

    func fetchContactAddresses() async {
        guard !isLoading else { return }
        isLoading = true

        let task = Task.detached {
            let keys = await [CNContactViewController.descriptorForRequiredKeys()] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            request.sortOrder = .familyName
            let store = CNContactStore()

            do {
                try await store.requestAccess(for: .contacts)

                var contactAddresses = [ContactAddress]()

                try store.enumerateContacts(with: request, usingBlock: { contact, stop in
                    guard !Task.isCancelled else {
                        stop.pointee = true
                        return
                    }

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

                try Task.checkCancellation()

                DispatchQueue.main.async {
                    self.contactAddresses = contactAddresses
                    self.isLoading = false
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        return await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
    }

    var searchResults: [ContactAddress] {
        if searchText.isEmpty {
            return contactAddresses
        } else {
            return contactAddresses.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
