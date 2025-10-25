import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Function(String) onOptionSelected;
  final String selectOptionText;

  const AppBarButton({
    super.key,
    required this.onOptionSelected,
    required this.selectOptionText,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: colorScheme.onSurface,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  selectOptionText,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text("OptionA",
                          style: TextStyle(color: colorScheme.onSurface)),
                      onTap: () {
                        onOptionSelected("OptionA");
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text("OptionB",
                          style: TextStyle(color: colorScheme.onSurface)),
                      onTap: () {
                        onOptionSelected("OptionB");
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text("OptionC",
                          style: TextStyle(color: colorScheme.onSurface)),
                      onTap: () {
                        onOptionSelected("OptionC");
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                backgroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
