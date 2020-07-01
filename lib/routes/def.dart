import 'package:flutter/material.dart';

class Def {
  static get wildcardChannel {
    return "#すべて";
  }

  static get feelingInfo {
    return {
      "good": {
        "icon": Icons.wb_sunny,
        "color": Colors.red,
        "text": 'いい気分',
      },
      "soso": {
        "icon": Icons.wb_sunny,
        "color": Colors.green,
        "text": 'まあまあ',
      },
      "gloomy": {
        "icon": Icons.wb_sunny,
        "color": Colors.purple,
        "text": 'もやもや',
      },
      "down": {
        "icon": Icons.wb_sunny,
        "color": Colors.blue,
        "text": 'しょんぼり',
      },
      "bad": {
        "icon": Icons.wb_sunny,
        "color": Colors.blueGrey,
        "text": 'もういや',
      },
      "nightmare": {
        "icon": Icons.wb_sunny,
        "color": Colors.black,
        "text": 'さいあく',
      },
      "up": {
        "icon": Icons.wb_sunny,
        "color": Colors.orange,
        "text": 'ふっかつ',
      }
    };
  }
}
