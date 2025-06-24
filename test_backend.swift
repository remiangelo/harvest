#!/usr/bin/env swift

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// Simple test to verify Supabase connection
let supabaseURL = "https://ajuxvdtylcppakxipaus.supabase.co"
let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFqdXh2ZHR5bGNwcGFreGlwYXVzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ5NzU2NjIsImV4cCI6MjA1MDU1MTY2Mn0.VHcnKJtNUsyJCLKJJkEqUOhhdqrOHLfEqmkJYBGBKQs"

func testSupabaseConnection() {
    guard let url = URL(string: "\(supabaseURL)/rest/v1/") else {
        print("❌ Invalid Supabase URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.setValue("Bearer \(anonKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("1", forHTTPHeaderField: "apikey")
    
    let semaphore = DispatchSemaphore(value: 0)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        if let error = error {
            print("❌ Connection error: \(error.localizedDescription)")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("✅ Supabase connection successful!")
            print("📊 Status code: \(httpResponse.statusCode)")
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("📝 Response preview: \(String(responseString.prefix(200)))")
            }
        }
    }.resume()
    
    semaphore.wait()
}

print("🚀 Testing Harvest backend connection...")
testSupabaseConnection()
print("✨ Backend test complete!")
