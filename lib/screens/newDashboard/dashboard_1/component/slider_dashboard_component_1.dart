import 'dart:async';

import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../model/dashboard_model.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/configs.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../notification/notification_screen.dart';
import '../../../service/search_service_screen.dart';
import '../../../service/service_detail_screen.dart';

class SliderDashboardComponent1 extends StatefulWidget {
  final List<SliderModel> sliderList;
  final List<ServiceData>? featuredList;
  final VoidCallback? callback;

  SliderDashboardComponent1({required this.sliderList, this.callback, this.featuredList});

  @override
  _SliderDashboardComponent1State createState() => _SliderDashboardComponent1State();
}

class _SliderDashboardComponent1State extends State<SliderDashboardComponent1> {
  PageController sliderPageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (getBoolAsync(AUTO_SLIDER_STATUS, defaultValue: true) && widget.sliderList.length >= 2) {
      _timer = Timer.periodic(Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND), (Timer timer) {
        if (_currentPage < widget.sliderList.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        sliderPageController.animateToPage(_currentPage, duration: Duration(milliseconds: 950), curve: Curves.easeOutQuart);
      });

      sliderPageController.addListener(() {
        _currentPage = sliderPageController.page!.toInt();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sliderPageController.dispose();
  }

  Widget getSliderWidget() {
    return SizedBox(
      height: 280,
      width: context.width(),
      child: Stack(
        children: [
          // Slider images with rounded bottom
          widget.sliderList.isNotEmpty
              ? PageView(
                  controller: sliderPageController,
                  children: List.generate(
                    widget.sliderList.length,
                    (index) {
                      SliderModel data = widget.sliderList[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedImageWidget(
                            url: data.sliderImage.validate(),
                            height: 280,
                            width: context.width(),
                            fit: BoxFit.cover,
                          ),
                          // Gradient overlay for text readability
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Slider title
                          if (data.title.validate().isNotEmpty)
                            Positioned(
                              bottom: 40,
                              left: 20,
                              right: 80,
                              child: Text(
                                data.title.validate(),
                                style: boldTextStyle(color: Colors.white, size: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ).onTap(() {
                        if (data.type == SERVICE) {
                          ServiceDetailScreen(serviceId: data.typeId.validate().toInt()).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                        }
                      });
                    },
                  ),
                )
              : CachedImageWidget(url: '', height: 280, width: context.width()),
          // Dot indicators
          if (widget.sliderList.length.validate() > 1)
            Positioned(
              bottom: 16,
              right: 20,
              child: DotIndicator(
                pageController: sliderPageController,
                pages: widget.sliderList,
                indicatorColor: Colors.white,
                unselectedIndicatorColor: Colors.white.withOpacity(0.4),
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(16),
                currentBorderRadius: radius(16),
                currentDotSize: 20,
                currentDotWidth: 20,
                dotSize: 8,
              ),
            ),
          // Notification bell
          if (appStore.isLoggedIn)
            Positioned(
              top: context.statusBarHeight + 12,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                height: 40,
                padding: EdgeInsets.all(8),
                width: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ic_notification.iconImage(size: 22, color: primaryColor).center(),
                    Observer(builder: (context) {
                      return Positioned(
                        top: -14,
                        right: -8,
                        child: appStore.unreadCount.validate() > 0
                            ? Container(
                                padding: EdgeInsets.all(4),
                                child: FittedBox(
                                  child: Text(appStore.unreadCount.toString(), style: primaryTextStyle(size: 10, color: Colors.white)),
                                ),
                                decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                              )
                            : Offstage(),
                      );
                    })
                  ],
                ),
              ).onTap(() {
                NotificationScreen().launch(context);
              }),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getSliderWidget(),
        // Location + Search bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Observer(
                builder: (context) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        locationWiseService(context, () {
                          widget.callback?.call();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, color: primaryColor, size: 20),
                            8.width,
                            Text(
                              appStore.isCurrentLocation ? getStringAsync(CURRENT_ADDRESS) : language.lblLocationOff,
                              style: secondaryTextStyle(size: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ).expand(),
                            Icon(
                              Icons.my_location_rounded,
                              size: 18,
                              color: appStore.isCurrentLocation ? primaryColor : grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              12.width,
              GestureDetector(
                onTap: () {
                  SearchServiceScreen(featuredList: widget.featuredList).launch(context);
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Icon(Icons.search_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
