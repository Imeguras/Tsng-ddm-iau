import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        passwordTextField.isSecureTextEntry = true
        
        // Check if the user is already logged in
        if let accessToken = AuthManager.shared.accessToken {
            // User is logged in
            print("User is logged in with token: \(accessToken)")
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabController = storyboard.instantiateViewController(identifier: "FirstViewController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(vc: tabController)
            }
            
        } else {
            // User is not logged in
            print("User is not logged in")
        }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        // token
        let params = ["email": emailTextField.text, "password": passwordTextField.text]
        
        var request = URLRequest(url: URL(string: "https://willowish-utapi-api.azurewebsites.net/api/v1/User/Login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Print the HTTP response status code for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                
                if (200...299).contains(httpResponse.statusCode) {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabController = storyboard.instantiateViewController(identifier: "FirstViewController")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(vc: tabController)
                    }
                }
                else {
                    self.showAlert(title: "Authentication Error", message: "Invalid email or password.")
                    
                    // Update UI or perform any other actions as needed
                    DispatchQueue.main.async {
                        self.passwordTextField.text = ""
                    }
                }
            }
            
            // Check for a successful response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // Print the response data for debugging
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response Data: \(responseString ?? "N/A")")
                }
                
                print("Invalid response")
                return
                
            }
            
            // Check if data is available
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Parse JSON response
                let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                //Save the access token using AuthManager
                AuthManager.shared.saveAccessToken(fromJson: json)
                
                // Assuming your access token is stored in the 'access_token' key
                if let accessToken = json["access_token"] as? String {
                    // Persist the access token (for example, using UserDefaults)
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    print("Access Token: \(accessToken)")
                    
                    // Now you can proceed to handle the successful login
                    
                } else {
                    print("Access token not found in the response")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        })
        
        task.resume()
        // token
        
    }
    
    // Function to show an alert
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
