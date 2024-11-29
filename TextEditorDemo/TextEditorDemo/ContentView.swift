//
//  ContentView.swift
//  TextEditorDemo
//
//  Created by PC on 11/10/24.
//

import SwiftUI

struct ContentView: View {
    
    @FocusState private var isStrokeFocused: Bool
    @State private var strokeColor: Color = .black
    @State private var shadowColor: Color = .black
    
    @State private var backgroundColor: Color = .black
    @State private var foregroundColor: Color = .black
    
    @State private var underlineColor: Color = .black
    @State private var strikethroughColor: Color = .black
    
    @State private var urlString: String = ""
    @State private var showingAlert: Bool = false
    
    @FocusState private var isShadowRadiusFocused: Bool
    @FocusState private var isShadowXFocused: Bool
    @FocusState private var isShadowYFocused: Bool
    @FocusState private var isKernFocused: Bool
    @FocusState private var isLineFocused: Bool
    
    @StateObject var textContext = TextContext()
    @State private var text = NSAttributedString(string: "Hello! How are you?",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 18.0)])
    
    private var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    
                    TextAligemnetView(image: "align-left") {
                        self.textContext.alignment = .left
                    }
                    
                    TextAligemnetView(image: "format") {
                        self.textContext.alignment = .center
                    }
                    
                    TextAligemnetView(image: "align-right") {
                        self.textContext.alignment = .right
                    }
                    
                    TextAligemnetView(image: "link") {
                        self.urlString = ""
                        self.showingAlert = true
                    }
                    
                    Spacer()
                    
                    Button {
                        self.textContext.shouldUndo = true
                    } label: {
                        Image(systemName: "arrow.uturn.backward")
                            .frame(width: 40.0, height: 40.0)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(4.0)
                    }
                    
                    Button {
                        self.textContext.shouldUndo = false
                    } label: {
                        Image(systemName: "arrow.uturn.forward")
                            .frame(width: 40.0, height: 40.0)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(4.0)
                    }
                    
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                
                TextCanvas(text: $text, textContext: self.textContext)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                
                HStack {
                    Button {
                        self.textContext.isItalic.toggle()
                    } label: {
                        Image(systemName: "italic")
                            .frame(width: 40.0, height: 40.0)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(4.0)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(self.textContext.isItalic ? .blue : .black)
                    
                    Button {
                        self.textContext.isBold.toggle()
                    } label: {
                        Image(systemName: "bold")
                            .frame(width: 40.0, height: 40.0)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(4.0)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(self.textContext.isBold ? .blue : .black)
                    
                    Button {
                        if let data = try? NSKeyedArchiver.archivedData(withRootObject: self.text, requiringSecureCoding: false) {
                            print(data)
                            let string = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)
                            print(string!)
                        }
                    } label: {
                        Text("Save")
                            .frame(height: 40.0)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.4))
                            .cornerRadius(4.0)
                    }
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                
                VStack(spacing: 10) {
                    
                    HStack(spacing: 60) {
                        ColorPicker(selection: self.$foregroundColor, label: {
                            Button {
                                self.textContext.foregroundColor = UIColor(self.foregroundColor)
                            } label: {
                                VStack(spacing: 2) {
                                    Text("A")
                                        .foregroundStyle(.black)
                                    Rectangle()
                                        .fill(self.foregroundColor)
                                        .frame(width: 30, height: 6)
                                }
                                .frame(width: 40.0, height: 40.0)
                                .background(.gray.opacity(0.4))
                                .cornerRadius(4.0)
                            }
                        })
                        
                        ColorPicker(selection: self.$backgroundColor, label: {
                            Button {
                                self.textContext.backgroundColor = UIColor(self.backgroundColor)
                            } label: {
                                VStack(spacing: 2) {
                                    Image("marker")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Rectangle()
                                        .fill(self.backgroundColor)
                                        .frame(width: 30, height: 6)
                                    
                                }
                                .frame(width: 40.0, height: 40.0)
                                .foregroundStyle(.black)
                                .background(.gray.opacity(0.4))
                                .cornerRadius(4.0)
                            }
                        })
                    }
                    
                    HStack(spacing: 60) {
                        ColorPicker(selection: self.$underlineColor, label: {
                            Button {
                                self.textContext.underlinedColor = UIColor(self.underlineColor)
                                self.textContext.isUnderlined.toggle()
                            } label: {
                                VStack(spacing: 2) {
                                    Image(systemName: "underline")
                                        .frame(width: 25, height: 25)
                                    
                                    Rectangle()
                                        .fill(self.underlineColor)
                                        .frame(width: 30, height: 6)
                                }
                                .frame(width: 40.0, height: 40.0)
                                .background(.gray.opacity(0.4))
                                .cornerRadius(4.0)
                            }
                            .foregroundColor(self.textContext.isUnderlined ? .blue : .black)
                        })
                        
                        ColorPicker(selection: self.$strikethroughColor, label: {
                            Button {
                                self.textContext.strikethroughColor = UIColor(self.strikethroughColor)
                                self.textContext.isStrikethrough.toggle()
                            } label: {
                                VStack(spacing: 2) {
                                    Image(systemName: "strikethrough")
                                        .frame(width: 25, height: 25)
                                    Rectangle()
                                        .fill(self.strikethroughColor)
                                        .frame(width: 30, height: 6)
                                }
                                .frame(width: 40.0, height: 40.0)
                                .background(.gray.opacity(0.4))
                                .cornerRadius(4.0)
                            }
                            .foregroundColor(self.textContext.isStrikethrough ? .blue : .black)
                        })
                    }
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                
                VStack(spacing: 10) {
                    HStack(spacing: 60) {
                        Text("Stroke")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ColorPicker(selection: self.$strokeColor, label: {
                            Button {
                                self.textContext.strokeColor = UIColor(self.strokeColor)
                            } label: {
                                VStack(spacing: 2) {
                                    Text("C")
                                        .foregroundStyle(.black)
                                    Rectangle()
                                        .fill(self.strokeColor)
                                        .frame(width: 30, height: 6)
                                }
                                .frame(width: 40.0, height: 40.0)
                                .background(.gray.opacity(0.4))
                                .cornerRadius(4.0)
                            }
                        })
                    }
                    HStack {
                        Text("W")
                        Slider(value: self.$textContext.strokeWidth.value, in: -5.0...5.0, step: 0.01) { editing in
                            self.textContext.strokeWidth.isEditing = editing
                        }
                        TextField("Width", value: self.$textContext.strokeWidth.value, formatter: self.decimalFormatter)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 15, maxWidth: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused(self.$isStrokeFocused)
                            .onChange(of: self.isStrokeFocused) { oldValue, newValue in
                                self.textContext.strokeWidth.isTextEditing = newValue
                            }
                        Stepper("Value", value: self.$textContext.strokeWidth.value, step: 0.01)
                        .labelsHidden()
                    }
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                
                VStack(spacing: 5) {
                    HStack(spacing: 60) {
                        Text("Shadow")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ColorPicker(selection: self.$shadowColor, label: {
                            Button {
                                let shadow = self.textContext.myshadow.shadow
                                shadow.shadowColor = UIColor(self.shadowColor)
                                self.textContext.myshadow.shadow = shadow
                            } label: {
                                VStack(spacing: 2) {
                                    Text("C")
                                        .foregroundStyle(.black)
                                    Rectangle()
                                        .fill(self.shadowColor)
                                        .frame(width: 30, height: 6)
                                }
                                .frame(width: 40.0, height: 40.0)
                                .background(.gray.opacity(0.4))
                                .cornerRadius(4.0)
                            }
                        })
                    }
                    
                    HStack {
                        Text("R")
                        Slider(value: self.$textContext.myshadow.shadow.shadowBlurRadius, in: 0...10.0) { editing in
                            self.textContext.myshadow.isEditing = editing
                        }
                        TextField("Radius", value: self.$textContext.myshadow.shadow.shadowBlurRadius, formatter: self.decimalFormatter)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 15, maxWidth: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused(self.$isShadowRadiusFocused)
                            .onChange(of: self.isShadowRadiusFocused) { oldValue, newValue in
                                self.textContext.myshadow.isTextEditing = newValue
                            }
                        Stepper("Value", value: self.$textContext.myshadow.shadow.shadowBlurRadius, step: 0.01)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("X")
                        Slider(value: self.$textContext.myshadow.shadow.shadowOffset.width, in: -10.0...10.0) { editing in
                            self.textContext.myshadow.isEditing = editing
                        }
                        TextField("xOffset", value: self.$textContext.myshadow.shadow.shadowOffset.width, formatter: self.decimalFormatter)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 15, maxWidth: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused(self.$isShadowXFocused)
                            .onChange(of: self.isShadowXFocused) { oldValue, newValue in
                                self.textContext.myshadow.isTextEditing = newValue
                            }
                        Stepper("Value", value: self.$textContext.myshadow.shadow.shadowOffset.width, step: 0.01)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("Y")
                        Slider(value: self.$textContext.myshadow.shadow.shadowOffset.height, in: -10.0...10.0) { editing in
                            self.textContext.myshadow.isEditing = editing
                        }
                        TextField("yOffset", value: self.$textContext.myshadow.shadow.shadowOffset.height, formatter: self.decimalFormatter)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 15, maxWidth: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused(self.$isShadowYFocused)
                            .onChange(of: self.isShadowYFocused) { oldValue, newValue in
                                self.textContext.myshadow.isTextEditing = newValue
                            }
                        Stepper("Value", value: self.$textContext.myshadow.shadow.shadowOffset.height, step: 0.01)
                            .labelsHidden()
                    }
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Kern")
                        Slider(value: self.$textContext.kern.value, in: 0...10) { editing in
                            self.textContext.kern.isEditing = editing
                        }
                        TextField("Kern", value: self.$textContext.kern.value, formatter: self.decimalFormatter)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 15, maxWidth: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused(self.$isKernFocused)
                            .onChange(of: self.isKernFocused) { oldValue, newValue in
                                self.textContext.kern.isTextEditing = newValue
                            }
                        Stepper("Value", value: self.$textContext.kern.value, step: 0.01)
                            .labelsHidden()
                    }
                    
                    HStack {
                        Text("Line")
                        Slider(value: self.$textContext.lineSpacing.value, in: 0...10) { editing in
                            self.textContext.lineSpacing.isEditing = editing
                        }
                        TextField("Line", value: self.$textContext.lineSpacing.value, formatter: self.decimalFormatter)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                            .frame(minWidth: 15, maxWidth: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused(self.$isLineFocused)
                            .onChange(of: self.isLineFocused) { oldValue, newValue in
                                self.textContext.lineSpacing.isTextEditing = newValue
                            }
                        Stepper("Value", value: self.$textContext.lineSpacing.value, step: 0.01)
                            .labelsHidden()
                    }
                }
                .padding(10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
            }
            .alert("Text Editor", isPresented: $showingAlert) {
                TextField(text: $urlString) {
                    Text("Paste a link here")
                }
                Button("Cancel", role: .cancel) { }
                Button("OK", role: .none) { 
                    guard let url = URL(string: self.urlString) else { return }
                    self.textContext.link = url
                }
            }
            .padding(.horizontal, 16.0)
        }
        .background {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func TextAligemnetView(image: String, callback: @escaping (() -> Void)) -> some View {
            Button {
                callback()
            } label: {
                Image(image)
                    .resizable()
                    .padding(8)
                    .frame(width: 40.0, height: 40.0)
                    .background(.gray.opacity(0.4))
                    .cornerRadius(4.0)
            }
            .buttonStyle(.plain)
    }
    
}

#Preview {
    ContentView()
}

extension View {
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
