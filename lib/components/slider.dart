import 'package:flutter/material.dart';
import '../ui/themes.dart';

class CustomSlider extends StatefulWidget {
  ///A csúszka címe
  final Text titleText;

  ///Minimális érték
  final double min;

  ///Maximális érték
  final double max;

  ///Kezdeti érték (min és max között kell, hogy legyen)
  final double? initValue;

  ///A csúszka változásakor visszatér a gomb aktuális értékével
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.titleText,
    this.initValue,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _sliderValue = 0.0;

  @override
  void initState() {
    _sliderValue = widget.initValue ?? widget.max;
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
          Align(
            child: widget.titleText,
            alignment: Alignment.topLeft,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
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
                  widget.onChanged(_sliderValue);
                },
              ),
              const Icon(
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
