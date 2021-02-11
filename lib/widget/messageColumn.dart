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
      const SliverAppBar(
        //stretch: true,
        backgroundColor: const Color(0xff303030),

        //      elevation: 0,
        pinned: true,
        floating: true,
        snap: true,
        collapsedHeight: 150.0,
        expandedHeight: 600,

        flexibleSpace: InputBox(),
      ),

      //Sliver
      //InputBox(),
      StreamBuilder(
          stream: _messageManager.updateMessageListStream,
          builder: (context, snapshot) {
            //print(Theme.of(context).backgroundColor);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return BoxText(
                    content: _messageManager.messageList[
                        _messageManager.messageList.length - (index + 1)],
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
