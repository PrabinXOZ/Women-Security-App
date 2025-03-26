import 'package:flutter/material.dart';
import 'otp_success_screen.dart'; // Make sure this import exists

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
    Future.delayed(const Duration(seconds: 1), () {
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  
                  // OTP Content
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
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
                        const SizedBox(height: 8),
                        const Text(
                          "Enter the 4-digit code sent to your email",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 25),

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
                                margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

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
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 15),

                        // Verify Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink.shade300,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 3,
                          ),
                          onPressed: () {
                            String otp = _otpControllers.map((c) => c.text).join();
                            if (otp.length == 4) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => OtpSuccessScreen()),
                              );
                            }
                          },
                          child: const Text(
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
                  const SizedBox(height: 30),

                  // Back Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pink.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      shadowColor: Colors.black26,
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// TEMPORARY TEST CODE - REMOVE AFTER TESTING
// void main() => runApp(MaterialApp(home: OtpVerificationScreen()));

//flutter run -t lib/screens/otp_verification_screen.dart