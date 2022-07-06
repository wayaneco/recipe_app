import 'package:flutter/material.dart';

import './theme.dart';

class DrawerWidget extends StatelessWidget {
  final int selectedColor;
  final Function setTheme;

  DrawerWidget(this.selectedColor, this.setTheme);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Container(
              width: double.infinity,
              height: 56,
              color: Theme.of(context).primaryColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10.0),
              child: const Text(
                'Welcome User',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 5.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => {
                      Navigator.of(context).pop(),
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              ThemeChange(this.selectedColor, this.setTheme),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final _offset = Tween(
                              begin: const Offset(1.0, 0),
                              end: Offset.zero,
                            ).chain(
                              CurveTween(
                                curve: Curves.linear,
                              ),
                            );

                            return SlideTransition(
                              position: animation.drive(_offset),
                              child: child,
                            );
                          },
                        ),
                      )
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.cached,
                          color: Theme.of(context).iconTheme.color,
                          size: 23,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Themes',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
