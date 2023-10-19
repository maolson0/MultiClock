//
//  ConverterView.swift
//  ConverterTemplate
//
//  Created by Mike Olson on 10/10/23.
//

import SwiftUI

enum AmPm {
    case am
    case pm
}

struct ConverterView: View {
    @EnvironmentObject var mc: MultiClock
    @Environment(\.colorScheme) private var colorScheme

    // selected stores which of the four time fields -- solar hhmm/metric, civil hhmm/metric -- the user selected
    @State private var selected: Selection? = nil
    
    // strings used to display times in the time display
    @State private var civil_hhmm = "hh:mm"
    @State private var civil_ampm = ""
    @State private var civil_metric = "0000"
    @State private var solar_hhmm = "hh:mm"
    @State private var solar_ampm = ""
    @State private var solar_metric = "0000"
    @State private var isAmPm: AmPm? = nil
    
    // store the digits entered by the user
    @State private var digits: [Int?] = [nil, nil, nil, nil]
    @State private var nDigits = 0
    
    // pop up alerts on bad user entries
    @State private var badHHMMTimeEntered = false
    @State private var badMetricTimeEntered = false
    @State private var needToSelectFimeField = false

    let buttonFont = Font.largeTitle
    let buttonWidth: CGFloat = 80
    let buttonHeight: CGFloat = 64
    let buttonPadding: CGFloat = 3
    let buttonForeground = Color.white
    let buttonBackground = Color.gray
    let hPadding: CGFloat = 20
    let vPadding: CGFloat = 50
    let textWid = 100.0
    let textFont = Font.title

    // This is the converter view, composed of variables defined below to cut down clutter a bit.
    var body: some View {
        if (UIDevice.current.orientation.isLandscape) {
            // side-by-side layout for landscape mode
            VStack {
                Spacer()
                header
                if (mc.mc_lhconverter) {
                    // lefties get the keypad on the left
                    HStack {
                        HStack {
                            digitPad        // The 0-9 pad with the "del" key
                            if (mc.mc_12hour) {
                                ampmPad         // the am/pm buttons
                            }
                            Divider()
                            Divider()
                            VStack {
                                timeConvertDisplay  // Four time fields and the convert button
                                labelRow            // Row that labels civil and solar time and has "convert" button
                                Spacer()
                            }
                        }
                    }
                } else {
                    // righties get the keypad on the right
                    HStack {
                        VStack {
                            timeConvertDisplay  // Four time fields and the convert button
                            labelRow            // Row that labels civil and solar time and has "convert" button
                            Spacer()
                        }
                        Divider()
                        Divider()
                        HStack {
                            digitPad        // The 0-9 pad with the "del" key
                            if (mc.mc_12hour) {
                                ampmPad         // the am/pm buttons
                            }
                        }
                    }
               }
            }
                .padding(.vertical, vPadding)
                .padding(.horizontal, hPadding)
                .alert("Invalid time", isPresented: $badHHMMTimeEntered) { } message: {
                    if (mc.mc_12hour) {
                        Text("Please enter a time between 12:00 am and 11:59 pm.")
                    } else {
                        Text("Please enter a time between 00:00 and 23:59.")
                    }
                }
                .alert("Invalid time", isPresented: $badMetricTimeEntered) { } message: {
                    Text("Please enter at least one digit for metric time")
                }
                .alert("Choose time", isPresented: $needToSelectFimeField) { } message: {
                    Text("Tap one of the four time fields to enter a time.")
                }
        } else {
            // vertically-stacked layout for portrait mode
            VStack {
                Spacer()
                header
                timeConvertDisplay  // Four time fields and the convert button
                labelRow            // Row that labels civil and solar time and has "convert" button
                HStack {
                    digitPad        // The 0-9 pad with the "del" key
                    if (mc.mc_12hour) {
                        ampmPad         // the am/pm buttons
                    }
                }
            }
                .padding(.vertical, vPadding)
                .padding(.horizontal, hPadding)
                .alert("Invalid time", isPresented: $badHHMMTimeEntered) { } message: {
                    if (mc.mc_12hour) {
                        Text("Please enter a time between 12:00 am and 11:59 pm.")
                    } else {
                        Text("Please enter a time between 00:00 and 23:59.")
                    }
                }
                .alert("Invalid time", isPresented: $badMetricTimeEntered) { } message: {
                    Text("Please enter at least one digit for metric time")
                }
                .alert("Choose time", isPresented: $needToSelectFimeField) { } message: {
                    Text("Tap one of the four time fields to enter a time.")
                }
        }
    }
}

#Preview {
    ConverterView()
}

// These extensions declare a bunch of variables that provide the various view components for the
// converter display. This stuff is long and repetitive so I wanted to factor it out of the main
// view code.

// The digit pad
extension ConverterView {
    private var digitPad: some View {
        VStack {
            // 789 row
            HStack {
                Button() {
                    pressDigit(d: 7)
                } label: {
                    Text("7")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDigit(d: 8)
                } label: {
                    Text("8")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDigit(d: 9)
                } label: {
                    Text("9")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
            }
            // 456 row
            HStack {
                Button() {
                    pressDigit(d: 4)
                } label: {
                    Text("4")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDigit(d: 5)
                } label: {
                    Text("5")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDigit(d: 6)
                } label: {
                    Text("6")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
            }
            // 123 row
            HStack {
                Button() {
                    pressDigit(d: 1)
                } label: {
                    Text("1")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDigit(d: 2)
                } label: {
                    Text("2")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDigit(d: 3)
                } label: {
                    Text("3")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
            }
            // 0 del row
            HStack {
                Button() {
                    pressDigit(d: 0)
                } label: {
                    Text("0")
                        .font(buttonFont)
                        .frame(maxWidth: (buttonWidth * 2) + (buttonPadding * 2), maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
                Button() {
                    pressDelete()
                } label: {
                    Text("del")
                        .font(buttonFont)
                        .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                        .background(buttonBackground)
                        .foregroundColor(buttonForeground)
                        .clipShape(.capsule)
                        .padding(buttonPadding)
                }
            }
        }
    }

    private func pressDigit(d: Int) {
        // Don't take keypad input unless a time field is selected
        if (selected == nil) {
            needToSelectFimeField = true
            return
        }
        
        // Only four digits of display in all the time entry fields
        if (nDigits >= 4) {
            return
        }
        
        // add the digit
        digits[nDigits] = d
        nDigits += 1
        
        switch selected {
        case .civil_hhmm:
            civil_hhmm = timeString(dArray: digits, nd: nDigits, which: .civil_hhmm)
        case .civil_metric:
            civil_metric = timeString(dArray: digits, nd: nDigits, which: .civil_metric)
        case .solar_hhmm:
            solar_hhmm = timeString(dArray: digits, nd: nDigits, which: .solar_hhmm)
        case .solar_metric:
            solar_metric = timeString(dArray: digits, nd: nDigits, which: .solar_metric)
        case .none:
            return
        }
    }
    
    // Take an array of four digits and create a string representing that time for the converter display.
    // We put a colon in the right place for hh:mm times.
    private func timeString(dArray: [Int?], nd: Int, which: Selection) -> String {
        var newStr = ""
        
        
        for i in 0...3 {
            if let d = dArray[i] {
                newStr = newStr + String(d)
            } else if (which == .solar_hhmm || which == .civil_hhmm) {
                // add blanks for missing digits so colon is correctly positioned
                newStr = " " + newStr
            } else {
                // This is a metric time and we're out of digits, no need to continue iterating through the array
                // Need at least one char in the string so the display is right
                if (newStr == "") {
                    newStr = " "
                }
                return (newStr)
            }
        }
        
        if (which == .civil_hhmm || which == .solar_hhmm) {
            newStr = newStr.prefix(2) + ":" + newStr.suffix(2)
        }
        return (newStr)
    }
    
    private func pressDelete()
    {
        if (selected == nil || nDigits == 0) {
            return
        }
        
        nDigits -= 1
        digits[nDigits] = nil

        switch selected {
        case .civil_hhmm:
            civil_hhmm = timeString(dArray: digits, nd: nDigits, which: selected!)
        case .civil_metric:
            civil_metric = timeString(dArray: digits, nd: nDigits, which: selected!)
        case .solar_hhmm:
            solar_hhmm = timeString(dArray: digits, nd: nDigits, which: selected!)
        case .solar_metric:
            solar_metric = timeString(dArray: digits, nd: nDigits, which: selected!)
        case .none:
            return
        }
    }
}

// The AM/PM pad
extension ConverterView {
    private var ampmPad: some View {
        VStack
        {
            Button() {
                setAM()
            } label: {
                Text("am")
                    .font(buttonFont)
                    .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                    .background(buttonBackground)
                    .foregroundColor(buttonForeground)
                    .clipShape(.capsule)
                    .padding(buttonPadding)
            }
            Button() {
                setPM()
            } label: {
                Text("pm")
                    .font(buttonFont)
                    .frame(maxWidth: buttonWidth, maxHeight: buttonHeight)
                    .background(buttonBackground)
                    .foregroundColor(buttonForeground)
                    .clipShape(.capsule)
                    .padding(buttonPadding)
            }
        }
    }
    private func setAM()
    {
        if (selected == nil) {
            return
        }
        if (selected == .solar_metric || selected == .civil_metric) {
            // no am/pm in metric times
            return
        }
        if (mc.mc_12hour) {
            if (selected == .civil_hhmm) {
                civil_ampm = "am"
            } else {
                solar_ampm = "am"
            }
            isAmPm = .am
        } else {
            civil_ampm = ""
            solar_ampm = ""
            isAmPm = nil
        }
    }
    private func setPM()
    {
        if (selected == nil) {
            return
        }
        if (selected == .solar_metric || selected == .civil_metric) {
            // no am/pm in metric times
            return
        }
        if (selected == .civil_hhmm) {
            civil_ampm = "pm"
        } else {
            solar_ampm = "pm"
        }
        isAmPm = .pm
    }

}

// The label row, including the "convert" button
extension ConverterView {
    private var labelRow: some View {
        HStack {
            VStack {
                HStack {
                    VStack {
                        Image(systemName: "building.columns")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                        Text("civil time")
                            .font(.title)
                    }
                    Spacer()
                    Button {
                        doConvert()
                    } label: {
                        VStack {
                            Image(systemName: "arrow.left.arrow.right.square")
                                .resizable()
                                .frame(width:40, height: 40)
                                .aspectRatio(contentMode: .fit)
                            Text("convert")
                        }
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "sun.max")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                        Text("solar time")
                            .font(.title)
                    }
                }
            }
        }
    }
    
    private func validateHHMMTime(t: Int) -> Bool {
        let hh = t / 100
        let mm = t % 100
        
        if (mc.mc_12hour) {
            if (hh > 12 || hh == 0 || mm > 59) {
                return false
            }
        } else {
            if (hh > 23 || mm > 59) {
                return false
            }
        }
        return true
    }
    
    private func doConvert()
    {
        var enteredNumber = 0
        
        if (selected == nil) {
            needToSelectFimeField = true
            return
        }
        
        for i in 0...3 {
            if let d = digits[i] {
                enteredNumber = (enteredNumber * 10) + d
            }
        }
        if (selected == .civil_hhmm || selected == .solar_hhmm) {
            if (nDigits < 3 || !validateHHMMTime(t: enteredNumber)) {
                badHHMMTimeEntered = true
                return
            }
        }
        
        if ((selected == .civil_metric || selected == .solar_metric) && nDigits == 0) {
            badMetricTimeEntered = true
            return
        }
        
        // If we're using a 12-hour clock, adjust hours to 24-hour clock based on am/pm input
        if (mc.mc_12hour) {
            if (selected == .civil_hhmm || selected == .solar_hhmm) {
                if (isAmPm == .pm) {
                    if (enteredNumber < 1200) {
                        enteredNumber += 1200
                    }
                } else {
                    if (enteredNumber >= 1200) {
                        enteredNumber -= 1200
                    }
                }
            }
        }
        
        let tc = mc.convertTime(t: enteredNumber, which: selected!)
        
        civil_hhmm = tc.tc_civil_hhmm
        civil_metric = tc.tc_civil_metric
        solar_hhmm = tc.tc_solar_hhmm
        solar_metric = tc.tc_solar_metric
        
        civil_ampm = ""
        solar_ampm = ""
        
        selected = nil
    }
    
    private func numberToTimeString(n: Int, which: Selection) -> String
    {
        var digArray: [Int?] = [nil, nil, nil, nil]
        var xposedDigArray: [Int?] = [nil, nil, nil, nil]
        var nd = 0;
        
        var curNum = n
        
        // pull out digits from thousands place down to ones place
        repeat {
            digArray[nd] = curNum % 10
            curNum /= 10
            nd += 1
        } while curNum > 0
        
        for i in 0...3 {
            let j = 3 - i
            xposedDigArray[j] = digArray[i]
        }

        return timeString(dArray: xposedDigArray, nd: nd, which: which)
    }
}

// The time conversion display. Shows four text fields: civil hhmm, civil metric, solar hhmm, solar metric.
// They're selectable and the user can pick the one to enter. Updates to the entered number are captured
// in that field for display, and the selected field is used at conversion time to decide what we have and
// what we need to compute.

extension ConverterView {
    // User enters one of civil hh:mm, civil metric, solar hh:mm or solar metric.
    // When the "convert button is pressed, we convert that time to all the others.
    private var timeConvertDisplay: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        HStack {
                            Text(civil_hhmm)
                                .font(textFont)
                            Text(civil_ampm)
                                .font(textFont)
                        }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(2)
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke((selected == .civil_hhmm ? .blue : .gray), lineWidth: 2))
                            .onTapGesture{ gotSelection(s: .civil_hhmm)}
                        Text(" ")
                        Image(systemName: "deskclock")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .aspectRatio(contentMode: .fit)
                        Text(" ")
                        HStack {
                            Text(solar_hhmm)
                                .font(textFont)
                            Text(solar_ampm)
                                .font(textFont)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(2)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke((selected == .solar_hhmm ? .blue : .gray), lineWidth: 2))
                        .onTapGesture{ gotSelection(s: .solar_hhmm)}
                    }
                    HStack {
                        Text(civil_metric)
                            .font(textFont)
                            .foregroundColor(civil_metric.isPrimeMetricTime && mc.mc_primetime ?
                                             .red : (colorScheme == .dark ? .white : .black))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(2)
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke((selected == .civil_metric ? .blue : .gray), lineWidth: 2))
                            .onTapGesture{ gotSelection(s: .civil_metric)}
                        Text(" ")
                        Image(systemName: "ruler")
                            .resizable()
                            .frame(width: 30, height: 15)
                            .aspectRatio(contentMode: .fit)
                        Text(" ")
                        Text(solar_metric)
                            .font(textFont)
                            .foregroundColor(solar_metric.isPrimeMetricTime && mc.mc_primetime ?
                                             .red : (colorScheme == .dark ? .white : .black))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(2)
                            .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke((selected == .solar_metric ? .blue : .gray), lineWidth: 2))
                            .onTapGesture{ gotSelection(s: .solar_metric)}
                    }
                }
            }
        }
    }
    private func gotSelection(s: Selection) {
        resetForm()
        selected = s
        
        switch s {
        case .civil_hhmm:
            civil_hhmm = "  :  "
            if (mc.mc_12hour) {
                civil_ampm = "am"
                isAmPm = .am
            } else {
                civil_ampm = ""
                isAmPm = nil
            }
        case .civil_metric:
            civil_metric = " "
        case .solar_hhmm:
            solar_hhmm = "  :  "
            if (mc.mc_12hour) {
                solar_ampm = "am"
                isAmPm = .am
            } else {
                solar_ampm = ""
                isAmPm = nil
            }
        case .solar_metric:
            solar_metric = "    "
        }
    }
    
    private func resetForm() {
        selected = nil
        civil_hhmm = " "
        civil_metric = " "
        solar_hhmm = " "
        solar_metric = " "
        civil_ampm = ""
        solar_ampm = ""
        for i in 0...3 {
            digits[i] = nil
        }
        nDigits = 0
    }
}

extension ConverterView {
    private var header: some View {
        HStack {
            Image(systemName: "arrow.left.arrow.right.square")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height:40)
            Text("Convert")
                .font(.system(size: 30, weight: .bold))
        }
    }
}
