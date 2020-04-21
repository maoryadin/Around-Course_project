import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController,UITextFieldDelegate {

    var db:Firestore!
    var userData:UserData!
    
    var defaults = UserDefaults.standard

    
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
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        errorView.alpha = 0
        let fieldRadius = 8
        emailView.layer.cornerRadius = CGFloat(fieldRadius)
        passwordView.layer.cornerRadius = CGFloat(fieldRadius)
        loginBtn.layer.cornerRadius = loginBtn.frame.size.height/2
        loginBtn.layer.masksToBounds = true
        
        let lightBlue = UIColor.init(hexString: "006FFB")
        let darkBlue = UIColor.init(hexString: "0053F5")
        loginBtn.setGradientLayer(colorOne: lightBlue, colorTwo: darkBlue)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent


    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         defaults = UserDefaults.standard
        let email = defaults.object(forKey: "email") as? String ?? ""
        let password = defaults.object(forKey: "password") as? String ?? ""

        print(email)
        print(password)
        if(!email.elementsEqual("") && !password.elementsEqual(""))
        {

            self.login(email: email, password: password)


        }
    }
    
    @IBAction func loginButton_Click(_ sender: Any) {

  
            self.login(email: emailTF.text!, password: passwordTF.text!)
        

    }
    
    func login(email:String,password:String) {
        DispatchQueue.main.async {

            MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        }
        
        FireBaseManager.Login(email: email, password: password) {
            (success: Bool, error: String) in
            if(success){
                print("success login")
                self.defaults.set(email,forKey: "email")
                self.defaults.set(password,forKey: "password")
                self.defaults.synchronize()
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
            DispatchQueue.main.async {

            MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
            }
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
