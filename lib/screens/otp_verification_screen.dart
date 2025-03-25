import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  int _timer = 30;
  bool _isResendActive = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _otpControllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _otpControllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
        _startTimer();
      } else {
        setState(() {
          _isResendActive = true;
        });
      }
    });
  }

  void _handleOtpInput(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade300,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  
                  // OTP Content
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade300,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Enter the 4-digit code sent to your email",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 25),

                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(_focusNodes[index]);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade800,
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  onChanged: (value) => _handleOtpInput(value, index),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 20),

                        // Resend Code
                        TextButton(
                          onPressed: _isResendActive
                              ? () {
                                  setState(() {
                                    _timer = 30;
                                    _isResendActive = false;
                                  });
                                  _startTimer();
                                }
                              : null,
                          child: Text(
                            "Didn't receive code? Resend",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.pink.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _isResendActive ? "" : "00:${_timer.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        SizedBox(height: 15),

                        // Verify Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade300,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            String otp = _otpControllers.map((c) => c.text).join();
                            if (otp.length == 4) {
                              print("OTP Verified: $otp");
                            }
                          },
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // 🟢 Stylish Back Button (matching login screen)
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
                      "Back to Login",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// THis is temporary to check if the code runs or not  use this in terminal  
//"flutter run -t lib/screens/otp_verification_screen.dart"
void main() => runApp(MaterialApp(home: OtpVerificationScreen()));