import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/booking_detail_model.dart';
import 'package:booking_system_flutter/screens/booking/component/price_common_widget.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/base_scaffold_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../model/payment_gateway_response.dart';
import '../../network/rest_apis.dart';
import '../../utils/configs.dart';
import '../../utils/model_keys.dart';
import '../dashboard/dashboard_screen.dart';

// AC Chill - Simplified Payment Screen (COD Only)
class PaymentScreen extends StatefulWidget {
  final BookingDetailResponse bookings;
  final bool isForAdvancePayment;

  PaymentScreen({required this.bookings, this.isForAdvancePayment = false});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<List<PaymentSetting>>? future;

  PaymentSetting? currentPaymentMethod;

  num totalAmount = 0;
  num? advancePaymentAmount;

  @override
  void initState() {
    super.initState();
    init();

    if (widget.bookings.service!.isAdvancePayment && widget.bookings.service!.isFixedService && !widget.bookings.service!.isFreeService && widget.bookings.bookingDetail!.bookingPackage == null) {
      if (widget.bookings.bookingDetail!.paidAmount.validate() == 0) {
        advancePaymentAmount = widget.bookings.bookingDetail!.totalAmount.validate() * widget.bookings.service!.advancePaymentPercentage.validate() / 100;
        totalAmount = widget.bookings.bookingDetail!.totalAmount.validate() * widget.bookings.service!.advancePaymentPercentage.validate() / 100;
      } else {
        totalAmount = widget.bookings.bookingDetail!.totalAmount.validate() - widget.bookings.bookingDetail!.paidAmount.validate();
      }
    } else {
      totalAmount = widget.bookings.bookingDetail!.totalAmount.validate();
    }

    log(totalAmount);
  }

  void init() async {
    log("ISaDVANCE${widget.isForAdvancePayment}");
    // AC Chill - Only COD payment method
    future = _getCODPaymentOnly();
    setState(() {});
  }

  // AC Chill - Return only COD payment option
  Future<List<PaymentSetting>> _getCODPaymentOnly() async {
    // Create COD payment option
    List<PaymentSetting> codOnly = [
      PaymentSetting(
        title: 'Cash on Delivery',
        type: PAYMENT_METHOD_COD,
        status: 1,
      )
    ];

    // Auto-select COD
    currentPaymentMethod = codOnly.first;

    return codOnly;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _handleClick() async {
    appStore.setLoading(true);
    // AC Chill - Only COD payment
    if (currentPaymentMethod!.type == PAYMENT_METHOD_COD) {
      savePay(paymentMethod: PAYMENT_METHOD_COD, paymentStatus: SERVICE_PAYMENT_STATUS_PENDING);
    }
  }

  void savePay({String txnId = '', String paymentMethod = '', String paymentStatus = ''}) async {
    Map request = {
      CommonKeys.bookingId: widget.bookings.bookingDetail!.id.validate(),
      CommonKeys.customerId: appStore.userId,
      CouponKeys.discount: widget.bookings.service!.discount,
      BookingServiceKeys.totalAmount: totalAmount,
      CommonKeys.dateTime: DateFormat(BOOKING_SAVE_FORMAT).format(DateTime.now()),
      CommonKeys.txnId: txnId != '' ? txnId : "#${widget.bookings.bookingDetail!.id.validate()}",
      CommonKeys.paymentStatus: paymentStatus,
      CommonKeys.paymentMethod: paymentMethod,
    };

    if (widget.bookings.service != null && widget.bookings.service!.isAdvancePayment && widget.bookings.service!.isFixedService && !widget.bookings.service!.isFreeService && widget.bookings.bookingDetail!.bookingPackage == null) {
      request[AdvancePaymentKey.advancePaymentAmount] = advancePaymentAmount ?? widget.bookings.bookingDetail!.paidAmount;

      if ((widget.bookings.bookingDetail!.paymentStatus == null || widget.bookings.bookingDetail!.paymentStatus != SERVICE_PAYMENT_STATUS_ADVANCE_PAID || widget.bookings.bookingDetail!.paymentStatus != SERVICE_PAYMENT_STATUS_PAID) &&
          (widget.bookings.bookingDetail!.paidAmount == null || widget.bookings.bookingDetail!.paidAmount.validate() <= 0)) {
        request[CommonKeys.paymentStatus] = SERVICE_PAYMENT_STATUS_ADVANCE_PAID;
      } else if (widget.bookings.bookingDetail!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
        request[CommonKeys.paymentStatus] = SERVICE_PAYMENT_STATUS_PAID;
      }
    }

    appStore.setLoading(true);
    savePayment(request).then((value) {
      appStore.setLoading(false);
      push(DashboardScreen(redirectToBooking: true), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.payment,
      child: AnimatedScrollView(
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        physics: AlwaysScrollableScrollPhysics(),
        onSwipeRefresh: () async {
          if (!appStore.isLoading) init();
          return await 1.seconds.delay;
        },
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceCommonWidget(
                    bookingDetail: widget.bookings.bookingDetail!,
                    serviceDetail: widget.bookings.service!,
                    taxes: widget.bookings.bookingDetail!.taxes.validate(),
                    couponData: widget.bookings.couponData,
                    bookingPackage: widget.bookings.bookingDetail!.bookingPackage != null ? widget.bookings.bookingDetail!.bookingPackage : null,
                  ),
                  32.height,
                  Text(language.lblChoosePaymentMethod, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                ],
              ).paddingAll(16),
              SnapHelperWidget<List<PaymentSetting>>(
                future: future,
                onSuccess: (list) {
                  return AnimatedListView(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    emptyWidget: NoDataWidget(
                      title: language.noPaymentMethodFound,
                      imageWidget: EmptyStateWidget(),
                    ),
                    itemBuilder: (context, index) {
                      PaymentSetting value = list[index];

                      if (value.status.validate() == 0) return Offstage();

                      return RadioListTile<PaymentSetting>(
                        dense: true,
                        activeColor: primaryColor,
                        value: value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        groupValue: currentPaymentMethod,
                        onChanged: (PaymentSetting? ind) {
                          currentPaymentMethod = ind;
                          setState(() {});
                        },
                        title: Text(value.title.validate(), style: primaryTextStyle()),
                      );
                    },
                  );
                },
              ),
              // AC Chill - Wallet balance component removed
              16.height,
              if (!appStore.isLoading)
                AppButton(
                  onTap: () async {
                    if (currentPaymentMethod == null) {
                      return toast(language.chooseAnyOnePayment);
                    }

                    // AC Chill - Only COD confirmation
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.CONFIRMATION,
                      title: "${language.lblPayWith} ${currentPaymentMethod!.title.validate()}?",
                      primaryColor: primaryColor,
                      positiveText: language.lblYes,
                      negativeText: language.lblCancel,
                      onAccept: (p0) {
                        _handleClick();
                      },
                    );
                  },
                  text: "${language.lblPayNow} ${totalAmount.toPriceFormat()}",
                  color: context.primaryColor,
                  width: context.width(),
                ).paddingAll(16),
            ],
          ),
        ],
      ),
    );
  }
}
