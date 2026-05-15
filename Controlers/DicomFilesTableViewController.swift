import SwiftUI

struct ViewerView: View {
    let parsed: ParsedDICOM
    @Environment(\.dismiss) private var dismiss

    @State private var frameIdx   = 0
    @State private var isPlaying  = false
    @State private var fps: Double = 10
    @State private var cineTimer: Timer?
    @State private var showOverlay = true

    @State private var scale: CGFloat     = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize     = .zero
    @State private var lastOffset: CGSize = .zero

    private var frame: CGImage? {
        guard !parsed.frames.isEmpty else { return nil }
        return parsed.frames[min(frameIdx, parsed.frames.count - 1)]
    }

    private var isCine: Bool { parsed.frames.count > 1 }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let cgImg = frame {
                Image(uiImage: UIImage(cgImage: cgImg))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(pinchGesture)
                    .gesture(dragGesture)
                    .onTapGesture(count: 2) { resetTransform() }
                    .onTapGesture(count: 1) {
                        withAnimation(.easeInOut(duration: 0.2)) { showOverlay.toggle() }
                    }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 36))
                        .foregroundColor(Med.warn)
                    Text("GEEN BEELDDATA")
                        .font(.medLabel())
                        .tracking(2)
                        .foregroundColor(Med.textSec)
                }
            }

            if showOverlay {
                VStack(spacing: 0) {
                    topBar
                    Spacer()
                    if isCine { cineBar }
                }
            }
        }
        .onDisappear { stopCine() }
    }

    // MARK: Top bar

    private var topBar: some View {
        HStack(alignment: .top, spacing: 0) {
            // Links: sluiten + window/level
            VStack(alignment: .leading, spacing: 8) {
                Button {
                    stopCine(); dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 34, height: 34)
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                if parsed.windowWidth > 0 {
                    VStack(alignment: .leading, spacing: 2) {
                        medInfoRow(label: "WC", value: String(format: "%.0f", parsed.windowCenter))
                        medInfoRow(label: "WW", value: String(format: "%.0f", parsed.windowWidth))
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.top, 14)

            Spacer()

            // Rechts: patiënt + modaliteit
            VStack(alignment: .trailing, spacing: 6) {
                if !parsed.patientName.isEmpty {
                    Text(parsed.patientName)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }

                HStack(spacing: 6) {
                    if !parsed.modality.isEmpty {
                        MedBadge(text: parsed.modality, color: Med.accent)
                    }
                    Text("\(parsed.columns)×\(parsed.rows)")
                        .font(.medMono(11))
                        .foregroundColor(.white.opacity(0.5))
                }

                if isCine {
                    MedBadge(text: "\(parsed.frames.count) FRAMES", color: Med.blue)
                }
            }
            .padding(.trailing, 16)
            .padding(.top, 14)
        }
        .background(
            LinearGradient(
                colors: [.black.opacity(0.7), .clear],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private func medInfoRow(label: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.medLabel())
                .tracking(1)
                .foregroundColor(Med.textSec)
            Text(value)
                .font(.medMono(11))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 3)
        .background(Color.black.opacity(0.45))
        .cornerRadius(4)
    }

    // MARK: Cine bar

    private var cineBar: some View {
        VStack(spacing: 10) {
            // Slider
            HStack(spacing: 10) {
                Text("1")
                    .font(.medMono(10))
                    .foregroundColor(Med.textSec)
                Slider(
                    value: Binding(
                        get: { Double(frameIdx) },
                        set: { frameIdx = Int($0.rounded()) }
                    ),
                    in: 0...Double(parsed.frames.count - 1),
                    step: 1
                )
                .tint(Med.accent)
                Text("\(parsed.frames.count)")
                    .font(.medMono(10))
                    .foregroundColor(Med.textSec)
            }
            .padding(.horizontal, 20)

            // Knoppen
            HStack(spacing: 0) {
                // Stap terug
                cineButton(icon: "backward.frame.fill") {
                    stopCine(); frameIdx = max(0, frameIdx - 1)
                }

                // Play/Pause
                Button { isPlaying ? stopCine() : startCine() } label: {
                    ZStack {
                        Circle()
                            .fill(Med.accent)
                            .frame(width: 48, height: 48)
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Med.bg)
                            .offset(x: isPlaying ? 0 : 2)
                    }
                }
                .padding(.horizontal, 16)

                // Stap vooruit
                cineButton(icon: "forward.frame.fill") {
                    stopCine(); frameIdx = min(parsed.frames.count - 1, frameIdx + 1)
                }

                Spacer()

                // Frame teller
                Text("\(frameIdx + 1) / \(parsed.frames.count)")
                    .font(.medMono(12))
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                // FPS menu
                Menu {
                    ForEach([5, 10, 15, 24, 30], id: \.self) { f in
                        Button("\(f) fps") {
                            fps = Double(f)
                            if isPlaying { stopCine(); startCine() }
                        }
                    }
                } label: {
                    Text("\(Int(fps)) FPS")
                        .font(.medLabel())
                        .tracking(1)
                        .foregroundColor(Med.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Med.accent.opacity(0.12))
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Med.accent.opacity(0.3), lineWidth: 0.5))
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 12)
        .padding(.bottom, 32)
        .background(
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private func cineButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 40, height: 40)
                .background(Color.white.opacity(0.08))
                .clipShape(Circle())
        }
    }

    // MARK: Cine engine

    private func startCine() {
        isPlaying = true
        cineTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / fps, repeats: true) { _ in
            frameIdx = (frameIdx + 1) % parsed.frames.count
        }
    }

    private func stopCine() {
        isPlaying = false
        cineTimer?.invalidate()
        cineTimer = nil
    }

    // MARK: Gestures

    private var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { v in scale = max(0.5, min(8, lastScale * v)) }
            .onEnded   { _ in lastScale = scale }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { v in
                offset = CGSize(
                    width:  lastOffset.width  + v.translation.width,
                    height: lastOffset.height + v.translation.height
                )
            }
            .onEnded { _ in lastOffset = offset }
    }

    private func resetTransform() {
        withAnimation(.spring()) {
            scale = 1; offset = .zero
            lastScale = 1; lastOffset = .zero
        }
    }
}
