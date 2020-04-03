import 'package:flutter/material.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      height: 36,
      child: Row(
        children: [
          RawMaterialButton(
            onPressed: Navigator.of(context).pop,
            child: const Icon(Icons.arrow_back),
            shape: const CircleBorder(),
            fillColor: Colors.white,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
