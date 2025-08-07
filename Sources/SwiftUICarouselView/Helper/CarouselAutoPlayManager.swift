//
//  CarouselAutoPlayManager.swift
//  SwiftUICarouselView
//
//  Created by Lei on 2025/8/7.
//
import Foundation
import Combine

final class CarouselAutoPlayManager: ObservableObject {
    @Published public var shouldMoveNext: Bool = false
    @Published public private(set) var isPlaying: Bool = false

    private var timer: Timer?
    private var autoPlay: AutoPlay = .default
    
    deinit {
        stop()
    }

    func configure(_ autoPlay: AutoPlay) {
        self.autoPlay = autoPlay
    }

    func start() {
        guard !isPlaying else { return }
        
        stop()
        
        timer = Timer.scheduledTimer(withTimeInterval: autoPlay.interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.shouldMoveNext = true
            }
        }
        
        isPlaying = true
    }
    
    func pause() {
        guard isPlaying else {
            return
        }
        
        timer?.invalidate()
        timer = nil
        isPlaying = false
    }
    
    func resume() {
        guard !isPlaying else {
            return
        }
        start()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isPlaying = false
        shouldMoveNext = false
    }
    
    func restart() {
        if isPlaying {
            stop()
            start()
        }
    }

    func handleUserInteraction(resumeAfter delay: TimeInterval = 2.0) {
        guard isPlaying else {
            return
        }
        
        pause()
        
        Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            if !isPlaying {
                resume()
            }
        }
    }
}
