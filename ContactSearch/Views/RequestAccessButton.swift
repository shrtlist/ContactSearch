/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A button that prompts the person for authorization to access Contacts.
*/

import SwiftUI

struct RequestAccessButton: View {
    @EnvironmentObject var contactStore: ContactStoreManager

    var body: some View {
        NavigationStack {
            notDeterminedView
                .navigationTitle("Contacts")
        }
    }
    
    private var notDeterminedView: some View {
        ContentUnavailableView {
            Label("Unknown Access", systemImage: "person.fill.questionmark")
        } description: {
            let access = "The person hasn't yet decided whether the app may access their contact data."
            let reason = "The app requires access to fetch and display contacts."
            Text("\(access) \(reason)")
                .multilineTextAlignment(.center)
        } actions: {
            requestButton
        }
    }
    
    private var requestButton: some View {
        Button {
            Task {
                await contactStore.requestAccess()
            }
        } label: {
            Text("Request Access")
        }
    }
}

#Preview {
    RequestAccessButton()
        .environmentObject(ContactStoreManager())
}
