//
//  SolarClockView.swift
//  MultiClock
//
//  Displays the MultiClock's "Civil Time" tab.
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

struct SolarClockView: View {
    @EnvironmentObject var mc: MultiClock
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "sun.max")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height:60)
                    Text("Solar Time")
                        .font(.system(size: 30, weight: .bold))
                }
                Spacer()
                Text(" ")
            }
            Divider()
            HStack {
                VStack {
                    Image(systemName: "deskclock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    Text("hh:mm")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(mc.solar_hhmm)
                        .font(.largeTitle)
                    HStack {
                        Image(systemName: "sunrise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.solar_hhmm_sunrise)
                        Text(" ")
                        Image(systemName: "sunset")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.solar_hhmm_sunset)
                    }
                }
            }
            Divider()
            HStack {
                VStack {
                    Image(systemName: "ruler")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    Text("metric")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(mc.solar_metric)
                        .font(.largeTitle)
                        .foregroundColor(mc.solar_metric_prime ? .red : (colorScheme == .dark ? .white : .black))
                    HStack {
                        Image(systemName: "sunrise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.solar_metric_sunrise)
                            .foregroundColor(mc.solar_metric_sunrise_prime ? .red : (colorScheme == .dark ? .white : .black))
                        Text(" ")
                        Image(systemName: "sunset")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.solar_metric_sunset)
                            .foregroundColor(mc.solar_metric_sunset_prime ? .red : (colorScheme == .dark ? .white : .black))
                    }
                }
            }
            Divider()
            HStack {
                ProgressView(value: mc.solar_day_progress, total:100)
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                Text(mc.solar_day_prog_pct)
            }
        }
        .padding(10)
    }
}

struct SolarClockView_Previews: PreviewProvider {
    static var previews: some View {
        SolarClockView()
    }
}
