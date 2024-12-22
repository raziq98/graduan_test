import 'package:flutter/material.dart';
import 'package:graduan_test/screen/home_page.dart';
import 'package:graduan_test/screen/user_page.dart';

class LinearFlowWidget extends StatefulWidget {
  const LinearFlowWidget({
    super.key,
    this.onCallback,
  });
  final void Function(String data)? onCallback;

  @override
  State<LinearFlowWidget> createState() => _LinearFlowWidgetState();
}

class _LinearFlowWidgetState extends State<LinearFlowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  List<IconData> iconButtons = [];
  List<String> tooltipList = [];
  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    List<IconData> tempIcon = [
      Icons.menu_outlined,
      Icons.home_outlined,
      Icons.person_2_outlined,
      Icons.mail_outline,
      Icons.logout,
    ];
    List<Widget> tempNavigate = [
      Container(),
      const MyHomePage(),
      const Profile(),
      Container(),
      Container(),
    ];
    List<String> tempText = [
      'Menu',
      'Home',
      'Profile',
      'Post',
      'Log out',
    ];
    iconButtons = tempIcon;
    tooltipList = tempText;
    widgetList = tempNavigate;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToNext(int index) {
    List<Widget> temp = widgetList;
    try {
      if (temp[index] == Container()) {
      } else {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut, // Add your desired curve here
              );
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) =>
                temp[index],
          ),
        );
      }
    } catch (e) {
      // TODO
      debugPrint('error here');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(
        controller: _animationController,
      ),
      children: iconButtons.map<Widget>((iconButton) {
        return buildItem(iconButton, iconButtons.indexOf(iconButton));
      }).toList(),
    );
  }

  Widget buildItem(IconData icondata, int index) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: const CircleBorder(),
      child: IconButton(
        iconSize: 35,
        highlightColor: Colors.orangeAccent,
        splashRadius: 15,
        onPressed: () {
          if (index == 0 || index == 3 || index == 4) {
            if (_animationController.status == AnimationStatus.completed) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }

            if (index == 3 && widget.onCallback != null) {
              widget.onCallback!('openPost');
            } else if (index == 4 && widget.onCallback != null) {
              Navigator.pushReplacementNamed(context, '/');
              widget.onCallback!('logout');
            }
          } else {
            navigateToNext(index);
          }
        },
        tooltip: tooltipList[index],
        icon: Icon(
          icondata,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  FlowMenuDelegate({
    required this.controller,
  }) : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - 57;
    final yStart = size.height - 58;

    for (int i = context.childCount - 1; i >= 0; i--) {
      const margin = 8;
      final childSize = context.getChildSize(i)!.width;
      final dx = (childSize + margin) * i;
      final x = xStart;
      final y = yStart - dx * controller.value;

      context.paintChild(
        i, //index
        transform: Matrix4.translationValues(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return false;
  }
}
