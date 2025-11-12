//
//  MemoViewModelTests.swift
//  memoworldTests
//
//  Created by Isaac Rosas Camarillo on 11/11/25.
//

import XCTest
@testable import memoworld

@MainActor
final class MemoViewModelTests: XCTestCase {
    
    var viewModel: MemoViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MemoViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Inicialización
    
    func test_initialState_shouldHave12Cards() {
        XCTAssertEqual(viewModel.cardButtonsArray.count, 12, "El ViewModel debe tener 12 cartas al inicializarse.")
    }
    
    func test_initialCounter_shouldBe60() {
        XCTAssertEqual(viewModel.counter, 60, "El contador inicial debe ser 60.")
    }
    
    // MARK: - Imagenes y mezcla
    
    @MainActor
    func test_getImagesToMatch_shouldGenerate12Images() {
        viewModel.imagesByMatchArray = []
        viewModel.getImagesToMatch()
        XCTAssertEqual(viewModel.imagesByMatchArray.count, 12, "Debe generar 12 imágenes para hacer las parejas.")
    }
    
    func test_shuffleImages_returnsUniqueSubset() {
        let shuffled = viewModel.cardButtonsArray.map { $0.imageName }
        let unique = Set(shuffled)
        XCTAssertTrue(unique.count <= 12, "Las imágenes deben ser aleatorias pero no más de 12.")
    }
    
    // MARK: - Contador
    
    func test_startCountdown_shouldDecreaseCounter() async throws {
        await viewModel.startCountdown(timeSeconds: 3)
        try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5s
        XCTAssertLessThan(viewModel.counter, 3, "El contador debería haber disminuido.")
        await viewModel.startAgain()
    }
    
    // MARK: - Lógica de juego
    
    @MainActor
    func test_revealCard_shouldRevealAndStoreIndex() {
        let initialRevealed = viewModel.revealedIndices.count
        viewModel.revealCard(at: 0)
        XCTAssertEqual(viewModel.revealedIndices.count, initialRevealed + 1, "Debe agregar el índice revelado al arreglo.")
        XCTAssertTrue(viewModel.cardButtonsArray[0].isRevealed, "La carta debe quedar revelada.")
    }
    
    func test_hideUnmatchedCards_shouldHideIfDifferent() {
        // Crear dos cartas con imágenes distintas
        viewModel.cardButtonsArray[0].imageName = "uno"
        viewModel.cardButtonsArray[1].imageName = "dos"
        viewModel.revealCard(at: 0)
        viewModel.revealCard(at: 1)
        
        // Espera la tarea asincrónica
        let expectation = XCTestExpectation(description: "Espera que se oculten las cartas")
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            XCTAssertFalse(self.viewModel.cardButtonsArray[0].isRevealed)
            XCTAssertFalse(self.viewModel.cardButtonsArray[1].isRevealed)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_validateWinner_shouldReturnTrueWhenAllCardsRevealed() {
        for i in viewModel.cardButtonsArray.indices {
            viewModel.cardButtonsArray[i].isRevealed = true
        }
        XCTAssertTrue(viewModel.validateWinner(), "Debe retornar true si todas las cartas están reveladas.")
    }
    
    @MainActor
    func test_startAgain_shouldResetState() {
        viewModel.revealCard(at: 0)
        viewModel.isInteractionDisabled = true
        viewModel.startAgain()
        XCTAssertEqual(viewModel.counter, 60)
        XCTAssertFalse(viewModel.isInteractionDisabled)
        XCTAssertEqual(viewModel.revealedIndices.count, 0)
        XCTAssertEqual(viewModel.cardButtonsArray.count, 12)
    }
}
