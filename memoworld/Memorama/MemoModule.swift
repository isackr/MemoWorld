//
//  MemoModule.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 15/11/25.
//

import SwiftUICore

struct MemoModule {
    static func build() -> some View {
        let memoModel = MemoModel()
        let memoViewModel = MemoViewModel(memoModel: memoModel)
        let memoView = MemoView(memoViewModel: memoViewModel)
        return memoView
    }
}
