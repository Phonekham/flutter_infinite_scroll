import 'package:flutter/material.dart';
import 'package:flutter_infinite_scroll/infinite_listview_scrolling/provider/data_provider.dart';
import 'package:provider/provider.dart';

class InfiniteListviewScrolling extends StatefulWidget {
  const InfiniteListviewScrolling({super.key});

  @override
  State<InfiniteListviewScrolling> createState() =>
      _InfiniteListviewScrollingState();
}

class _InfiniteListviewScrollingState extends State<InfiniteListviewScrolling> {
  ScrollController _scrollController = new ScrollController();
  int _page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    var videosBloc = Provider.of<DataProvider>(context, listen: false);
    videosBloc.resetStreams();
    videosBloc.fetchAllUsers(_page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        videosBloc.setLoadingState(LoadMoreStatus.LOADING);
        videosBloc.fetchAllUsers(++_page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _buildRow(radioModel) {
    return ListTile(title: new Text(radioModel.radioName));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
