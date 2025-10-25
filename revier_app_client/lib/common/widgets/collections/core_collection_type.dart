import 'package:flutter/material.dart';

typedef CoreCollectionItemType = ({
  String imagePath,
  String title,
  String subtitle,
});

typedef CoreCollectionOptions = ({
  Function(CoreCollectionItemType item)? onItemSelected,
  Function(CoreCollectionItemType item)? onItemMoreOptions,
  int? gridColumns,
  double? gridAspectRatio,
  double? listItemHeight,
  bool showDividers,
  EdgeInsets? padding,
  double? spacing,
  bool initialShowGrid,
});
