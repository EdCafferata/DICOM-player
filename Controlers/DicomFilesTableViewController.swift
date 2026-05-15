import SwiftUI

struct ViewerView: View {
    let parsed: ParsedDICOM
    @Environment(\.dismiss) private var dismiss

    // Cine
    @State private var frameIdx  = 0
    @State private var isPlaying = false
    @State private var fps: Double = 10
    @State private var cineTimer: Timer?

    // Zoom / pan
    @State private var scale: CGFloat  = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize  = .zero
    @State private var lastOffset: CGSize = .zero

    private var frame: CGImage? {
        guard !parsed.frames.isEmpty else { return nil }
        return parsed.frames[min(frameIdx, parsed.frames.count - 1)]
    }

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
            } else {
                Text("No image data")
                    .foregroundColor(.gray)
            }

            VStack {
                // Top bar
                HStack {
                    Button {
                        stopCine()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        if !parsed.patientName.isEmpty {
                            Text(parsed.patientName)
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                        HStack(spacing: 6) {
                            if !parsed.modality.isEmpty {
                                Text(parsed.modality)
                                    .font(.caption2)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(4)
                            }
                            Text("\(parsed.columns)×\(parsed.rows)")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.trailing)
                }

                Spacer()

                // Bottom bar (cine controls, shown only for multi-frame)
                if parsed.frames.count > 1 {
                    VStack(spacing: 8) {
                        // Frame slider
                        HStack {
                            Text("1")
                                .font(.caption2).foregroundColor(.white.opacity(0.6))
                            Slider(
                                value: Binding(
                                    get: { Double(frameIdx) },
                                    set: { frameIdx = Int($0.rounded()) }
                                ),
                                in: 0...Double(parsed.frames.count - 1),
                                step: 1
                            )
                            .accentColor(.white)
                            Text("\(parsed.frames.count)")
                                .font(.caption2).foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.horizontal)

                        // Controls row
                        HStack(spacing: 20) {
                            // Step back
                            Button {
                                stopCine()
                                frameIdx = max(0, frameIdx - 1)
                            } label: {
                                Image(systemName: "backward.frame.fill")
                                    .font(.title3).foregroundColor(.white)
                            }

                            // Play / Pause
                            Button { isPlaying ? stopCine() : startCine() } label: {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.title2).foregroundColor(.white)
                            }
                            .frame(width: 44)

                            // Step forward
                            Button {
                                stopCine()
                                frameIdx = min(parsed.frames.count - 1, frameIdx + 1)
                            } label: {
                                Image(systemName: "forward.frame.fill")
                                    .font(.title3).foregroundColor(.white)
                            }

                            Spacer()

                            // Frame counter
                            Text("\(frameIdx + 1) / \(parsed.frames.count)")
                                .font(.caption.monospacedDigit())
                                .foregroundColor(.white.opacity(0.8))

                            Spacer()

                            // FPS picker
                            Menu {
                                ForEach([5, 10, 15, 24, 30], id: \.self) { f in
                                    Button("\(f) fps") {
                                        fps = Double(f)
                                        if isPlaying { stopCine(); startCine() }
                                    }
                                }
                            } label: {
                                Text("\(Int(fps)) fps")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                    .background(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                }
            }
        }
        .onDisappear { stopCine() }
    }

    // MARK: Cine

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
        withAnimation(.spring()) { scale = 1; offset = .zero; lastScale = 1; lastOffset = .zero }
    }
}
