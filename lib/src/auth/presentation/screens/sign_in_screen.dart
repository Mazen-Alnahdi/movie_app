import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_in/sign_in_cubit.dart';
import 'package:movie_app/src/auth/presentation/screens/sign_up_screen.dart';

import '../../../../core/services/injection_container.dart';
import '../../../home/presentation/blocs/retrieve_weather/retrieve_weather_cubit.dart';
import '../../../home/presentation/screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<SignInCubit>().signIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: sl<RetrieveWeatherCubit>(),
                child: HomeScreen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF031450), Color(0xFF011F8C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      // used here only to stretch vertically, performance safe in this context
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 120),

                          const Center(
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // const SizedBox(height: 5),
                          const Center(
                            child: Text(
                              "CREATE AN ACCOUNT TO MAKE SDFSDF",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 150),

                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.08),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              const SizedBox(width: 20),
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.08),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 70),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          BlocBuilder<SignInCubit, SignInState>(
                            builder: (context, state) {
                              if (state is SignInInProgress) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is SignInFailed) {
                                return Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.red),
                                );
                              } else if (state is SignInSuccess) {
                                return const Text(
                                  "Logged in successfully!",
                                  style: TextStyle(color: Colors.greenAccent),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          // const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "DON'T HAVE AN ACCOUNT ?",
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
