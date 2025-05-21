//
//  ContactStoreManager.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/16/21.
//

import SwiftUI
import ContactsUI
import OSLog

@MainActor
class ContactStoreManager: ObservableObject {

    @Published var searchText = ""
    @Published var contactAddresses: [ContactAddress] = []
    @Published var isLoading = false
    @Published var authorizationStatus: CNAuthorizationStatus

    var searchResults: [ContactAddress] {
        if searchText.isEmpty {
            return contactAddresses
        } else {
            return contactAddresses.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private let store: CNContactStore
    private let logger = Logger(subsystem: "ContactSearch", category: "ContactStore")

    init() {
        self.store = CNContactStore()
        self.authorizationStatus = .notDetermined
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name.CNContactStoreDidChange, object: nil)
    }

    /// Fetches the Contacts authorization status of the app.
    func fetchAuthorizationStatus() {
        authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
    }

    /// Prompts the person for access to Contacts if the authorization status of the app can't be determined.
    func requestAccess() async {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        guard status == .notDetermined else { return }

        do {
            try await store.requestAccess(for: .contacts)

            // Update the authorization status of the app.
            fetchAuthorizationStatus()
        } catch {
            fetchAuthorizationStatus()
            logger.error("Requesting Contacts access failed: \(error)")
        }
    }

    @objc func reloadData() {
        Task {
            await fetchContactAddresses()
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
                // Fetch all contact containers (iCloud, Google, etc.)
                let allContainers = try await store.containers(matching: nil)

                for container in allContainers {
                    // Create a predicate using the container identifier
                    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

                    // Fetch contacts for the container
                    let contacts = try await store.unifiedContacts(matching: predicate, keysToFetch: fetchRequest.keysToFetch)

                    // Process contacts from this container
                    for contact in contacts {
                        let postalAddresses = contact.postalAddresses

                        if !postalAddresses.isEmpty {
                            for postalAddress in postalAddresses {
                                let contactAddress = ContactAddress(contact: contact, postalAddressLabeledValue: postalAddress)
                                result.append(contactAddress)
                            }
                        } else {
                            let contactAddress = ContactAddress(contact: contact)
                            result.append(contactAddress)
                        }
                    }
                }
            } catch {
                logger.error("Fetching contacts failed: \(error)")
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
