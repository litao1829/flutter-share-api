import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_app/provider/list_item_notification.dart';
import 'package:share_app/view/home.dart';
import 'package:share_app/view/index.dart';
import 'package:share_app/view/login/login.dart';
import 'package:share_app/view/mine.dart';
import 'package:share_app/view/mine/help.dart';
import 'package:share_app/view/mine/my_exchange.dart';
import 'package:share_app/view/mine/my_submission.dart';
import 'package:share_app/view/mine/score_detail.dart';
import 'package:share_app/view/mine/setting.dart';

void main() {

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  ///创建路由表数据
  Map<String,WidgetBuilder> routes={
    "my_exchange":(context)=>MyExchangePage(),
    "my_submission":(context)=>MySubmissionPage(),
    "help":(context)=>HelpPage(),
    "score_detail":(context)=>ScoreDetailPage(),
    "setting":(context)=>SettingPage(),
    "index":(context)=>IndexPage(),
    "login":(context)=>LoginPage()
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: TextModel()),
        ChangeNotifierProvider.value(value: ListItemNotification()),
        // ChangeNotifierProvider.value(value: CounterModel(),)
      ],
      child: MaterialApp(
        routes: routes,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home:  const IndexPage(),

      ),
    );
  }
}
