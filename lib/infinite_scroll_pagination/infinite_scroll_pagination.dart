import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/infinite_scroll_pagination/charactor_list_view.dart';

class InfiniteScrollPagination extends StatefulWidget {
  const InfiniteScrollPagination({super.key});

  @override
  State<InfiniteScrollPagination> createState() =>
      _InfiniteScrollPaginationState();
}

class _InfiniteScrollPaginationState extends State<InfiniteScrollPagination> {
  int _selectedBottomNavigationIndex = 0;

  final List<_BottomNavigationItem> _bottomNavigationItems = [
    _BottomNavigationItem(
      label: 'Pull to Refresh',
      iconData: Icons.refresh,
      widgetBuilder: (context) => CharacterListView(),
    ),
    _BottomNavigationItem(
      label: 'Search/Snackbar',
      iconData: Icons.search,
      widgetBuilder: (context) => CharacterListView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigationIndex,
        items: _bottomNavigationItems
            .map(
              (item) => BottomNavigationBarItem(
                  icon: Icon(item.iconData), label: item.label),
            )
            .toList(),
        onTap: (newIndex) =>
            setState(() => _selectedBottomNavigationIndex = newIndex),
      ),
      body: IndexedStack(
        index: _selectedBottomNavigationIndex,
        children: _bottomNavigationItems
            .map((item) => item.widgetBuilder(context))
            .toList(),
      ),
    );
  }
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.label,
    required this.iconData,
    required this.widgetBuilder,
  });

  final String label;
  final IconData iconData;
  final WidgetBuilder widgetBuilder;
}
