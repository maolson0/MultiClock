//
//  PreferencesView.swift
//  MultiClock
//
//  Displays the MultiClock's "preferences" tab.
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

struct PreferencesView: View {
    @EnvironmentObject var mc: MultiClock

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(" ")
                HStack {
                    Image(systemName: "gearshape")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height:80)
                    Text("Preferences")
                        .font(.system(size: 30, weight: .bold))
                }
                Spacer()
                Text(" ")
            }
            Divider()
            HStack {
                Text("Prime time")
                    .font(.title)
                Spacer()
                Toggle("", isOn: $mc.mc_primetime)
            }
            HStack {
                Text("show prime numbers in")
                    .italic()
                Text("red")
                    .foregroundColor(.red)
                    .italic()
             }
            Divider()
            HStack {
                Text("12-hr clock")
                    .font(.title)
                Spacer()
                // if system-wide time is set to 24-hour clock, this setting is overridden for displayed times
                Toggle("", isOn: $mc.mc_12hour)
            }
        }
        .padding(10)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
