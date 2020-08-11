import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_app/providers/theme_provider.dart';
import 'package:rent_app/style.dart';

class TabBarComponent extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> tabViews;
  final int tabLength;

  const TabBarComponent({Key key, this.tabs, this.tabViews, this.tabLength}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: this.tabLength,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(4000),
          child: Container(
            height: 70,
            decoration: containerDecoration(themeProvider),
            child: tabBarComponent(),
          ),
        ),
        body: tabBarViews(),
      ),
    );
  }

  Decoration containerDecoration(ThemeProvider provider) {
    return BoxDecoration(
      color: provider.isLightTheme ? Colors.white : AppStyle().darkColor ,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 16,
          offset: Offset(0, 4),
        )
      ],
    );
  }

  Widget tabBarComponent() {
    return TabBar(
      labelColor: Colors.indigo,
      unselectedLabelColor: Color(0xFFB6B6B6),
      indicator: CustomTabIndicator(),
      labelStyle: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
      tabs: tabs.map((tab) => Tab(text: tab)).toList(),
    );
  }

  Widget tabBarViews() {
    return TabBarView(
      physics: BouncingScrollPhysics(),
      children: tabViews,
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  _CustomPainter createBoxPainter([VoidCallback onChanged]) => _CustomPainter(this, onChanged);
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = Rect.fromLTWH(configuration.size.width / 2 + offset.dx - 35, offset.dy + 65, 75, 5);
    final Paint paint = Paint();
    paint.color = AppStyle().secondaryTextColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      paint,
    );
  }
}
