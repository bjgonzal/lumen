import Foundation
import Combine

@MainActor
final class ChatbotViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published private(set) var pendingTeachingPrompt: String?
    @Published private(set) var learnedResponseCount: Int = 0

    private var knowledgeBase: [String: String] = [:]

    private let knowledgeSaveKey = "lumen.chatbot.knowledge"
    private let messagesSaveKey = "lumen.chatbot.messages"
    private let pendingPromptKey = "lumen.chatbot.pendingPrompt"
    private let historyLimit = 200

    init() {
        loadKnowledge()
        loadMessages()
        loadPendingPrompt()

        if messages.isEmpty {
            seedConversation(with: "Hello, I'm the Lumēn Guide. Ask me something you'd like me to learn.")
        }
    }

    func sendCurrentMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        inputText = ""
        handleUserMessage(trimmed)
    }

    func clearConversation() {
        updatePendingPrompt(nil)
        seedConversation(with: "Hello again. What would you like to teach me today?")
    }

    func resetMemory() {
        knowledgeBase = [:]
        learnedResponseCount = 0
        updatePendingPrompt(nil)
        saveKnowledge()
        seedConversation(with: "My mind is clear and ready to learn anew.")
    }

    // MARK: - Private helpers

    private func handleUserMessage(_ text: String) {
        appendMessage(ChatMessage(text: text, role: .user))

        if let pendingPrompt = pendingTeachingPrompt {
            learnResponse(for: pendingPrompt, taughtResponse: text)
            return
        }

        if let knownResponse = bestResponse(for: text) {
            appendMessage(ChatMessage(text: knownResponse, role: .bot))
        } else {
            updatePendingPrompt(text)
            let learningPrompt = "I'm still learning. How should I respond when you say \"\(text)\"?"
            appendMessage(ChatMessage(text: learningPrompt, role: .bot))
        }
    }

    private func learnResponse(for prompt: String, taughtResponse: String) {
        let key = normalize(prompt)
        knowledgeBase[key] = taughtResponse
        learnedResponseCount = knowledgeBase.count
        updatePendingPrompt(nil)
        saveKnowledge()

        let acknowledgement = "Thank you! I'll remember to respond to \"\(prompt)\" with \"\(taughtResponse)\"."
        appendMessage(ChatMessage(text: acknowledgement, role: .bot))
    }

    private func bestResponse(for text: String) -> String? {
        let normalized = normalize(text)
        if let exact = knowledgeBase[normalized] {
            return exact
        }

        return knowledgeBase.first { key, _ in
            key.contains(normalized) || normalized.contains(key)
        }?.value
    }

    private func appendMessage(_ message: ChatMessage) {
        messages.append(message)
        if messages.count > historyLimit {
            messages.removeFirst(messages.count - historyLimit)
        }
        saveMessages()
    }

    private func seedConversation(with openingLine: String) {
        updatePendingPrompt(nil)
        messages = [ChatMessage(text: openingLine, role: .bot)]
        saveMessages()
    }

    private func normalize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func loadKnowledge() {
        guard let data = UserDefaults.standard.data(forKey: knowledgeSaveKey),
              let decoded = try? JSONDecoder().decode([String: String].self, from: data) else {
            knowledgeBase = [:]
            learnedResponseCount = 0
            return
        }

        knowledgeBase = decoded
        learnedResponseCount = knowledgeBase.count
    }

    private func saveKnowledge() {
        guard let data = try? JSONEncoder().encode(knowledgeBase) else { return }
        UserDefaults.standard.set(data, forKey: knowledgeSaveKey)
    }

    private func loadMessages() {
        guard let data = UserDefaults.standard.data(forKey: messagesSaveKey),
              let decoded = try? JSONDecoder().decode([ChatMessage].self, from: data) else {
            messages = []
            return
        }

        messages = decoded
    }

    private func saveMessages() {
        guard let data = try? JSONEncoder().encode(messages) else { return }
        UserDefaults.standard.set(data, forKey: messagesSaveKey)
    }

    private func loadPendingPrompt() {
        guard let prompt = UserDefaults.standard.string(forKey: pendingPromptKey) else { return }
        pendingTeachingPrompt = prompt
    }

    private func updatePendingPrompt(_ prompt: String?) {
        pendingTeachingPrompt = prompt
        if let prompt {
            UserDefaults.standard.set(prompt, forKey: pendingPromptKey)
        } else {
            UserDefaults.standard.removeObject(forKey: pendingPromptKey)
        }
    }
}
