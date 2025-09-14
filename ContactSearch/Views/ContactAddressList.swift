//
//  ContactAddressList.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/9/21.
//

import SwiftUI
import Contacts

struct ContactAddressList: View {
    @Bindable var contactStore: ContactStoreManager

    var body: some View {
        NavigationStack {
            Group {
                if contactStore.isLoading {
                    ProgressView()
                } else if contactStore.searchResults.isEmpty {
                    ScrollView {
                        ContentUnavailableView.init("No results", systemImage: "person.crop.circle")
                    }
                } else {
                    List(contactStore.searchResults) { contactAddress in
                        NavigationLink(destination: {
                            ContactDetailView(contact: contactAddress.contact)
                        }, label: {
                            ContactAddressRow(contactAddress: contactAddress)
                        })
                    }
                }
            }
            .searchable(text: $contactStore.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Contacts")
            .onAppear {
                Task {
                    await contactStore.fetchContactAddresses()
                }
            }
        }
    }
}

#Preview {
    ContactAddressList(contactStore: ContactStoreManager())
}
