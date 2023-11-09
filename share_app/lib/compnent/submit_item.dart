import 'package:flutter/material.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/model/knowledge_model.dart';
import 'package:share_app/model/submit_model.dart';
import 'package:share_app/view/home/Knowledge_detail.dart';


class SubmitCard extends StatefulWidget {
  SubmitModel model;

  SubmitCard(this.model,{super.key});

  @override
  State<SubmitCard> createState() => _SubmitCardState();
}


class _SubmitCardState extends State<SubmitCard> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:  Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.model.cover!,scale: 1),
                ),
              ],
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.model.name!,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Constant.black),),
                  Text(widget.model.name!,style: TextStyle(fontSize: 14,color: Constant.black,),)
                ],
              ),
            ),
           SizedBox(width:50,),
           Expanded(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Text(widget.model.code!.toString()+"积分",style: TextStyle(fontSize: 16,color: Constant.black),),
                   Text("兑换",style: TextStyle(fontSize: 14,color: Constant.black,),)
                 ],
               ))
          ],
        ),
      ),
    );
  }
}
