import SwiftUI

struct TipJarCoachMark: View {
    @Binding var isShowing: Bool
    @State private var pulse = false
    @State private var arrowBounce = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Donkere achtergrond
                Color.black.opacity(0.72)
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }

                // Spotlight rond het hartje (rechtsboven)
                spotlightCutout(geo: geo)

                // Pijl + tekst
                VStack(spacing: 0) {
                    arrowLabel(geo: geo)
                    Spacer()
                    dismissHint
                }
            }
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

    // MARK: Spotlight

    private func spotlightCutout(geo: GeometryProxy) -> some View {
        // Positie van het hartje: 56pt van rechts, ~56pt van top (header hoogte ~68)
        let heartCY = geo.safeAreaInsets.top + 56
        let r: CGFloat = 28

        return Canvas { ctx, size in
            let heartCX = size.width - 56
            let ring = Path(ellipseIn: CGRect(x: heartCX-r, y: heartCY-r, width: r*2, height: r*2))
            ctx.stroke(ring, with: .color(.white.opacity(0.9)), lineWidth: 2.5)

            let glow = Path(ellipseIn: CGRect(x: heartCX-r-8, y: heartCY-r-8,
                                              width: (r+8)*2, height: (r+8)*2))
            ctx.stroke(glow, with: .color(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(pulse ? 0.6 : 0.2)),
                       lineWidth: pulse ? 3 : 1.5)
        }
    }

    // MARK: Pijl + label

    private func arrowLabel(geo: GeometryProxy) -> some View {
        let cx = geo.size.width - 56
        let topInset = geo.safeAreaInsets.top

        return VStack(alignment: .trailing, spacing: 8) {
            // Tekst blok
            VStack(alignment: .trailing, spacing: 6) {
                Text("Steun de ontwikkelaar")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("Deze app is gratis.\nEen kleine bijdrage helpt enorm.")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(red: 0.09, green: 0.14, blue: 0.22).opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.8, green: 0.1, blue: 0.1).opacity(0.4), lineWidth: 1)
                    )
            )
            .padding(.trailing, 16)

            // Gebogen pijl omhoog naar het hartje
            CurvedArrow()
                .stroke(
                    Color(red: 0.8, green: 0.1, blue: 0.1),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 52, height: 70)
                .overlay(alignment: .topTrailing) {
                    // Pijlpunt
                    Image(systemName: "arrowshape.up.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                        .offset(x: 4, y: -6)
                }
                .padding(.trailing, 52)
                .offset(y: arrowBounce ? -6 : 0)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, topInset + 100)
    }

    // MARK: Onderin tikken om te sluiten

    private var dismissHint: some View {
        Button(action: dismiss) {
            HStack(spacing: 8) {
                Image(systemName: "hand.tap")
                    .font(.system(size: 14))
                Text("TIK OM TE SLUITEN")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .tracking(1.5)
            }
            .foregroundColor(.white.opacity(0.45))
            .padding(.bottom, 40)
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.25)) {
            isShowing = false
        }
    }
}

// MARK: - Gebogen pijl shape

private struct CurvedArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        // Begint rechtsonder, buigt naar linksboven
        p.move(to: CGPoint(x: rect.maxX - 4, y: rect.maxY))
        p.addCurve(
            to:        CGPoint(x: rect.minX + 8, y: rect.minY + 16),
            control1:  CGPoint(x: rect.maxX,     y: rect.midY),
            control2:  CGPoint(x: rect.midX,     y: rect.minY)
        )
        return p
    }
}
