import SwiftUI
import StoreKit

// MARK: - Product IDs (must match App Store Connect)
private let tipProductIDs = [
    "info.cafferata.dicomplayer.tip.small",
    "info.cafferata.dicomplayer.tip.medium",
    "info.cafferata.dicomplayer.tip.large",
]

// MARK: - TipJarView

struct TipJarView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = TipStore()

    var body: some View {
        ZStack {
            Med.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                MedDivider()
                content
            }
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("SUPPORT")
                    .font(.medLabel())
                    .tracking(2.5)
                    .foregroundColor(Med.textSec)
                Text("Steun de ontwikkelaar")
                    .font(.medTitle())
                    .foregroundColor(Med.textPri)
            }
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Med.textDim)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Med.surface)
    }

    // MARK: Content

    private var content: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Icon + tekst
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(0.12))
                            .frame(width: 80, height: 80)
                        Text("☕")
                            .font(.system(size: 38))
                    }
                    VStack(spacing: 6) {
                        Text("BEDANKT VOOR JE VERTROUWEN")
                            .font(.medLabel())
                            .tracking(2)
                            .foregroundColor(Med.textSec)
                            .multilineTextAlignment(.center)
                        Text("Deze app is gratis en zonder advertenties.\nEen kleine bijdrage helpt enorm.")
                            .font(.medCaption())
                            .foregroundColor(Med.textSec)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
                .padding(.top, 28)

                // Tip opties
                VStack(spacing: 10) {
                    if store.products.isEmpty && !store.failed {
                        ProgressView()
                            .tint(Med.accent)
                            .padding(.vertical, 30)
                    } else if store.failed {
                        Text("Kan producten niet laden.\nControleer je internetverbinding.")
                            .font(.medCaption())
                            .foregroundColor(Med.textSec)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                    } else {
                        ForEach(store.products, id: \.id) { product in
                            TipButton(product: product, isPurchased: store.purchased.contains(product.id), store: store)
                        }
                    }
                }
                .padding(.horizontal, 20)

                // Dank
                if !store.purchased.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                        Text("Dank je wel! Dit betekent veel.")
                            .font(.medCaption())
                            .foregroundColor(Med.textSec)
                    }
                    .padding(.bottom, 4)
                }

                // Restore
                Button {
                    Task { await store.restore() }
                } label: {
                    Text("Aankopen herstellen")
                        .font(.medCaption())
                        .foregroundColor(Med.textDim)
                        .underline()
                }
                .padding(.bottom, 28)
            }
        }
    }
}

// MARK: - Tip Button

private struct TipButton: View {
    let product: Product
    let isPurchased: Bool
    let store: TipStore

    var body: some View {
        Button {
            guard !isPurchased else { return }
            Task { await store.purchase(product) }
        } label: {
            HStack(spacing: 14) {
                Text(emoji)
                    .font(.system(size: 24))
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName)
                        .font(.medBody())
                        .foregroundColor(Med.textPri)
                    Text(product.description)
                        .font(.medCaption())
                        .foregroundColor(Med.textSec)
                }

                Spacer()

                if isPurchased {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Med.accent)
                        .font(.system(size: 18))
                } else if store.purchasing == product.id {
                    ProgressView()
                        .tint(Med.accent)
                        .scaleEffect(0.85)
                } else {
                    Text(product.displayPrice)
                        .font(.medBody())
                        .foregroundColor(Med.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Med.accent.opacity(0.12))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Med.accent.opacity(0.3), lineWidth: 0.5))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Med.card)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Med.border, lineWidth: 0.5))
        }
        .disabled(store.purchasing != nil)
    }

    private var emoji: String {
        switch product.id {
        case _ where product.id.hasSuffix(".small"):  return "☕"
        case _ where product.id.hasSuffix(".medium"): return "🍕"
        case _ where product.id.hasSuffix(".large"):  return "🍽️"
        default: return "💙"
        }
    }
}

// MARK: - TipStore (StoreKit 2)

@MainActor
final class TipStore: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchased: Set<String> = []
    @Published var purchasing: String? = nil
    @Published var failed = false

    init() {
        Task { await load() }
    }

    func load() async {
        do {
            let fetched = try await Product.products(for: tipProductIDs)
            products = fetched.sorted { $0.price < $1.price }
        } catch {
            failed = true
        }
    }

    func purchase(_ product: Product) async {
        purchasing = product.id
        defer { purchasing = nil }
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result,
               case .verified(let tx) = verification {
                purchased.insert(tx.productID)
                await tx.finish()
            }
        } catch {
            // Purchase cancelled or failed — no action needed
        }
    }

    func restore() async {
        try? await AppStore.sync()
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result {
                purchased.insert(tx.productID)
            }
        }
    }
}
