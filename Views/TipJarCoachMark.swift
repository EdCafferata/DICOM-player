import SwiftUI

struct TipJarCoachMark: View {
    @Binding var isShowing: Bool
    var onDonate: (() -> Void)? = nil

    @State private var pulse = false
    @State private var arrowBounce = false

    // Hart zit op: X = W - 84, Y = safeAreaInset + 34
    private let heartOffsetFromRight: CGFloat = 84
    private let heartOffsetFromTop:   CGFloat = 34

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.opacity(0.72)
                    .ignoresSafeArea()

                spotlightCutout(geo: geo)
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    arrowSection(geo: geo)
                    Spacer()
                    donateButtons
                }
                .allowsHitTesting(true)
            }
            .contentShape(Rectangle())
            .onTapGesture { dismiss() }
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                pulse = true
            }
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true).delay(0.2)) {
                arrowBounce = true
            }
        }
    }

    // MARK: Spotlight — ring precies rond het hartje

    private func spotlightCutout(geo: GeometryProxy) -> some View {
        let hx = geo.size.width  - heartOffsetFromRight
        let hy = geo.safeAreaInsets.top + heartOffsetFromTop
        let r:  CGFloat = 26

        return Canvas { ctx, _ in
            let ring = Path(ellipseIn: CGRect(x: hx-r, y: hy-r, width: r*2, height: r*2))
            ctx.stroke(ring, with: .color(.white.opacity(0.9)), lineWidth: 2.5)

            let glow = Path(ellipseIn: CGRect(x: hx-r-9, y: hy-r-9,
                                              width: (r+9)*2, height: (r+9)*2))
            ctx.stroke(glow,
                       with: .color(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(pulse ? 0.55 : 0.15)),
                       lineWidth: pulse ? 3 : 1.5)
        }
    }

    // MARK: Pijl — tip wijst naar het hartje

    private func arrowSection(geo: GeometryProxy) -> some View {
        // padding(.trailing, heartOffsetFromRight + 4) → arrowhead.X = W - 84 ✓
        // padding(.top,      heartOffsetFromTop + 6)  → arrowhead.Y ≈ safeArea + 34 ✓
        CurvedArrow()
            .stroke(
                Color(red: 0.8, green: 0.1, blue: 0.1),
                style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            )
            .frame(width: 52, height: 80)
            .overlay(alignment: .topTrailing) {
                Image(systemName: "arrowshape.up.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                    .offset(x: 4, y: -6)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, heartOffsetFromRight)
            .padding(.top, geo.safeAreaInsets.top + heartOffsetFromTop + 6)
            .offset(y: arrowBounce ? -5 : 0)
            .allowsHitTesting(false)
    }

    // MARK: Drie donate knoppen onderin

    private var donateButtons: some View {
        VStack(spacing: 12) {
            ForEach(tipOptions, id: \.id) { opt in
                Button {
                    dismiss()
                    onDonate?()
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(opt.color).frame(width: 42, height: 42)
                            Text(opt.emoji)
                                .font(.system(size: 22))
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(opt.naam)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text(opt.omschrijving)
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        Spacer()
                        Text(opt.prijs)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.08, green: 0.14, blue: 0.26))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(Color(red: 0, green: 0.76, blue: 0.8))
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.09, green: 0.14, blue: 0.22).opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(0.3), lineWidth: 1)
                    )
                }
            }

            Text("of tik ergens om te sluiten")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(.white.opacity(0.35))
                .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 52)
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.25)) {
            isShowing = false
        }
    }
}

// MARK: - Tip opties (hardcoded, matchen App Store Connect)

private struct TipOption: Identifiable {
    let id: String
    let emoji: String
    let naam: String
    let prijs: String
    let omschrijving: String
    let color: Color
}

private let tipOptions: [TipOption] = [
    TipOption(id: "small",  emoji: "☕", naam: "Koffie", prijs: "€ 0,99",
              omschrijving: "Kleine bijdrage, grote glimlach",
              color: Color(red: 0.71, green: 0.47, blue: 0.24)),
    TipOption(id: "medium", emoji: "🍕", naam: "Lunch",  prijs: "€ 2,99",
              omschrijving: "Houd de ontwikkelaar goed gevoed",
              color: Color(red: 0.86, green: 0.31, blue: 0.20)),
    TipOption(id: "large",  emoji: "🍽️", naam: "Diner",  prijs: "€ 9,99",
              omschrijving: "Echt waardevol — hartstikke bedankt!",
              color: Color(red: 0.24, green: 0.63, blue: 0.47)),
]

// MARK: - Gebogen pijl shape

private struct CurvedArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.maxX - 4, y: rect.maxY))
        p.addCurve(
            to:        CGPoint(x: rect.minX + 8, y: rect.minY + 16),
            control1:  CGPoint(x: rect.maxX,     y: rect.midY),
            control2:  CGPoint(x: rect.midX,     y: rect.minY)
        )
        return p
    }
}
