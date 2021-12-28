import 'package:anime_twist_flut/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_color_picker/simple_color_picker.dart';

class AccentPickerSetting extends StatefulWidget {
  const AccentPickerSetting({Key key}) : super(key: key);

  @override
  _AccentPickerSettingState createState() => _AccentPickerSettingState();
}

class _AccentPickerSettingState extends State<AccentPickerSetting> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var provider = watch(accentProvider);
        return ListTile(
          title: Text('Accent Color'),
          subtitle: Text('Make it colorful'),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.5,
              child: SimpleColorPicker(
                height: MediaQuery.of(context).size.height * 0.6,
                onCancel: () => Navigator.of(context).pop(),
                onColorSelect: (color) {
                  provider.updateValue(color);
                  Navigator.of(context).pop();
                },
                initialColor: Theme.of(context).accentColor,
              ),
            ),
          ),
          trailing: Container(
            margin: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 15.0,
            ),
          ),
        );
      },
    );
  }
}
