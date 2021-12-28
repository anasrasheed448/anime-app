// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';

class GenericDonationSheet extends StatefulWidget {
  final String name;
  final String address;
  final String qrURL;

  const GenericDonationSheet({Key key, this.name, this.address, this.qrURL})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GenericDonationSheetState();
  }
}

class _GenericDonationSheetState extends State<GenericDonationSheet> {
  final List<String> topTexts = [
    'Send your generous donation to the address below. Thanks!',
    'Copied!'
  ];

  bool isCopied = false;

  void onCopy() {
    setState(() {
      isCopied = true;
    });
    Timer(2.seconds, () {
      if (mounted) {
        setState(() {
          isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(
        15.0,
      ),
      height: height * 0.6,
      child: DeviceOrientationBuilder(
        portrait: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.chevronDown,
                  ),
                  iconSize: 15.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.0,
                    top: 5.0,
                  ),
                  child: AutoSizeText(
                    widget.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedSwitcher(
                    duration: 1.seconds,
                    child: isCopied ? Text(topTexts[1]) : Text(topTexts[0]),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: widget.address,
                          ),
                        );
                        onCopy();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Center(
                          child: Text(widget.address),
                        ),
                      ),
                    ),
                  ),
                  Image.network(
                    widget.qrURL,
                    fit: BoxFit.cover,
                    width: width * 0.75,
                    height: width * 0.75,
                  ),
                ],
              ),
            ),
          ],
        ),
        landscape: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.chevronDown,
                        ),
                        iconSize: 15.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10.0,
                          top: 5.0,
                        ),
                        child: AutoSizeText(
                          widget.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: 1.seconds,
                    child: isCopied ? Text(topTexts[1]) : Text(topTexts[0]),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 40.0,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: widget.address,
                          ),
                        );
                        onCopy();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Center(
                          child: Text(widget.address),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Image.network(
              widget.qrURL,
              fit: BoxFit.cover,
              width: height * 0.5,
              height: height * 0.5,
            ),
          ],
        ),
      ),
    );
  }
}
