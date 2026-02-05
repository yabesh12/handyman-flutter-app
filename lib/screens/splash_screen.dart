import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/screens/maintenance_mode_screen.dart';
import 'package:booking_system_flutter/utils/configs.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/loader_widget.dart';
import '../network/rest_apis.dart';
import 'walk_through_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool appNotSynced = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);
      init();
    });
  }

  Future<void> init() async {
    await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));

    // Set default configuration
    await appConfigurationStore.setUserDashboardType(DASHBOARD_1);
    await appConfigurationStore.setCurrencySymbol('₹');
    await appConfigurationStore.setCurrencyCode('INR');
    await appConfigurationStore.setCurrencyPosition(CURRENCY_POSITION_LEFT);

    /// Load app configurations from backend
    try {
      await getAppConfigurations().then((value) {}).catchError((e) async {
        if (!await isNetworkAvailable()) {
          toast(errorInternetNotAvailable);
        }
        log(e);
      });
    } catch (e) {
      log('Backend not configured, running in static mode');
    }

    // AC Chill - Force INR currency (override backend settings until admin panel is updated)
    await appConfigurationStore.setCurrencySymbol('₹');
    await appConfigurationStore.setCurrencyCode('INR');
    await appConfigurationStore.setCurrencyPosition(CURRENCY_POSITION_LEFT);

    appStore.setLoading(false);

    // Always proceed to the app screens (static mode support)
    int themeModeIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
    if (themeModeIndex == THEME_MODE_SYSTEM) {
      appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    }

    // Navigate to walkthrough or dashboard
    if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
      WalkThroughScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    } else {
      DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            appStore.isDarkMode ? splash_background : splash_light_background,
            height: context.height(),
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(appLogo, height: 120, width: 120),
              32.height,
              Text(APP_NAME, style: boldTextStyle(size: 26, color: appStore.isDarkMode ? Colors.white : Colors.black), textAlign: TextAlign.center),
              16.height,
              if (appNotSynced)
                Observer(
                  builder: (_) => appStore.isLoading
                      ? LoaderWidget().center()
                      : TextButton(
                          child: Text(language.reload, style: boldTextStyle()),
                          onPressed: () {
                            appStore.setLoading(true);
                            init();
                          },
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
