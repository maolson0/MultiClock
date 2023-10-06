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

struct ContentView: View {
    @EnvironmentObject var mc: MultiClock
    
    var body: some View {
        TabView() {
            /*
            CivilClockView()
                .tabItem {
                    Label("civil", systemImage: "building.columns.fill")
                    Text("Civil")
                }
            SolarClockView()
                .tabItem {
                    Label("solar", systemImage: "sun.max.fill")
                    Text("Solar")
                }
             */
            TimeView()
                .tabItem {
                    Label("time", systemImage: "deskclock.fill")
                    Text("Time")
                }
            InfoView()
                .tabItem {
                    Label("info", systemImage: "info.circle.fill")
                    Text("Info")
                }
            PreferencesView()
                .tabItem {
                    Label("prefs", systemImage: "gearshape.fill")
                    Text("Prefs")
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
