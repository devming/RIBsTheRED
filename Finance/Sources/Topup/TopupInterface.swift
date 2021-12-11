//
//  TopupInterface.swift
//  
//
//  Created by devming on 2021/12/11.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

// topup RIBlet 자체 리스너
public protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    
    func topupDidClose()
    func topupDidFinish()
}
