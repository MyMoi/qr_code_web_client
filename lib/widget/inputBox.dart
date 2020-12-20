import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
      padding: EdgeInsets.all(10),

      // width: Double.infinite,
      decoration: BoxDecoration(
          //color: Colors.amber,
          color: Colors.white10,
          //border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10))),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Expanded(
          //  child:
          ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight:
                      610 //put here the max height to which you need to resize the textbox

                  ),
              child: TextField(
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type somethings...',
                    hintStyle: TextStyle(color: Colors.white60)),
              )), //),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                    OutlineButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.copy_outlined),
                      label: Text("Copy"),
                    ),
                  ]),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send,
                    color: // Color(
                        //0xffc5e1a5), //
                        Theme.of(context).accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
