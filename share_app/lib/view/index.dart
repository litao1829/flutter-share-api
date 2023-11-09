import 'package:flutter/material.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/view/home.dart';
import 'package:share_app/view/mine.dart';
import 'package:share_app/view/submission.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<Map> items=[
    {
      "label":"首页",
      "selected_icon":"assets/images/shouye_selected.png",
      "unselected_icon":"assets/images/shouye_unselect.png"
    },
    {
      "label":"投稿",
      "selected_icon":"assets/images/tougao_selected.png",
      "unselected_icon":"assets/images/tougao_unselect.png"
    },
    {
      "label":"我的",
      "selected_icon":"assets/images/wode_selected.png",
      "unselected_icon":"assets/images/wode_unselect.png"
    }
  ];

  ///控制器
  PageController _controller=PageController(initialPage: 0);

  ///view
  List<Widget> views=[HomePage(),SubmissionPage(),MinePage()];


  //当前选中tab index
  int _current=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          _current=index;
          _controller.jumpToPage(index);
          setState(() {});
        },
         currentIndex: _current,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Constant.miancolor,
        unselectedFontSize: 14,
        selectedFontSize: 14,
        items: items.map((e){
          return BottomNavigationBarItem(
              icon: Image.asset(e['unselected_icon'],width: 24,height: 24,),
          activeIcon: Image.asset(e['selected_icon'],width: 24,height: 24,),
          label: e['label']);
        }).toList(),
      ),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: views,
      ),
    );
  }
}
