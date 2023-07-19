import 'package:flutter/material.dart';
import 'package:mychatapp/connections/connections.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

TextEditingController _namecontroller = TextEditingController();
TextEditingController _usernamecontroller = TextEditingController();
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _passcontroller = TextEditingController();
final formKey = GlobalKey<FormState>();

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              //name
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter valid name";
                  } else {
                    return null;
                  }
                },
                controller: _namecontroller,
                decoration: InputDecoration(
                    hintText: "name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),
              //username
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "enter valid username";
                  } else {
                    return null;
                  }
                },
                controller: _usernamecontroller,
                decoration: InputDecoration(
                    hintText: "username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),

              //email
              //   !RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
              // .hasMatch(value))
              // !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              //               .hasMatch(value))
              TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                          .hasMatch(value)) {
                    return "enter valid email";
                  } else {
                    return null;
                  }
                },
                controller: _emailcontroller,
                decoration: InputDecoration(
                    hintText: "email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),

              //password
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return "enter longer password";
                  } else {
                    return null;
                  }
                },
                controller: _passcontroller,
                decoration: InputDecoration(
                    hintText: "password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await Connections().createUser(
                        username: _usernamecontroller.text,
                        email: _emailcontroller.text,
                        password: _passcontroller.text,
                        name: _namecontroller.text,
                        context: context);
                  }
                },
                child: const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
