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
                    }.swipeActions(edge: .leading) {
                        SwipeView(action: {
                            viewModel.coordinator?.goToCreateListView(editingList: list)
                        }, swipeViewType: .edit)
                    }.swipeActions(edge: .trailing) {
                        SwipeView(action: {
                            viewModel.deleteList(list: list)
                        }, swipeViewType: .delete)
                    }
                }.onMove { indexSet, destination in
                    viewModel.moveList(from: indexSet, to: destination)
                }
            }
            .listStyle(.insetGrouped)

            VStack {
                Spacer()
                AddButtonView {
                    viewModel.coordinator?.goToCreateListView(editingList: nil)
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
            Text(list.status)
        }
    }
}

// MARK: SwiftUI Preview

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataStack = CoreDataStack(inMemory: true)
        ListEntity.createForPreview(coreDataStack: coreDataStack)
        let repo = DefaultListRepository(coreDataStack: coreDataStack)
        let vm = ListViewViewModel(listRepository: repo)

        return NavigationView {
            ListView(viewModel: vm)
                .navigationTitle("Lists")
        }
    }
}
