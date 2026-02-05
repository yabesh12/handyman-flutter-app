import 'package:booking_system_flutter/model/package_data_model.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/price_widget.dart';
import '../../../main.dart';
import '../../../model/booking_detail_model.dart';
import '../../../model/service_detail_response.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';
import '../../dashboard/dashboard_screen.dart';

class BookingConfirmationDialog extends StatefulWidget {
  final ServiceDetailResponse data;
  final int? bookingId;
  final num? bookingPrice;
  final BookingPackage? selectedPackage;
  final BookingDetailResponse? bookingDetailResponse;

  BookingConfirmationDialog({
    required this.data,
    required this.bookingId,
    this.bookingPrice,
    this.selectedPackage,
    this.bookingDetailResponse,
  });

  @override
  State<BookingConfirmationDialog> createState() => _BookingConfirmationDialogState();
}

class _BookingConfirmationDialogState extends State<BookingConfirmationDialog> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  Widget buildDateWidget() {
    if (widget.data.serviceDetail!.isSlotAvailable) {
      return Text(formatBookingDate(widget.data.serviceDetail!.bookingDate.validate(), format: DATE_FORMAT_2), style: boldTextStyle(size: 14));
    }
    return Text(formatBookingDate(widget.data.serviceDetail!.dateTimeVal.validate(), format: DATE_FORMAT_2), style: boldTextStyle(size: 14));
  }

  Widget buildTimeWidget() {
    if (widget.data.serviceDetail!.bookingSlot == null) {
      return Text(formatBookingDate(widget.data.serviceDetail!.dateTimeVal.validate(), format: HOUR_12_FORMAT), style: boldTextStyle(size: 14), textAlign: TextAlign.end);
    }
    return Text(
      TimeOfDay(
        hour: widget.data.serviceDetail!.bookingSlot.validate().splitBefore(':').split(":").first.toInt(),
        minute: widget.data.serviceDetail!.bookingSlot.validate().splitBefore(':').split(":").last.toInt(),
      ).format(context),
      style: boldTextStyle(size: 14),
      textAlign: TextAlign.end,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: Offset(0, 8)),
              ],
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                36.height,
                Text(language.thankYou, style: boldTextStyle(size: 22, color: primaryColor)),
                8.height,
                Text(
                  language.bookingConfirmedMsg,
                  style: secondaryTextStyle(size: 13),
                  textAlign: TextAlign.center,
                ),
                24.height,
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryColor.withOpacity(0.15)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.lblDate, style: secondaryTextStyle(size: 11, color: appTextSecondaryColor)),
                          Text(language.lblTime, style: secondaryTextStyle(size: 11, color: appTextSecondaryColor)),
                        ],
                      ),
                      6.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildDateWidget().expand(flex: 2),
                          buildTimeWidget().expand(flex: 1),
                        ],
                      ),
                    ],
                  ),
                ),
                16.height,
                if (!widget.data.serviceDetail!.isFreeService)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language.totalAmount, style: secondaryTextStyle(size: 13)),
                        PriceWidget(
                          price: widget.bookingPrice.validate(),
                          color: primaryColor,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                24.height,
                Row(
                  children: [
                    AppButton(
                      padding: EdgeInsets.zero,
                      text: language.goToHome,
                      textStyle: boldTextStyle(size: 13, color: Colors.white),
                      color: primaryColor,
                      shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onTap: () {
                        DashboardScreen().launch(context, isNewTask: true);
                      },
                    ).expand(),
                    12.width,
                    AppButton(
                      padding: EdgeInsets.zero,
                      text: language.goToReview,
                      textStyle: boldTextStyle(size: 12, color: primaryColor),
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: primaryColor),
                      ),
                      color: Colors.white,
                      onTap: () {
                        DashboardScreen(redirectToBooking: true).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                        BookingDetailScreen(bookingId: widget.bookingId.validate()).launch(context);
                      },
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(width: 5, color: Colors.white, style: BorderStyle.solid, strokeAlign: BorderSide.strokeAlignOutside),
              boxShadow: [
                BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 12, offset: Offset(0, 4)),
              ],
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }
}
