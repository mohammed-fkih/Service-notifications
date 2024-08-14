import 'package:flutter/material.dart';

import 'pages/fix_page.dart';
import 'pages/home.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 1,
          bottom: TabBar(
            controller: tabController,
            labelStyle: const TextStyle(fontSize: 16),
            tabs: const [
              Tab(
                text: 'الرئيسية',
              ),
              Tab(text: 'الصيانة'),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            MyHome(),
            Repair(),
          ],
        ),
      ),
    );
  }
}