import SwiftUI

enum Tab: String, CaseIterable, Identifiable, Hashable{

    case timer = "Timer"
    case settings = "Settings"
    case statistics = "Statistics"
    
    
    
    var systemImage: String{
        switch self{
       
        case .settings:
            return "timer"
        case .timer:
            return "list.clipboard"
        case .statistics:
            return "chart.bar.fill"
        }
    }
    var id: String {
        return self.rawValue
      }

    
    var index: Int{
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}



