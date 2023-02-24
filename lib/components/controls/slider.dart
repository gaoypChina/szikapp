import 'package:flutter/material.dart';
import '../../ui/themes.dart';
import '../components.dart';

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
    super.key,
    required this.titleText,
    this.initValue,
    this.min = 0,
    this.max = 100,
    this.minIcon = const CustomIcon(
      CustomIcons.volumeDown,
      size: kIconSizeLarge,
    ),
    this.maxIcon = const CustomIcon(
      CustomIcons.volumeUp,
      size: kIconSizeLarge,
    ),
    required this.onChanged,
  });

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
    var theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kPaddingLarge),
      margin: const EdgeInsets.symmetric(
        vertical: kPaddingSmall,
        horizontal: kPaddingLarge,
      ),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(kBorderRadiusNormal),
          )),
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
