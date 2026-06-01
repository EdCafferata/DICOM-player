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
                // Gekleurde cirkel met letter — rendeert altijd goed
                ZStack {
                    Circle()
                        .fill(iconColor)
                        .frame(width: 44, height: 44)
                    Text(iconLetter)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

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
                        .foregroundColor(Med.bg)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Med.accent)
                        .clipShape(Capsule())
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

    private var iconLetter: String {
        switch true {
        case product.id.hasSuffix(".small"):  return "K"
        case product.id.hasSuffix(".medium"): return "L"
        case product.id.hasSuffix(".large"):  return "D"
        default: return "♥"
        }
    }

    private var iconColor: Color {
        switch true {
        case product.id.hasSuffix(".small"):  return Color(red: 0.71, green: 0.47, blue: 0.24)
        case product.id.hasSuffix(".medium"): return Color(red: 0.86, green: 0.31, blue: 0.20)
        case product.id.hasSuffix(".large"):  return Color(red: 0.24, green: 0.63, blue: 0.47)
        default: return Med.accent
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

    private var updateListener: Task<Void, Never>?

    init() {
        updateListener = Task { await listenForTransactions() }
        Task {
            await load()
            await loadEntitlements()
        }
    }

    deinit {
        updateListener?.cancel()
    }

    func load() async {
        do {
            let fetched = try await Product.products(for: tipProductIDs)
            if fetched.isEmpty {
                failed = true
            } else {
                products = fetched.sorted { $0.price < $1.price }
            }
        } catch {
            failed = true
        }
    }

    func purchase(_ product: Product) async {
        purchasing = product.id
        defer { purchasing = nil }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let tx) = verification {
                    purchased.insert(tx.productID)
                    await tx.finish()
                }
            case .pending, .userCancelled:
                break
            @unknown default:
                break
            }
        } catch {
            // Purchase cancelled or failed — no action needed
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await loadEntitlements()
    }

    // Loads already-purchased non-consumable entitlements (survives reinstall via iCloud).
    private func loadEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let tx) = result {
                purchased.insert(tx.productID)
            }
        }
    }

    // Handles transactions that arrive outside the purchase() call (e.g. Ask to Buy approval,
    // interrupted purchases completing on relaunch, family sharing).
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let tx) = result {
                purchased.insert(tx.productID)
                await tx.finish()
            }
        }
    }
}
