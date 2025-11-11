//
//  Sonidos.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 28/10/25.
//
import Foundation
import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    
    // Un diccionario para manejar varios sonidos a la vez
    private var players: [String: AVAudioPlayer] = [:]
    
    // MARK: - Reproducir un sonido
    func playSound(named name: String, withExtension ext: String = "wav", loops: Bool = false, volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("⚠️ No se encontró el archivo \(name).\(ext)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loops ? -1 : 0
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            // Guardamos el player en el diccionario para controlarlo luego
            players[name] = player
            
        } catch {
            print("❌ Error al reproducir \(name): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Detener un sonido específico
    func stopSound(named name: String) {
        players[name]?.stop()
        players[name] = nil
    }
    
    // MARK: - Detener todos los sonidos
    func stopAll() {
        for (_, player) in players {
            player.stop()
        }
        players.removeAll()
    }
    
    // MARK: - Cambiar volumen de un sonido
    func setVolume(for name: String, volume: Float) {
        guard let player = players[name] else { return }
        player.volume = max(0.0, min(volume, 1.0)) // limita entre 0 y 1
    }
    
    // MARK: - Pausar / Reanudar sonido
    func pauseSound(named name: String) {
        players[name]?.pause()
    }
    
    func resumeSound(named name: String) {
        players[name]?.play()
    }
}

//Button("▶️ Play Efecto") {
//    SoundManager.shared.playSound(named: "click", withExtension: "wav")
//}
//
//Button("🎵 Play Música Loop") {
//    SoundManager.shared.playSound(named: "background", withExtension: "mp3", loops: true, volume: 0.5)
//}
//
//Button("⏹ Stop Música") {
//    SoundManager.shared.stopSound(named: "background")
//}
//
//Button("🔇 Stop Todos") {
//    SoundManager.shared.stopAll()
//}
//
//Button("🔊 Subir Volumen Música") {
//    SoundManager.shared.setVolume(for: "background", volume: 1.0)
//}

//Caso    Recomendación
//🎮 Muchos efectos de sonido rápidos    Usa AVAudioPlayer como aquí.
//🎵 Música de fondo larga    También funciona, pero podrías usar AVQueuePlayer si necesitas listas.
//🧠 Sonidos pesados o simultáneos (juegos grandes)    Considera AVAudioEngine para más control.
//📱 En iOS real    Recuerda que si el teléfono está en silencio, el sonido no se oye (a menos que uses una sesión de audio especial).
