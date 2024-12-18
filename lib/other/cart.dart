import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:lyon/shared/Widgets/button.dart';
import 'package:lyon/shared/mehod/switch_sreen.dart';
import 'package:lyon/shared/styles/colors.dart';
import 'check_out.dart';
import 'main_screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: secondaryColor1,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Cart"),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 300,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: secondaryColor1,
                                    )),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Obaida Alqassem",
                                          style: stylePrimary20WithBold,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "KIA Cerato 2021",
                                          style: stylePrimary20WithBold,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "From: 20/12/2021 - 5:40 PM",
                                          style: stylePrimary20WithBold,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "To: 20/20/2021 - 5:40 PM",
                                          style: stylePrimary20WithBold,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/offer${index + 1}.png",
                                          fit: BoxFit.contain,
                                          width: 300,
                                          height: 200,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Total :",
                                              style: stylePrimary20WithBold,
                                            ),
                                            Text(
                                              "456 JD",
                                              style: stylePrimary20WithBold,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            button(
                context: context,
                text: "Checkout".tr,
                function: () {
                  push(context, CheckOut());
                }),
            const SizedBox(
              height: 20,
            ),
            button(
                context: context,
                text: "Continue Shopping".tr,
                function: () {
                  push(
                      context,
                      MainScreen(
                        numberIndex: 0,
                      ));
                }),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
