//
//  Global.swift
//  17Test
//
//  Created by 劉柏賢 on 2021/10/2.
//

import Foundation


/// Run once after delay if no be called
///
/// - Parameters:
///   - delay: delay time
///   - saveCurrent: should put it to 'property scope'
///   - getCurrent: should pass 'weak' self property
///   - once: do once closure
func runOnce(delay: TimeInterval,
                saveCurrent: inout DispatchTime?,
                getCurrent: @autoclosure @escaping () -> DispatchTime?,
                once: @escaping () -> Void)
{
    let begin: DispatchTime = DispatchTime.now()
    saveCurrent = begin
    
    DispatchQueue.main.asyncAfter(deadline: begin + delay) {
        
        guard let current = getCurrent(), current == begin else {
            print("Ignore because still be called")
            return
        }
        
        print("Run once")
        once()
    }
}
