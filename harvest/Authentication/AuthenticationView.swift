import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authService = AuthenticationService()
    @State private var isSignUp = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingOnboarding = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)]),
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Logo/Title
                    VStack(spacing: 16) {
                        Text("Harvest")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        
                        Text(isSignUp ? "Create your account" : "Welcome back")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    // Form
                    VStack(spacing: 20) {
                        // Email field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Confirm password (sign up only)
                        if isSignUp {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        
                        // Error message
                        if let errorMessage = authService.errorMessage {
                            Text(errorMessage)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Action button
                        Button(action: {
                            Task {
                                if isSignUp {
                                    if password == confirmPassword {
                                        showingOnboarding = true
                                    }
                                } else {
                                    await authService.signIn(email: email, password: password)
                                }
                            }
                        }) {
                            if authService.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(isSignUp ? "Continue to Profile Setup" : "Sign In")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 128/255, green: 23/255, blue: 36/255))
                        .cornerRadius(32)
                        .disabled(authService.isLoading || email.isEmpty || password.isEmpty || (isSignUp && confirmPassword.isEmpty))
                        
                        // Toggle between sign in/sign up
                        Button(action: {
                            isSignUp.toggle()
                            authService.errorMessage = nil
                        }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color(red: 128/255, green: 23/255, blue: 36/255))
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingWithAuthView(
                email: email,
                password: password,
                authService: authService
            )
        }
    }
}

struct OnboardingWithAuthView: View {
    let email: String
    let password: String
    let authService: AuthenticationService
    
    @StateObject private var onboardingData = OnboardingData()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        OnboardingFlowView(onboardingData: onboardingData) {
            // Complete onboarding and create account
            Task {
                await authService.signUpWithOnboardingData(onboardingData, email: email, password: password)
                if authService.isAuthenticated {
                    dismiss()
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
