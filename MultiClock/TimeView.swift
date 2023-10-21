//
//  TimeView.swift
//  MultiClock
//
//  Displays the MultiClock's Time tab.
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

struct TimeView: View {
    @EnvironmentObject var mc: MultiClock
    @Environment(\.colorScheme) private var colorScheme
    
    let hPadding: CGFloat = 20
    let vPadding: CGFloat = 50

    var body: some View {
        if (UIDevice.current.orientation.isLandscape) {
            // side-by-side display in landscape mode
            HStack {
                civil
                Divider()
                solar
            }
            .padding(.vertical, vPadding)
            .padding(.horizontal, hPadding)
        } else {
            // stacked vertical display in portrait mode
            VStack {
                Spacer()
                civil
                Divider()
                solar
            }
            .padding(.vertical, vPadding)
            .padding(.horizontal, hPadding)
        }
    }
}

// civil time view
extension TimeView {
    private var civil: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "building.columns")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("Civil Time")
                        .font(.system(size: 30, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            HStack {
                VStack {
                    Image(systemName: "deskclock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("hh:mm")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(mc.civil_hhmm)
                        .font(.title)
                    HStack {
                        Image(systemName: "sunrise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.civil_hhmm_sunrise)
                        Text(" ")
                        Image(systemName: "sunset")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.civil_hhmm_sunset)
                    }
                }
            }
            Divider()
            HStack {
                VStack {
                    Image(systemName: "ruler")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("metric")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(mc.civil_metric)
                        .font(.title)
                        .foregroundColor(mc.civil_metric.isPrimeMetricTime && mc.mc_primetime ?
                                         .red : (colorScheme == .dark ? .white : .black))
                    HStack {
                        Image(systemName: "sunrise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.civil_metric_sunrise)
                            .foregroundColor(mc.civil_metric_sunrise.isPrimeMetricTime && mc.mc_primetime ?
                                             .red : (colorScheme == .dark ? .white : .black))
                        Text(" ")
                        Image(systemName: "sunset")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.civil_metric_sunset)
                            .foregroundColor(mc.civil_metric_sunset.isPrimeMetricTime && mc.mc_primetime ?
                                             .red : (colorScheme == .dark ? .white : .black))
                    }
                }
            }
            Divider()
            HStack {
                ProgressView(value: mc.civil_day_progress, total:100)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                Text(mc.civil_day_prog_pct)
            }

        }
    }
}

// solar time view
extension TimeView {
    private var solar: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "sun.max")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height:35)
                    Text("Solar Time")
                        .font(.system(size: 30, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            Divider()
            HStack {
                VStack {
                    Image(systemName: "deskclock")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                    Text("hh:mm")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text(mc.solar_hhmm)
                        .font(.title)
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
                        .font(.title)
                        .foregroundColor(mc.solar_metric.isPrimeMetricTime && mc.mc_primetime ?
                                         .red : (colorScheme == .dark ? .white : .black))
                    HStack {
                        Image(systemName: "sunrise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.solar_metric_sunrise)
                            .foregroundColor(mc.solar_metric_sunrise.isPrimeMetricTime && mc.mc_primetime ?
                                             .red : (colorScheme == .dark ? .white : .black))
                        Text(" ")
                        Image(systemName: "sunset")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(" ")
                        Text(mc.solar_metric_sunset)
                            .foregroundColor(mc.solar_metric_sunset.isPrimeMetricTime && mc.mc_primetime ?
                                             .red : (colorScheme == .dark ? .white : .black))
                    }
                }
            }
            Divider()
            HStack {
                ProgressView(value: mc.solar_day_progress, total:100)
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                Text(mc.solar_day_prog_pct)
            }
        }
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        TimeView()
    }
}
