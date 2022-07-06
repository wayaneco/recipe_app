import 'package:flutter/material.dart';

class ThemeChange extends StatefulWidget {
  final int selectedColor;
  final Function setTheme;

  ThemeChange(this.selectedColor, this.setTheme);

  _ThemeChangeState createState() => _ThemeChangeState();
}

class _ThemeChangeState extends State<ThemeChange> {
  int selectedVal = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedVal = widget.selectedColor;
    });
  }

  void changeTheme(value) {
    widget.setTheme(value);
    setState(() {
      selectedVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
      ),
      body: Column(
        children: [
          RadioListTile(
            value: 0,
            title: const Text("Default"),
            subtitle: const Text('Change the theme to default'),
            groupValue: selectedVal,
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: changeTheme,
          ),
          const Divider(),
          RadioListTile(
            value: 1,
            title: const Text("Red"),
            subtitle: const Text('Change the theme to red'),
            groupValue: selectedVal,
            onChanged: changeTheme,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
          const Divider(),
          RadioListTile(
            value: 2,
            title: const Text("Green"),
            subtitle: const Text('Change the theme to green'),
            groupValue: selectedVal,
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: changeTheme,
          ),
          const Divider(),
          RadioListTile(
            value: 3,
            title: const Text("Dark"),
            subtitle: const Text('Change the theme to black'),
            groupValue: selectedVal,
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: changeTheme,
          )
        ],
      ),
    );
  }
}
