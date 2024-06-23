import 'package:flutter/material.dart';
import 'package:mimichat/providers/ChatProvider.dart';
import 'package:mimichat/sockets/WsStompConfig.dart';
import 'package:mimichat/utils/AppStateManager.dart';
import 'package:mimichat/utils/CustomColors.dart';
import 'package:mimichat/views/pages/auth/LoginPage.dart';
import 'package:mimichat/views/pages/auth/Wrapper.dart';
import 'package:mimichat/views/pages/home/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WsStompConfig.stompClient.activate();

  await SharedPreferences.getInstance().then((cache) {
    AppStateManager.setCache(cache);

    runApp(
      ChangeNotifierProvider(
        create: (context) => ChatProvider(),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'MimiChat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Poppins',
                bodyColor: CustomColors.textBlack,
                displayColor: CustomColors.textBlack,
              ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: CustomColors.purpple,
            surface: CustomColors.BG_Grey,
          ),
          useMaterial3: true,
        ),
        home: Wrapper(),
      ),
    );
  }
}
