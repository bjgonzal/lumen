import SwiftUI

struct ChatbotView: View {
    @StateObject private var viewModel = ChatbotViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                conversation
                inputBar
            }
            .navigationTitle("Lumēn Guide")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.clearConversation()
                        } label: {
                            Label("Clear Conversation", systemImage: "arrow.uturn.left")
                        }

                        Button(role: .destructive) {
                            viewModel.resetMemory()
                        } label: {
                            Label("Reset Memory", systemImage: "brain.head.profile")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                    .accessibilityLabel("Chatbot options")
                }
            }
        }
    }

    private var conversation: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    statusCard

                    ForEach(viewModel.messages) { message in
                        messageBubble(for: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .scrollIndicators(.hidden)
            .background(Color.clear)
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom(proxy, animated: true)
            }
            .onAppear {
                scrollToBottom(proxy, animated: false)
            }
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("\(viewModel.learnedResponseCount) learned replies", systemImage: "sparkles")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)

            if let pendingPrompt = viewModel.pendingTeachingPrompt {
                Text("Waiting to learn how to respond to \"\(pendingPrompt)\".")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("Teach the Lumēn Guide by sharing how you'd answer prompts that matter to you.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
        )
    }

    private func messageBubble(for message: ChatMessage) -> some View {
        HStack {
            if message.role == .bot {
                bubbleContent(for: message)
                Spacer(minLength: 40)
            } else {
                Spacer(minLength: 40)
                bubbleContent(for: message)
            }
        }
        .animation(nil, value: viewModel.messages.count)
    }

    private func bubbleContent(for message: ChatMessage) -> some View {
        let isUser = message.role == .user

        return VStack(alignment: isUser ? .trailing : .leading, spacing: 6) {
            Text(message.text)
                .font(.callout)
                .multilineTextAlignment(isUser ? .trailing : .leading)
                .padding(16)
                .foregroundStyle(isUser ? Color.white : Color.primary)
                .background(alignment: .center) {
                    if isUser {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.accentColor.opacity(0.95), Color.accentColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(.ultraThinMaterial)
                    }
                }
                .shadow(
                    color: isUser ? Color.black.opacity(0.25) : Color.black.opacity(0.08),
                    radius: 12,
                    x: 0,
                    y: 6
                )

            Text(message.timestamp, style: .time)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var inputBar: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.1))

            HStack(alignment: .bottom, spacing: 12) {
                TextField("Share a prompt or teach a reply...", text: $viewModel.inputText, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .focused($isInputFocused)
                    .submitLabel(.send)
                    .onSubmit {
                        sendMessage()
                    }

                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                        .padding(12)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
                .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
        .background(.thinMaterial)
    }

    private func sendMessage() {
        viewModel.sendCurrentMessage()
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy, animated: Bool) {
        guard let last = viewModel.messages.last else { return }

        DispatchQueue.main.async {
            if animated {
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            } else {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

#Preview {
    ChatbotView()
}
