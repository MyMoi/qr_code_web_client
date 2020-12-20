import 'package:flutter/material.dart';
import 'package:qr_web_client/communication/messageManager.dart';
import 'package:qr_web_client/widget/boxTextWidget.dart';
import 'package:qr_web_client/widget/inputBox.dart';

class MessageColumn extends StatefulWidget {
  const MessageColumn({
    Key key,
  }) : super(key: key);

  @override
  _MessageColumnState createState() => _MessageColumnState();
}

class _MessageColumnState extends State<MessageColumn> {
  MessageManager _messageManager = MessageManager();

  @override
  Widget build(BuildContext context) {
    /*  _messageManager.updateMessageListStream.listen((event) {
      print('object');
      setState(() {});
    });*/
    // List messageList = ['aaaa', 'aaab', 'caaaa', 'aaaa https://google.com'];
    return CustomScrollView(slivers: <Widget>[
      /*  const SliverAppBar(
        //stretch: true,
        pinned: true,
        collapsedHeight: 200.0,
        flexibleSpace: InputBox(),
      ),*/
      StreamBuilder(
          stream: _messageManager.updateMessageListStream,
          builder: (context, snapshot) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return BoxText(
                    content: _messageManager.messageList[index],
                  );
                },
                childCount: _messageManager.messageList.length,
              ),
            );
          }),
      /*  Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

          ]),*/
    ]);
  }
}
