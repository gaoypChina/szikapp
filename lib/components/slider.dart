import 'package:flutter/material.dart';
import '../ui/themes.dart';

class CustomSlider extends StatefulWidget {
  ///A csúszka címe
  final Text titleText;

  ///Minimális érték
  final double min;

  ///Maximális érték
  final double max;

  ///Minimális érték ikonja
  final Widget minIcon;

  ///Maximális érték ikonja
  final Widget maxIcon;

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
    this.minIcon = const Icon(
      Icons.volume_mute,
      size: kIconSizeLarge,
    ),
    this.maxIcon = const Icon(
      Icons.volume_up,
      size: kIconSizeLarge,
    ),
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
      padding: const EdgeInsets.all(kPaddingLarge),
      margin: const EdgeInsets.symmetric(
        vertical: kPaddingSmall,
        horizontal: kPaddingLarge,
      ),
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
            alignment: Alignment.topLeft,
            child: widget.titleText,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.minIcon,
              Slider(
                value: _sliderValue,
                min: widget.min,
                max: widget.max,
                label: _sliderValue.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                  widget.onChanged(_sliderValue);
                },
              ),
              widget.maxIcon
            ],
          ),
        ],
      ),
    );
  }
}
