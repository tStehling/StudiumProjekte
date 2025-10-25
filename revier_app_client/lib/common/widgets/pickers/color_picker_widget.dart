import 'package:flutter/material.dart';

/// A widget that allows selecting a color from predefined options.
///
/// This widget displays a color circle that opens a dialog with color options
/// when tapped. It also provides an option to clear the color selection.
class ColorPickerWidget extends StatelessWidget {
  /// The current color value (as int)
  final int? colorValue;

  /// Called when the color changes
  final Function(int?) onColorChanged;

  /// Title text to show above the picker
  final String? title;

  /// Color preset options to display
  final List<Color> colorOptions;

  /// Creates a color picker widget with preset options
  const ColorPickerWidget({
    super.key,
    required this.colorValue,
    required this.onColorChanged,
    this.title,
    this.colorOptions = const [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.grey,
    ],
  });

  @override
  Widget build(BuildContext context) {
    final currentColor =
        colorValue != null ? Color(colorValue!) : Colors.grey.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(title!, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => _showColorPickerDialog(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () => onColorChanged(null),
                child: const Text('Clear Color'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show a dialog with color options
  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final color in colorOptions)
                  _ColorOption(
                    color: color,
                    onTap: () {
                      onColorChanged(color.value);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A single color option item in the color picker
class _ColorOption extends StatelessWidget {
  /// The color to display
  final Color color;

  /// Called when this color option is tapped
  final VoidCallback onTap;

  /// Creates a color option item
  const _ColorOption({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              _colorToName(color),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to convert color to name
  String _colorToName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.green) return 'Green';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.brown) return 'Brown';
    if (color == Colors.grey) return 'Grey';
    return 'Custom';
  }
}
