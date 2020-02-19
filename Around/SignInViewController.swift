import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        


    }
    
    
    @IBAction func loginButton_Click(_ sender: Any) {
        

        FireBaseManager.Login(email: emailTF.text!, password: passwordTF.text!) { (success:Bool) in
            
            if(success){
                print(success)
            self.performSegue(withIdentifier: "showProfileLogIn", sender: sender)
            }
            
            self.shouldPerformSegue(withIdentifier: "showProfileLogIn", sender: sender)

        }
    }
    
    
    @IBAction func createAccountButton_Click(_ sender: Any) {
        
        print("!!!!!")
        performSegue(withIdentifier: "registerSegue", sender: self)
//
//        FireBaseManager.CreateAccount(email: emailTF.text!, password: passwordTF.text!) {
//            (result:String) in
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "showProfile", sender: sender)
//            }
//        }
        
    }

    

    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {

        if(withIdentifier == "showProfileLogIn") {
            return false
        }

        return true;
    }


}
