import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
// This widget is the home page of your application. It is stateful, meaning
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: const Center(
        child: Text("HomeContentMobile"),
      ),
      desktop: const Center(
        child: Text("HomeContentDesktop"),
      ),
    );
  }
}
