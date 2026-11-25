import SwiftUI

enum Med {
    static let bg      = Color(hex: "05080F")
    static let surface = Color(hex: "0F1A2E")
    static let card    = Color.white.opacity(0.06)
    static let cardLine = Color.white.opacity(0.11)
    static let border  = Color.white.opacity(0.10)
    static let accent  = Color(hex: "00C2CB")   // klinisch teal
    static let accentText = Color(hex: "3FD9E0") // teal voor tekst op donker (beter contrast)
    static let onAccent = Color(hex: "03201F")
    static let blue    = Color(hex: "2F80ED")
    static let heart   = Color(hex: "FF7A8A")
    static let danger  = Color(hex: "E05252")
    static let warn    = Color(hex: "F59E0B")
    static let textPri = Color(hex: "EEF3FA")
    static let textSec = Color(hex: "9AA8BF")
    static let textDim = Color(hex: "6F7F99")
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: h).scanHexInt64(&v)
        self.init(
            red:   Double((v >> 16) & 0xFF) / 255,
            green: Double((v >> 8)  & 0xFF) / 255,
            blue:  Double( v        & 0xFF) / 255
        )
    }
}

extension Font {
    static func medLabel() -> Font { .system(size: 12, weight: .semibold) }
    static func medCaption() -> Font { .system(size: 13, weight: .regular) }
    static func medBody() -> Font { .system(size: 16, weight: .semibold) }
    static func medTitle() -> Font { .system(size: 20, weight: .bold) }
    static func medLargeTitle() -> Font { .system(size: 34, weight: .heavy) }
    static func medMono(_ size: CGFloat = 12) -> Font { .system(size: size, weight: .medium).monospacedDigit() }
}

// MARK: - Glas & kaarten

extension View {
    /// Liquid Glass op iOS 26+, anders een donker materiaal met een dunne rand.
    @ViewBuilder
    func medGlass(cornerRadius: CGFloat = 22) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.white.opacity(0.16), lineWidth: 1))
        }
    }

    /// Rond glazen knopje (44 pt) voor iconen.
    @ViewBuilder
    func medGlassCircle() -> some View {
        if #available(iOS 26.0, *) {
            self.frame(width: 44, height: 44)
                .glassEffect(.regular.interactive(), in: .circle)
        } else {
            self.frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.16), lineWidth: 1))
        }
    }

    /// Inhoudskaart: licht doorschijnend vlak met rand.
    func medCard(cornerRadius: CGFloat = 20) -> some View {
        self
            .background(Med.card, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Med.cardLine, lineWidth: 1))
    }

    /// Zachte gekleurde gloed achter een scherm (zoals in Molenwind/Riskonacci).
    func medGlow(_ color: Color = Med.accent, alignment: Alignment = .topTrailing) -> some View {
        self.background(alignment: alignment) {
            Circle()
                .fill(color.opacity(0.13))
                .frame(width: 360, height: 360)
                .blur(radius: 70)
                .offset(x: alignment == .topLeading ? -150 : 130, y: -150)
                .allowsHitTesting(false)
        }
    }
}

struct MedBadge: View {
    let text: String
    var color: Color = Med.accentText

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.16), in: RoundedRectangle(cornerRadius: 8))
    }
}

struct MedDivider: View {
    var body: some View {
        Rectangle()
            .fill(Med.border)
            .frame(height: 0.5)
    }
}
