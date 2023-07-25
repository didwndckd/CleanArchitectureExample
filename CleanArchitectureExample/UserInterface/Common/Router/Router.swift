//
//  Router.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/25.
//

import SwiftUI

protocol Router {
    associatedtype Destination: RouterDestination
    var destination: Destination? { get set }
}

extension Router {
    var isPush: Bool {
        get {
            return destination?.transitionStyle == .push
        }
        set {
            if !newValue {
                destination = nil
            }
        }
    }
    
    var isSheet: Bool {
        get {
            return destination?.transitionStyle == .sheet
        }
        set {
            if !newValue {
                destination = nil
            }
        }
    }
    
    var isFullScreenCover: Bool {
        get {
            return destination?.transitionStyle == .fullScreenCover
        }
        set {
            if !newValue {
                destination = nil
            }
        }
    }
}

extension View {
    func bindRouter<R: Router>(_ router: Binding<R>) -> some View {
        return self
            .navigationDestination(isPresented: router.isPush) {
                if let destination = router.destination.wrappedValue {
                    destination.view
                }
            }
            .sheet(isPresented: router.isSheet) {
                if let destination = router.destination.wrappedValue {
                    destination.view
                }
            }
            .fullScreenCover(isPresented: router.isFullScreenCover) {
                if let destination = router.destination.wrappedValue {
                    destination.view
                }
            }
    }
}

struct DefaultRouter<Destination: RouterDestination>: Router {
    var destination: Destination?
}


struct FullScreenCoverTestView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Text("FullScreenCover")
                .toolbar {
                    Button("Back") {
                        dismiss()
                    }
                }
        }
    }
}

enum TestDestination: RouterDestination {
    case sheet
    case push
    case fullScreenCover

    @ViewBuilder
    var view: some View {
        switch self {
        case .sheet:
            Text("Sheet")
        case .push:
            Text("Push")
        case .fullScreenCover:
            FullScreenCoverTestView()
        }
    }

    var transitionStyle: RouterTransitionStyle {
        switch self {
        case .sheet:
            return .sheet
        case .push:
            return .push
        case .fullScreenCover:
            return .fullScreenCover
        }
    }
}

struct TestView: View {
    @State var router = DefaultRouter<TestDestination>()

    var body: some View {
        NavigationStack {
            List {
                Button("push", action: {
                    router.destination = .push
                })

                Button("sheet", action: {
                    router.destination = .sheet
                })

                Button("fullScreenCover", action: {
                    router.destination = .fullScreenCover
                })
            }
            .bindRouter($router)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
