import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/views/home/home_page.dart';
import 'package:icahs_hwr/widgets/my_button.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  final AuthController _authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    isLoading.value = true;
    var result = await _authController.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    if (result['status']) {
      if (!mounted) return;
      isLoading.value = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
      showSnackBar('Success', result['message'], color: MyColorPalette.success);
    } else {
      isLoading.value = false;
      showSnackBar('Error', result['message'], color: MyColorPalette.error);
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: [
                MyColorPalette.darkPurple,
                Color.fromARGB(221, 46, 24, 177),
                MyColorPalette.darkPurple,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Changed from .center
              children: [
                SizedBox(height: kToolbarHeight),
                Image.asset('assets/icons/heart.png'),
                const SizedBox(height: 20),
                Text(
                  'HWR',
                  textScaler: TextScaler.linear(1),
                  style: TextStyle(
                    fontSize: 65,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 0.75,
                  ),
                ),
                Text(
                  'SUPERVISOR',
                  textScaler: TextScaler.linear(1),
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Hospital Ward Rotation',
                  textScaler: TextScaler.linear(1),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset('assets/icons/building.png', width: 280),
                Container(
                  width: double.infinity,
                  // Remove fixed height constraint
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Please Login to continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: MyColorPalette.textGrey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildForm(),
                      SizedBox(height: 20), // Add bottom padding
                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(color: MyColorPalette.textGrey),
                        ),
                      ),
                      SizedBox(height: 10), // Extra bottom space
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Username',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 2.5,
            ),
          ),
          MyTextField(
            controller: _usernameController,
            hint: "Enter Username",
            icon: Icon(Icons.person_rounded, color: MyColorPalette.textGrey),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return "Username is missing!";
              } else {
                return null;
              }
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              height: 2.5,
            ),
          ),
          Obx(() {
            return MyTextField(
              controller: _passwordController,
              hint: "Enter Password",
              icon: Icon(Icons.lock_rounded, color: MyColorPalette.textGrey),
              obscureText: isHidden.value,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "Password is missing!";
                } else {
                  return null;
                }
              },
              maxLines: 1,
              trailing: IconButton(
                onPressed: () {
                  isHidden.value = !isHidden.value;
                },
                icon: Icon(
                  isHidden.value
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash,
                ),
              ),
            );
          }),
          const SizedBox(height: 30),
          Obx(() {
            return MyButton(
              onTap: _handleLogin,
              child: isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: MyColorPalette.white,
                      ),
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(
                        color: MyColorPalette.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
