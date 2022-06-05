//
//  ContentView.swift
//  Checkd
//
//  Created by Josh R on 6/3/22.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewViewModel
    @State private var showingCreateListView = false

    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.lists, id: \.id) { list in
                    ListRow(list: list) {
                        viewModel.coordinator?.goToTodoListView(list: list)
                    }
                }.onDelete { indexSet in
                    viewModel.deleteList(at: indexSet)
                }.onMove { indexSet, destination in
                    viewModel.moveList(from: indexSet, to: destination)
                }
            }
            .listStyle(.insetGrouped)

            VStack {
                Spacer()
                AddButtonView {
                    viewModel.coordinator?.goToCreateListView()
                }.padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())   //fixes console errors
        .onAppear {
            viewModel.fetchLists()
        }
    }
}

struct ListRow: View {
    let list: ListEntity

    var action: () -> Void

    var body: some View {
        HStack {
            Button(action: { action() }) {
                Label {
                    Text(list.name ?? "").foregroundColor(.primary)
                } icon: {
                    Image(systemName: "list.dash")
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
            Text("\(list.todoCount)")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListEntity.createForPreview()
        let vm = ListViewViewModel()
        return ListView(viewModel: vm)
    }
}
