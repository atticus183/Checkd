//
//  CreateListView.swift
//  Checkd
//
//  Created by Josh R on 6/4/22.
//

import SwiftUI

struct CreateListView: View {
    @ObservedObject var viewModel: CreateListViewViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New List")
                .font(.title)
                .fontWeight(.bold)
            TextField("Please enter a list name", text: $viewModel.desiredListName)
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
    }
}

struct CreateListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CreateListViewViewModel()
        return CreateListView(viewModel: vm)
    }
}
