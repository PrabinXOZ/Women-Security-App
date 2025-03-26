import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import Login Screen for navigation back

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade300,
              Colors.pink.shade100,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.pink.shade300),
                ),
                SizedBox(height: 10),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Join us and stay secure!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),

                // 🟢 REGISTER FORM
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      buildTextField(Icons.person, "Full Name"),
                      SizedBox(height: 15),
                      buildTextField(Icons.email, "Email/Phone No"),
                      SizedBox(height: 15),
                      buildPasswordField("Password", _obscureText, () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                      SizedBox(height: 15),
                      buildPasswordField("Confirm Password", _obscureConfirmText, () {
                        setState(() {
                          _obscureConfirmText = !_obscureConfirmText;
                        });
                      }),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade200,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // Proceed to Login screen after registration
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Get OTP',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          "Already have an account? Sign in",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.pink.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),

                // 🟢 IMPROVED BACK BUTTON AT BOTTOM
                SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.black26,
                    elevation: 5,
                  ),
                  icon: Icon(Icons.arrow_back),
                  label: Text(
                    "Back to Welcome",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);  // Go back to Welcome Screen
                  },
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.pink.shade50,
      ),
    );
  }

  Widget buildPasswordField(String hintText, bool obscureText, VoidCallback toggleVisibility) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Colors.pink.shade300),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.pink.shade300),
          onPressed: toggleVisibility,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.pink.shade50,
      ),
    );
  }
}
