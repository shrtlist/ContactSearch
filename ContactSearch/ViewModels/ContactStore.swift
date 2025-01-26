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

    var searchResults: [ContactAddress] {
        if searchText.isEmpty {
            return contactAddresses
        } else {
            return contactAddresses.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }

    /// Fetches all contactAddresses authorized for the app.
    func fetchContactAddresses() async {
        guard !isLoading else { return }
        isLoading = true

        let keys = [CNContactViewController.descriptorForRequiredKeys()] as [CNKeyDescriptor]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        fetchRequest.sortOrder = .familyName

        let result = await executeFetchRequest(fetchRequest)
        contactAddresses = result

        isLoading = false
    }

    /// Executes the fetch request.
    nonisolated private func executeFetchRequest(_ fetchRequest: CNContactFetchRequest) async -> [ContactAddress] {
        let fetchingTask = Task {
            var result: [ContactAddress] = []

            do {
                try CNContactStore().enumerateContacts(with: fetchRequest) { contact, stop in
                    guard !Task.isCancelled else {
                        stop.pointee = true
                        return
                    }

                    let postalAddresses = contact.postalAddresses

                    if !postalAddresses.isEmpty {
                        for (_, postalAddress) in postalAddresses.enumerated() {
                            let contactAddress = ContactAddress(contact: contact, postalAddressLabeledValue: postalAddress)
                            result.append(contactAddress)
                        }
                    } else {
                        let contactAddress = ContactAddress(contact: contact)
                        result.append(contactAddress)
                    }
                }

                try Task.checkCancellation()
            } catch {
                print(error.localizedDescription)
            }

            return result
        }
        return await withTaskCancellationHandler {
            await fetchingTask.result.get()
        } onCancel: {
            fetchingTask.cancel()
        }
    }
}
