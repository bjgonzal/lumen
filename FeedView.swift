import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: FeedViewModel
    @EnvironmentObject var store: InsightStore
    @State private var showingAddInsight = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(store.insights) { insight in
                            InsightCard(insight: insight)
                                .padding(.horizontal)
                        }
                        .onDelete(perform: store.delete)
                    }
                    .padding(.top)
                }
                .navigationTitle("Lūmen")

                // Floating Add Button
                Button(action: {
                    showingAddInsight = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(.black.opacity(0.7))
                                .shadow(radius: 4)
                        )
                }
                .padding()
                .accessibilityLabel("Add new insight")
            }
            .sheet(isPresented: $showingAddInsight) {
                AddInsightView()
                    .environmentObject(store)
            }
        }
    }
}

