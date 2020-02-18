import UIKit
import Firebase
import GoogleSignIn

class MapViewController: UIViewController {

    
    @IBAction func signoutButton(_ sender: Any) {
        if (Auth.auth().currentUser != nil) {
             do {
                 try
                 Auth.auth().signOut()
                 self.performSegue(withIdentifier: "toSigninSegue", sender: self)
             } catch {
                 print("signout error")
             }
         }
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
