//
//  ContactAddressList.swift
//  ContactSearch
//
//  Created by Marco Abundo on 6/9/21.
//

import SwiftUI
import Contacts

struct ContactAddressList: View {
    @EnvironmentObject var contactStore: ContactStoreManager
    @State private var navPath: [CNContact] = []

    var body: some View {
        NavigationStack(path: $navPath) {
            Group {
                if contactStore.isLoading {
                    ProgressView()
                } else if contactStore.searchResults.isEmpty {
                    ScrollView {
                        ContentUnavailableView.init("No results", systemImage: "person.crop.circle")
                    }
                } else {
                    List(contactStore.searchResults) { contactAddress in
                        ContactAddressRow(contactAddress: contactAddress)
                            .onTapGesture {
                                navPath.append(contactAddress.contact)
                            }
                    }
                }
            }
            .searchable(text: $contactStore.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Contacts")
            .navigationDestination(for: CNContact.self) { contact in
                ContactView(contact: contact)
                    .navigationBarHidden(true)
                    .ignoresSafeArea(.all)
                    .overlay(alignment: .top) {
                        Color.primary.opacity(0.001)
                            .frame(height: 56)
                            .overlay(alignment: .trailing) {
                                Button {
                                    navPath.removeLast()
                                } label: {
                                    Text("Done")
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                .padding()
                            }
                    }
            }
            .onAppear {
                Task {
                    await contactStore.fetchContactAddresses()
                }
            }
        }
    }
}

#Preview {
    ContactAddressList()
        .environmentObject(ContactStoreManager())
}
