import SwiftUI

enum Med {
    static let bg      = Color(hex: "080E1A")
    static let surface = Color(hex: "0F1A2E")
    static let card    = Color(hex: "162035")
    static let border  = Color(hex: "1E3050")
    static let accent  = Color(hex: "00C2CB")   // klinisch teal
    static let blue    = Color(hex: "2F80ED")
    static let danger  = Color(hex: "E05252")
    static let warn    = Color(hex: "F59E0B")
    static let textPri = Color(hex: "E8EEF7")
    static let textSec = Color(hex: "5A7099")
    static let textDim = Color(hex: "2E4066")
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
    static func medLabel() -> Font { .system(size: 10, weight: .semibold, design: .rounded) }
    static func medCaption() -> Font { .system(size: 12, weight: .regular, design: .rounded) }
    static func medBody() -> Font { .system(size: 14, weight: .medium, design: .rounded) }
    static func medTitle() -> Font { .system(size: 17, weight: .bold, design: .rounded) }
    static func medMono(_ size: CGFloat = 12) -> Font { .system(size: size, weight: .medium, design: .monospaced) }
}

struct MedBadge: View {
    let text: String
    var color: Color = Med.accent

    var body: some View {
        Text(text)
            .font(.medLabel())
            .tracking(1.2)
            .foregroundColor(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(color.opacity(0.4), lineWidth: 0.5))
            .cornerRadius(4)
    }
}

struct MedDivider: View {
    var body: some View {
        Rectangle()
            .fill(Med.border)
            .frame(height: 0.5)
    }
}
