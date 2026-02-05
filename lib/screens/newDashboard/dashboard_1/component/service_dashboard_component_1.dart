import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/cached_image_widget.dart';
import '../../../../component/image_border_component.dart';
import '../../../../component/online_service_icon_widget.dart';
import '../../../../component/price_widget.dart';
import '../../../../main.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/images.dart';
import '../../../booking/provider_info_screen.dart';
import '../../../service/service_detail_screen.dart';

class ServiceDashboardComponent1 extends StatefulWidget {
  final ServiceData serviceData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;
  final bool isFavouriteService;
  final bool isFromDashboard;

  ServiceDashboardComponent1({
    required this.serviceData,
    this.width,
    this.isBorderEnabled,
    this.isFavouriteService = false,
    this.onUpdate,
    this.isFromDashboard = false,
  });

  @override
  _ServiceDashboardComponent1State createState() => _ServiceDashboardComponent1State();
}

class _ServiceDashboardComponent1State extends State<ServiceDashboardComponent1> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ServiceDetailScreen(
          serviceId: widget.isFavouriteService ? widget.serviceData.serviceId.validate().toInt() : widget.serviceData.id.validate(),
        ).launch(context).then((value) {
          setStatusBarColor(context.primaryColor);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image section
            SizedBox(
              height: 170,
              width: context.width(),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: CachedImageWidget(
                      url: widget.isFavouriteService
                          ? widget.serviceData.serviceAttachments.validate().isNotEmpty
                              ? widget.serviceData.serviceAttachments.validate().first.validate()
                              : ''
                          : widget.serviceData.attachments.validate().isNotEmpty
                              ? widget.serviceData.attachments!.first.validate()
                              : '',
                      fit: BoxFit.cover,
                      height: 170,
                      width: context.width(),
                      circle: false,
                    ),
                  ),
                  // Category badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      constraints: BoxConstraints(maxWidth: context.width() * 0.35),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Marquee(
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          "${widget.serviceData.subCategoryName.validate().isNotEmpty ? widget.serviceData.subCategoryName.validate() : widget.serviceData.categoryName.validate()}",
                          style: boldTextStyle(color: Colors.white, size: 10),
                        ),
                      ),
                    ),
                  ),
                  // Rating badge
                  if (widget.serviceData.totalRating.validate() > 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 14),
                            4.width,
                            Text(
                              widget.serviceData.totalRating.validate().toStringAsFixed(1),
                              style: boldTextStyle(size: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Favourite button
                  if (widget.isFavouriteService)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: widget.serviceData.isFavourite == 1
                            ? ic_fill_heart.iconImage(color: favouriteColor, size: 18)
                            : ic_heart.iconImage(color: unFavouriteColor, size: 18),
                      ).onTap(() async {
                        if (widget.serviceData.isFavourite == 0) {
                          widget.serviceData.isFavourite = 1;
                          setState(() {});

                          await removeToWishList(serviceId: widget.serviceData.serviceId.validate().toInt()).then((value) {
                            if (!value) {
                              widget.serviceData.isFavourite = 0;
                              setState(() {});
                            }
                          });
                        } else {
                          widget.serviceData.isFavourite = 0;
                          setState(() {});

                          await addToWishList(serviceId: widget.serviceData.serviceId.validate().toInt()).then((value) {
                            if (!value) {
                              widget.serviceData.isFavourite = 1;
                              setState(() {});
                            }
                          });
                        }
                        widget.onUpdate?.call();
                      }),
                    ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service name
                  Marquee(
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: Text(
                      widget.serviceData.name.validate(),
                      style: boldTextStyle(size: 14, color: appTextPrimaryColor),
                    ),
                  ),
                  8.height,
                  // Price row
                  Row(
                    children: [
                      if (widget.serviceData.discount != 0)
                        PriceWidget(
                          price: discountedAmount,
                          isHourlyService: widget.serviceData.isHourlyService,
                          color: primaryColor,
                          hourlyTextColor: primaryColor,
                          size: 16,
                          isFreeService: widget.serviceData.type.validate() == SERVICE_TYPE_FREE,
                        ),
                      if (widget.serviceData.discount != 0) 8.width,
                      PriceWidget(
                        price: widget.serviceData.price.validate(),
                        isLineThroughEnabled: widget.serviceData.discount != 0 ? true : false,
                        isHourlyService: widget.serviceData.isHourlyService,
                        color: widget.serviceData.discount != 0 ? appTextSecondaryColor : primaryColor,
                        hourlyTextColor: widget.serviceData.discount != 0 ? appTextSecondaryColor : primaryColor,
                        size: widget.serviceData.discount != 0 ? 12 : 16,
                        isFreeService: widget.serviceData.type.validate() == SERVICE_TYPE_FREE,
                      ),
                      if (widget.serviceData.isOnlineService) OnlineServiceIconWidget().paddingLeft(8),
                    ],
                  ),
                  10.height,
                  // Provider info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ImageBorder(src: widget.serviceData.providerImage.validate(), height: 26),
                        8.width,
                        if (widget.serviceData.providerName.validate().isNotEmpty)
                          Text(
                            widget.serviceData.providerName.validate(),
                            style: secondaryTextStyle(size: 11, color: appTextSecondaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).expand()
                      ],
                    ),
                  ).onTap(() async {
                    if (widget.serviceData.providerId != appStore.userId.validate()) {
                      await ProviderInfoScreen(providerId: widget.serviceData.providerId.validate()).launch(context);
                      setStatusBarColor(Colors.transparent);
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  num get finalDiscountAmount => widget.serviceData.discount != 0 ? ((widget.serviceData.price.validate() / 100) * widget.serviceData.discount.validate()).toStringAsFixed(appConfigurationStore.priceDecimalPoint).toDouble() : 0;

  num get discountedAmount => widget.serviceData.price.validate() - finalDiscountAmount;
}
