import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import Pastel
import IBAnimatable
class SignInViewController: UIViewController {

    var db:Firestore!
    var userData:UserData!
    
    // fields views & btn
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    // fields
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.alpha = 0
        
        let fieldRadius = 8
        let buttonRadius = 4
        emailView.layer.cornerRadius = CGFloat(fieldRadius)
        passwordView.layer.cornerRadius = CGFloat(fieldRadius)
        loginBtn.layer.cornerRadius = CGFloat(buttonRadius)
        errorView.layer.cornerRadius = CGFloat(buttonRadius)
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func loginButton_Click(_ sender: Any) {
        FireBaseManager.Login(email: emailTF.text!, password: passwordTF.text!) { (success: Bool, error: String) in
            if(success){
                print("success login")
                self.performSegue(withIdentifier: "showProfileLogIn", sender: self)
            } else {
                self.errorView.alpha = 1
                self.errorMessage.text = error
            }
        }
    }
    
    @IBAction func createAccountButton_Click(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.errorView.alpha = 0
        print("before perpare")
        if segue.identifier  == "showProfileLogIn" {
            
            print("we in segue destination to profile!")
        }
        print("after perpare")
        }

    override func shouldPerformSegue(withIdentifier: String, sender: Any?) -> Bool {
        print("going to cancel")
        if(withIdentifier == "showProfileLogIn") {
            return false
        }
        return true;
    }
    
}
