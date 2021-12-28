import 'package:anime_twist_flut/animations/TwistLoadingWidget.dart';
import 'package:anime_twist_flut/services/AppUpdateService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckUpdateSetting extends StatefulWidget {
  const CheckUpdateSetting({Key key}) : super(key: key);

  @override
  _CheckUpdateSettingState createState() => _CheckUpdateSettingState();
}

class _CheckUpdateSettingState extends State<CheckUpdateSetting> {
  bool isLoading = true;

  final updateCheckerProvider =
      FutureProvider.autoDispose<AppUpdateService>((ref) async {
    var appUpdateService = AppUpdateService();
    await appUpdateService.checkUpdate(showPopupOnUpdate: false);
    return appUpdateService;
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Check for updates'),
      subtitle: Text('Get the latest and the greatest'),
      onTap: () => showUpdateDialog(),
    );
  }

  void showUpdateDialog() {
    showDialog(
        context: context,
        builder: (context) => Consumer(
              builder: (context, watch, child) =>
                  watch(updateCheckerProvider).when(
                data: (data) => data.updateDialog(context),
                loading: () => AlertDialog(
                  title: Text('Checking for updates'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Transform.scale(
                            scale: 0.5,
                            child: RotatingPinLoadingAnimation(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                error: (e, s) => Container(),
              ),
            ));
  }
}
