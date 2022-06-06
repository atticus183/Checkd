//
//  CreateListView.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import SwiftUI

/// A `View` that allows the user to create a new `ListEntity`.
struct CreateListView: View {
    @ObservedObject var viewModel: CreateListViewViewModel
    @FocusState private var isEnterListFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New List")
                .font(.title)
                .fontWeight(.bold)
            TextField("Please enter a list name", text: $viewModel.desiredListName)
                .focused($isEnterListFieldFocused)
                .textFieldStyle(.roundedBorder)
            Button(action: {
                viewModel.saveList()
            }, label: {
                let buttonTitle = viewModel.isListBeingEdited ? "Update List" : "Add List"
                Label(buttonTitle, systemImage: "list.dash")
                    .padding()
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .background(Color.appPrimaryColor)
                    .clipShape(Capsule())
            }).frame(maxWidth: .infinity)
            Spacer()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isEnterListFieldFocused = true
            }
        }
    }
}

// MARK: SwiftUI Preview

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CreateListViewViewModel()
        return CreateListView(viewModel: vm)
    }
}
