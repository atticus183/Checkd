//
//  CreateListView.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import SwiftUI

struct CreateListView: View {
    @ObservedObject var viewModel: CreateListViewViewModel

    @State private var showingAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New List")
                .font(.title)
                .fontWeight(.bold)
            TextField("Please enter a list name", text: $viewModel.desiredListName)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                if viewModel.desiredListName
                    .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showingAlert = true
                } else {
                    viewModel.addList()
                }
            }, label: {
                Label("Add List", systemImage: "list.dash")
                    .padding()
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .background(.pink)
                    .clipShape(Capsule())
            }).frame(maxWidth: .infinity)
                .alert("Please enter a valid list name", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            Spacer()
        }
        .padding()
    }
}

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CreateListViewViewModel()
        return CreateListView(viewModel: vm)
    }
}
