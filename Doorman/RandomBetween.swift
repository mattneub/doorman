

import Foundation

@objcMembers
class DMRandom : NSObject {
    func randomIntBetween(_ a: Int, and b: Int) -> Int {
        Int.random(in: a...b)
    }
    func randomFloatBetween(_ a: CGFloat, and b: CGFloat) -> CGFloat {
        CGFloat.random(in: a...b)
    }

}
