import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase


class SignInViewController: UIViewController {

    
    var db:Firestore!
    var userData:UserData!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let settings = FirestoreSettings()

        Firestore.firestore().settings = settings
          // [END setup]
        db = Firestore.firestore()
        
        
    }
    
    
    @IBAction func loginButton_Click(_ sender: Any) {
        
        FireBaseManager.Login(email: emailTF.text!, password: passwordTF.text!) { (success:Bool) in
            
            if(success){
                print("success login")
                self.setData()

            } else {
                self.shouldPerformSegue(withIdentifier: "showProfileLogIn", sender: self)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print("before perpare")
        if segue.identifier  == "showProfileLogIn" {
            
            print("we in segue destination to profile!")
            
        }
        print("after perpare")

        }
    
    func setData() {
        print("befor set data")
        let uid = Auth.auth().currentUser?.uid
         print(uid!)
        let docRef = self.db.collection("Users").document(uid!)
                 docRef.getDocument { (document, error) in
                     if let document = document, document.exists {
                         let dataDescription = document.data()!


                       
                        self.performSegue(withIdentifier: "showProfileLogIn", sender: self)
            }
         
        }
        
        print("after set data")
}
//

        

    
    @IBAction func createAccountButton_Click(_ sender: Any) {
        
 //       print("!!!!!")
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
        
        print("going to cancel")

        if(withIdentifier == "showProfileLogIn") {
            return false
        }

        return true;
    }


}
