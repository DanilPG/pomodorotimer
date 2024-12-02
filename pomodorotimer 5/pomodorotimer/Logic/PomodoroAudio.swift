import Foundation
import AVFoundation

enum PomodoroAudioSounds {
  case done
  
  var resource: String {  //Возращает строку с названием звука
    switch self {
    case .done:
      return "finish.wav"
    }
  }
}

class PomodoroAudio {  //Данный класс принимает параметр sound из PomodoroAudioSounds,
                                            //находит путь к звуку с именем sound
  private var _audioPlayer: AVAudioPlayer?
  
  func play(_ sound: PomodoroAudioSounds) {
    let path = Bundle.main.path(forResource: sound.resource, ofType: nil)!
    let url = URL(filePath: path)
    
    do {
      _audioPlayer = try AVAudioPlayer(contentsOf: url)
      _audioPlayer?.play()
    } catch {
      print(error.localizedDescription)
    }
    
  }
}
