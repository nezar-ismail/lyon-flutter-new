import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lyon/model/company_model/get_orders_company_model.dart';
import 'package:lyon/screen/company/full_day_company/full_day_order_details_company.dart';
import 'package:lyon/v_done/company/history/cubit/history_order_cubit.dart';
import 'package:lyon/screen/company/rental_company/rental_order_details_company.dart';
import 'package:lyon/screen/company/trip_company/trip_order_details_company.dart';
import 'package:lyon/shared/Widgets/custom_text.dart';
import 'package:lyon/shared/mehod/message.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryOrdersCompany extends StatelessWidget {
  const HistoryOrdersCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryOrdersCubit()..fetchOrders(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: BlocBuilder<HistoryOrdersCubit, HistoryOrdersState>(
            builder: (context, state) {
              if (state is HistoryOrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HistoryOrdersError) {
                return Center(
                    child: Text('${'error'.tr}: ${state.errorMessage}'));
              } else if (state is HistoryOrdersLoaded) {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomText(
                              text: 'contract_number'.tr,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomText(
                              text: 'name/date'.tr,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: 'service'.tr,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              text: 'status'.tr,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.blueAccent,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Expanded(child: _buildOrdersList(context, state)),
                  ],
                );
              }
              return const Center(child: Text('No data'));
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.home)),
      centerTitle: true,
      backgroundColor: Colors.blue, // Replace with your color
      title: Text('my_orders'.tr,
          style: const TextStyle(color: Colors.white, fontSize: 25)),
      actions: [
        Builder(builder: (context) {
          return IconButton(
              onPressed: () => context.read<HistoryOrdersCubit>().fetchOrders(),
              icon: const Icon(Icons.refresh));
        }),
      ],
    );
  }

  Widget _buildOrdersList(BuildContext context, HistoryOrdersLoaded state) {
    final orders = state.orders.data;

    if (orders == null || orders.isEmpty) {
      return Center(child: Text('you_do_not_have_any_reservations'.tr));
    }

    Future<void> _launchUrl(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        showMessage(
          context: context,
          text: "Can't_open_invoice_please_try_again!".tr,
        );
      }
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Slidable(
          key: ValueKey(order.id),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              if (order.isRelayed!.toLowerCase() == 'yes')
                SlidableAction(
                  // Invoice action
                  autoClose: true,
                  onPressed: (_) async {
                    final invoiceUrl =
                        _getInvoiceUrl(order.service!, order.contractId);
                    if (invoiceUrl != null) {
                      await _launchUrl(invoiceUrl);
                    } else {
                      showMessage(
                        context: context,
                        text: 'Invoice unavailable for this service type.',
                      );
                    }
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.contacts_rounded,
                  label: 'invoice'.tr,
                )
              else if (order.isRelayed!.toLowerCase() == 'no')
                SlidableAction(
                  onPressed: (_) {
                    _deleteDialog(context, order);
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: 'delete'.tr,
                ),
              Container(),
              SlidableAction(
                autoClose: true,
                onPressed: (_) {
                  if (order.service == 'Rental') {
                    push(context, RentalOrderDetailsCompany(id: order.id!));
                  } else if (order.service == 'Trip') {
                    push(context, TripOrderDetailsCompany(id: order.id!));
                  } else if (order.service == 'Full Day') {
                    push(context, FullDayOrderDetailsCompany(id: order.id!));
                  }
                },
                backgroundColor: const Color.fromRGBO(15, 186, 178, 1),
                foregroundColor: Colors.white,
                icon: Icons.info,
                label: 'details'.tr,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.12,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 1,
                      offset: const Offset(-2, 1.0),
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(order.contractNumber.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      order.projectName!,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    )),
                                Expanded(child: Text(order.date!)),
                              ],
                            ),
                          ),
                          Expanded(child: Text("    ${order.service!}")),
                          Expanded(
                              child: Text(
                            order.status!,
                            style: TextStyle(
                                color: order.status == 'Canceled'
                                    ? Colors.red
                                    : Colors.green),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    period: const Duration(seconds: 2),
                    direction: ShimmerDirection.rtl,
                    child: Text(
                      'Slide_For_more_details'.tr,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    )),
              ]),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> _deleteDialog(BuildContext context, Datum order) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('delete_order'.tr),
            content: Text('Are you sure you want to delete this order?'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('cancel'.tr),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<HistoryOrdersCubit>().deleteOrder(order.id!);
                },
                child: Text('delete'.tr),
              ),
            ],
          );
        });
  }

  String? _getInvoiceUrl(String service, String? contractId) {
    if (service == 'Rental') {
      return "https://lyon-jo.com/api/getContractInvoice.php?id=$contractId";
    } else if (service == 'Trip' || service == 'Full Day') {
      return "https://lyon-jo.com/api/getTransportationInvoice.php?id=$contractId";
    } else {
      return null;
    }
  }
}
