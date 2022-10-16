import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'infinite_scroll_paginationv2/infinite_scroll_pagination2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InfiniteScrollPaginatio2(),
    );
  }
}
