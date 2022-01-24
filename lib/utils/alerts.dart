import 'package:flutter/material.dart';

class Alerts {
  static void showMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Error",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                          onPressed: () => {Navigator.of(context).pop()},
                          child: const Text("OK")),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
