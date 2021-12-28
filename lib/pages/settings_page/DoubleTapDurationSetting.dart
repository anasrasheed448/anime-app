import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/providers/settings/DoubleTapDuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoubleTapDurationSetting extends StatefulWidget {
  const DoubleTapDurationSetting({Key key}) : super(key: key);

  @override
  _DoubleTapDurationSettingState createState() =>
      _DoubleTapDurationSettingState();
}

class _DoubleTapDurationSettingState extends State<DoubleTapDurationSetting> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var provider = watch(doubleTapDurationProvider);
        return ListTile(
          title: Text('Double-tap to seek duration'),
          subtitle: Text(provider.value.toString() + ' Seconds'),
          onTap: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Double-tap to seek'),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'),
                  )
                ],
                content: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...(DoubleTapDurationProvider.POSSIBLE_VALUES
                            .map(
                              (e) => RadioListTile<int>(
                                value: e,
                                title: Text('$e Seconds'),
                                groupValue: provider.value,
                                onChanged: (value) {
                                  provider.updateValue(value);
                                  Navigator.of(context).pop();
                                },
                              ),
                            )
                            .toList())
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
