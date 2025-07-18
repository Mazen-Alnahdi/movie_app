import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_in/sign_in_cubit.dart';
import 'package:movie_app/src/auth/presentation/controllers/blocs/sign_up/sign_up_cubit.dart';
import 'package:movie_app/src/auth/presentation/screens/welcome_screen.dart';
import 'package:movie_app/src/home/presentation/blocs/retrieve_weather/retrieve_weather_cubit.dart';

import 'core/services/injection_container.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    name: 'Movie_APP',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RetrieveWeatherCubit>(
          create: (context) => sl<RetrieveWeatherCubit>(),
        ),
        BlocProvider<SignUpCubit>(create: (context) => sl<SignUpCubit>()),
        BlocProvider<SignInCubit>(create: (context) => sl<SignInCubit>()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: WelcomeScreen(),
      ),
    );
  }
}
