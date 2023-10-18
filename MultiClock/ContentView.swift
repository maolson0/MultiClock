//
//  ContentView.swift
//  MultiClock
//
//  Tabbed UI for the solar metric clock.
//
//  Copyright 2023, Michael A. Olson.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of
//     conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of
//     conditions and the following disclaimer in the documentation and/or other materials
//     provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its contributors may be
//     used to endorse or promote products derived from this software without specific prior
//     written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND ANY EXPRESS
//  OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
//  OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
//  TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import SwiftUI

// We want to know whether a metric time is a prime number so we can highlight it in the clock display.
// Hard-code the primes up to the square root of a four-digit integer and test them on the metric time
// strings supplied.
//
// This extension gets used in TimeView and ConverterView. I declare it here since it spans multiple views.

var PrimeList: [Int] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47,
  53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101]
var nPrimes = 26
extension String {
    var isPrimeMetricTime: Bool {
        if let mt = Int(self) {
            for i in 0...nPrimes-1 {
                if (mt == PrimeList[i]) {
                    return true
                }
                if ((mt % PrimeList[i]) == 0) {
                    return false
                }
            }
            // by here, not divisible by any of the prime factors
            return true
        }
        // wasn't convertible to an int, can't be a prime int
        return false
    }
}

extension NSNotification {
    static let uDefaults = Notification.Name.init("NSUserDefaultsDidChangeNotification")
}

struct ContentView: View {
    @EnvironmentObject var mc: MultiClock
    
    var body: some View {
        TabView() {
            TimeView()
                .tabItem {
                    Label("time", systemImage: "deskclock.fill")
                    Text("Time")
                }
            ConverterView()
                .tabItem {
                    Label("convert", systemImage: "arrow.left.arrow.right.square")
                    Text("Convert)")
                }
            InfoView()
                .tabItem {
                    Label("info", systemImage: "info.circle.fill")
                    Text("Info")
                }
        }.onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.uDefaults, object: nil, queue: nil) { _ in
                // if the user changes defaults in the systems settings, reload the state variables in the clock
                mc.loadDefaults()
            }
        }
    }
    
}

struct ContentView_Previews:
    PreviewProvider {
    @EnvironmentObject var mc: MultiClock
    static var previews: some View {
        ContentView()
    }
}
