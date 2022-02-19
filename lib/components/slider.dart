import 'package:flutter/material.dart';
import '../ui/themes.dart';

class CustomSlider extends StatefulWidget {
  final Text titleText;
  final double min;
  final double max;

  CustomSlider({
    Key? key,
    required this.titleText,
    this.min = 0,
    this.max = 100,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _sliderValue;
  @override
  void initState() {
    _sliderValue = widget.max;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(kBorderRadiusNormal),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondaryContainer,
            offset: const Offset(0.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Column(
        children: [
          widget.titleText,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.volume_mute,
                size: kIconSizeLarge,
              ),
              Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                label: _sliderValue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
              Icon(
                Icons.volume_up,
                size: kIconSizeLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
