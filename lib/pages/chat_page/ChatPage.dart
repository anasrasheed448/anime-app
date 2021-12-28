// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:web_socket_channel/io.dart';

// Project imports:
import '../../models/chat/MessageModel.dart';
import '../../utils/TimeUtils.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  IOWebSocketChannel _channel;
  ScrollController _controller;
  final _messages = <MessageModel>[];

  void connect() async {
    _channel = IOWebSocketChannel.connect('wss://ws.twist.moe/');
  }

  @override
  void initState() {
    connect();
    WidgetsBinding.instance.addObserver(this);
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _channel.sink.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.inactive:
          _channel.sink.close();
          break;
        case AppLifecycleState.resumed:
          connect();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    return Scaffold(
      appBar: AppBar(
        title: AppbarText(
          custom: 'chat',
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_downward,
            ),
            onPressed: () {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: Duration(
                  milliseconds: _controller.offset != 0
                      ? (_controller.position.maxScrollExtent -
                              _controller.offset) ~/
                          5
                      : _controller.position.maxScrollExtent ~/ 5,
                ),
                curve: Curves.ease,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var jsonData = jsonDecode(snapshot.data);
            if (jsonData['type'] == 'msg') {
              var message = MessageModel.fromJson(jsonData);
              if (!_messages.contains(message)) {
                _messages.add(message);
              }
              if (_controller.hasClients) {
                if (_controller.position.pixels ==
                    _controller.position.maxScrollExtent) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    },
                  );
                }
              }
            }
          }
          return Scrollbar(
            controller: _controller,
            child: ListView.builder(
              controller: _controller,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages.elementAt(index).userModel.username),
                  subtitle: SelectableText(_messages.elementAt(index).message),
                  trailing: Text(
                    TimeUtils.dateTimetoHumanReadable(
                      _messages.elementAt(index).time,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
