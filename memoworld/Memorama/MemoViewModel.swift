//
//  LoginViewModel.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 19/10/25.
//

import SwiftUI
import Combine
import SwiftData

protocol MemoViewModelProtocol: ObservableObject {
    var counter: Int { get set }
    var isInteractionDisabled: Bool { get set }
    var showAlertLose: Bool { get set }
    var cardButtonsArray: [CardCircle] { get set }
    func startSoundWaiting()
    func startCountdown(timeSeconds: Int)
    func stopCoutdown()
    func revealCard(at index: Int)
    func validateWinner() -> Bool
    func playSoundBackground()
    func startAgain()
}

@MainActor
final class MemoViewModel: MemoViewModelProtocol {
    @Published var counter: Int = 60
    @Published var cardButtonsArray: [CardCircle] = []
    @Published var isInteractionDisabled = false
    @Published var showAlertLose = false
    var imagesByMatchArray: [String] = []
    var allImages: [String] = ["cohete1","cohete2","cohete3","cohete4","cohete5","cohete6","cohete7","cohete8"]
    var revealedIndices: [Int] = []
    var timerCancellable: AnyCancellable?
    var hideTask: Task<Void, Never>?
    
    init() {
        getButtonsToMatch()
    }
    
    func startSoundWaiting() {
        SoundManager.shared.playSound(named: "esperandoBackgroundMedio",
                                      withExtension: "wav",
                                      loops: true)
    }
    
    func startCountdown(timeSeconds: Int) {
        counter = timeSeconds
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.counter -= 1
                if self.counter == 0 {
                    stopCoutdown()
                }
            }
    }
    
    func stopCoutdown() {
        guard let timerCancellable = timerCancellable else { return }
        timerCancellable.cancel()
        SoundManager.shared.stopAll()
        if showAlertLose == false && validateWinner() == false {
            showAlertLose = true
        }
        print("🎯 Acción al finalizar el conteo2")
    }
    
    private func shuffleImages(count: Int) -> [String] {
        return Array(allImages.shuffled().prefix(count))
    }
    
    func getImagesToMatch() {
        let images: [String] = shuffleImages(count: 6)
        let reverseImages: [String] = Array(images.shuffled().prefix(6))
        imagesByMatchArray.append(contentsOf: images)
        imagesByMatchArray.append(contentsOf: reverseImages)
    }
    
    func getButtonsToMatch() {
        getImagesToMatch()
        for index in 0...11 {
            let cardButton = CardCircle(imageName: imagesByMatchArray[index])
            cardButtonsArray.append(cardButton)
        }
        print(cardButtonsArray)
    }
    
    func revealCard(at index: Int) {
        guard !cardButtonsArray[index].isRevealed else { return }
       
        if revealedIndices.count >= 2 {
            hideTask?.cancel()
            hideUnmatchedCards()
        }
        
        cardButtonsArray[index].isRevealed = true
        revealedIndices.append(index)
        
        if revealedIndices.count == 2 {
            startHideTimer()
        }
    }
    
    private func startHideTimer() {
        hideTask?.cancel()
        
        hideTask = Task {
            do {
                try await Task.sleep(for: .seconds(4))
                guard !Task.isCancelled else { return }
                hideUnmatchedCards()
            } catch {
                print("tarea cancelada")
            }
        }
    }
    
    @discardableResult
    private func hideUnmatchedCards() -> Bool {
        guard revealedIndices.count == 2 else { return false }
        
        let firstIndex = revealedIndices[0]
        let secondIndex = revealedIndices[1]
        
        let firstCard = cardButtonsArray[firstIndex]
        let secondCard = cardButtonsArray[secondIndex]
        
        if firstCard.imageName == secondCard.imageName {
            // 🎯 Coincidencia: marcar como encontradas
            cardButtonsArray[firstIndex].setIsRevealed(to: true)
            cardButtonsArray[secondIndex].setIsRevealed(to: true)
            cardButtonsArray[firstIndex].setMatchStatus(to: true)
            cardButtonsArray[secondIndex].setMatchStatus(to: true)
        } else {
            // ❌ No coinciden: vuelve a taparlas
            cardButtonsArray[firstIndex].isRevealed = false
            cardButtonsArray[secondIndex].isRevealed = false
        }
        
        revealedIndices.removeAll()
        return true
    }
    
    func validateWinner() -> Bool {
        print("Si gano?: ",cardButtonsArray.allSatisfy(\.isRevealed))
        return cardButtonsArray.allSatisfy(\.isRevealed)
    }
    
    func startAgain() {
        counter = 60
        cardButtonsArray = []
        getButtonsToMatch()
        isInteractionDisabled = false
        imagesByMatchArray = []
        revealedIndices = []
        timerCancellable = nil
        showAlertLose = false
    }
    
    func playSoundBackground() {
        SoundManager.shared.playSound(named: "esperandoBackgroundMedio",
                                      withExtension: "wav",
                                      loops: true)
    }
}
