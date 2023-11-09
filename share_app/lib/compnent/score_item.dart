import 'package:flutter/material.dart';
import 'package:share_app/model/score_log.dart';

import '../common/constant.dart';

class ScoreItem extends StatefulWidget {
  ScoreLog model;
   ScoreItem(this.model,{super.key});

  @override
  State<ScoreItem> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Image(image: AssetImage("assets/images/time.png")),
                SizedBox(width: 10,),
                Text(widget.model.createTime!),
              ],
            ),
          ),
          SizedBox(width: 14,),
          Offstage(
            offstage: ! (widget.model.event=='BUY') ,
            child: Text("兑换")
            ),
          Offstage(
              offstage: !(widget.model.event=='CONTRIBUTE') ,
              child: Text("投稿")
          ),
          Offstage(
              offstage: !(widget.model.event=='SIGIN') ,
              child: Text("签到")
          ),
          Expanded(child: Container(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(widget.model.value!.toString())
              ],
            ),
          )),
        ],
      ),
    );
  }
}
