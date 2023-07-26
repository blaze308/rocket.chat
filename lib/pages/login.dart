// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mychatapp/connections/connections.dart';
import 'package:mychatapp/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController _usercontroller = TextEditingController();
TextEditingController _passwordcontroller = TextEditingController();
final formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              //username
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter valid user detail";
                  } else {
                    return null;
                  }
                },
                controller: _usercontroller,
                decoration: InputDecoration(
                    hintText: "username/ email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),

              const SizedBox(height: 10),
              //password
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 2) {
                    return "enter longer password";
                  } else {
                    return null;
                  }
                },
                controller: _passwordcontroller,
                decoration: InputDecoration(
                    hintText: "password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await Connections().loginUser(
                      user: _usercontroller.text,
                      password: _passwordcontroller.text,
                      context: context,
                    );
                  }
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
