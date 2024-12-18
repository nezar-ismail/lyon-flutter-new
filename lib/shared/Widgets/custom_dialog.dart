import 'package:flutter/material.dart';

Future tempDialog({customContext, title, subTitle, okButton, cancelButton}) {
  return showDialog<dynamic>(
    context: customContext,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    //translate(title),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text(
                    subTitle,
                    //translate(subTitle),
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (cancelButton != null)
                    Expanded(
                      flex: 6,
                      child: InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(7)),
                          child: Text(
                            //translate(cancelButton),
                            cancelButton,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green,
                                //fontSize: shared.locale == 'ar' ? 12 : 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                  if (cancelButton != null)
                    const SizedBox(
                      width: 5,
                    ),
                  Expanded(
                    flex: 6,
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          //translate(okButton),
                          okButton,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              //fontSize: shared.locale == 'ar' ? 12 : 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}