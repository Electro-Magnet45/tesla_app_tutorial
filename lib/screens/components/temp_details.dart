import 'package:flutter/material.dart';

import '../../constanins.dart';
import '../../home_controller.dart';
import 'temp_btn.dart';

class TempDetails extends StatefulWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  final HomeController _controller;

  @override
  State<TempDetails> createState() => _TempDetailsState();
}

class _TempDetailsState extends State<TempDetails> {
  num insideTemp = 29;
  num outsideTemp = 35;
  bool insideTempSelected = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: Row(
              children: [
                TempBtn(
                    svgSrc: "assets/icons/coolShape.svg",
                    title: "Cool",
                    isActive: widget._controller.isCoolSelected,
                    press: widget._controller.updateCoolTab),
                const SizedBox(width: defaultPadding),
                TempBtn(
                    svgSrc: "assets/icons/heatShape.svg",
                    title: "Heat",
                    isActive: !widget._controller.isCoolSelected,
                    press: widget._controller.updateCoolTab,
                    activeColor: redColor),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      insideTempSelected ? insideTemp++ : outsideTemp++;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_up, size: 48)),
              Text(
                "${insideTempSelected ? insideTemp : outsideTemp}" "\u2103",
                style: const TextStyle(fontSize: 96),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      insideTempSelected ? insideTemp-- : outsideTemp--;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down, size: 48)),
            ],
          ),
          const Spacer(),
          Text("Current Temperature".toUpperCase()),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    insideTempSelected = !insideTempSelected;
                  });
                },
                child: DefaultTextStyle(
                  style: TextStyle(
                      color:
                          insideTempSelected ? Colors.white : Colors.white54),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Inside".toUpperCase()),
                        Text("$insideTemp" "\u2103",
                            style: const TextStyle(fontSize: 25))
                      ]),
                ),
              ),
              const SizedBox(width: defaultPadding),
              GestureDetector(
                onTap: () {
                  setState(() {
                    insideTempSelected = !insideTempSelected;
                  });
                },
                child: DefaultTextStyle(
                  style: TextStyle(
                      color:
                          insideTempSelected ? Colors.white54 : Colors.white),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Outside".toUpperCase()),
                        Text("$outsideTemp" "\u2103",
                            style: const TextStyle(fontSize: 25))
                      ]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
