//
//  CreateListView.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import SwiftUI

private enum Field: Int, Hashable {
    case enterListName
}

struct CreateListView: View {
    @ObservedObject var viewModel: CreateListViewViewModel

    @FocusState private var enterListField: Field?
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
                viewModel.addList()
            }, label: {
                Label("Add List", systemImage: "list.dash")
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

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CreateListViewViewModel()
        return CreateListView(viewModel: vm)
    }
}
