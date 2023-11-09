import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/compnent/submit_item.dart';
import 'package:share_app/model/submit_model.dart';

import '../net/api_helper.dart';
import '../net/dio_utils.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  int selectedValue = 1;

  TextEditingController titleEditingController=TextEditingController();
  TextEditingController authorEditingController=TextEditingController();
  TextEditingController priceEditingController=TextEditingController();
  TextEditingController summaryEditingController=TextEditingController();
  TextEditingController imageEditingController=TextEditingController();
  TextEditingController downloadEditingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.miancolor,
        title: Text("我的投稿",style: TextStyle(color: Constant.white,fontSize: 24,fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(  // 使用Flexible包裹以允许文本自动换行
                    child: Text(
                      "有积分奖励；提交的资源不得包含广告、侵权信息百度网盘地址建议有密码",
                      softWrap: true,
                      style: TextStyle(fontSize: 16),// 启用自动换行
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 5,
                color: Constant.grey,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("转载",style: TextStyle(fontSize: 18,),),
                   Radio(value: 0,
                       groupValue: selectedValue,
                       onChanged: (int? value){
                        setState(() {
                          selectedValue=value!;
                        });
                       })
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("原创",style: TextStyle(fontSize: 18,),),
                    Radio(value: 1,
                        groupValue: selectedValue,
                        onChanged: (int? value){
                          setState(() {
                            selectedValue=value!;
                          });
                        })
                  ],
                ),
              ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  children: [
                    Text("标题",style: TextStyle(fontSize: 18,),),
                      SizedBox(width: 70,),
                      Container(
                        width: 200,
                        child: TextField(
                            controller: titleEditingController,
                            decoration: InputDecoration(
                            hintText: "请输入知识分享标题",
                              border: InputBorder.none,
                        ),
                        ),
                      )
                  ],
                ),

                ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  children: [
                    Text("作者",style: TextStyle(fontSize: 18,),),
                    SizedBox(width: 70,),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: authorEditingController,
                        decoration: InputDecoration(
                          hintText: "请输入作者",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),

              ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  children: [
                    Text("价格",style: TextStyle(fontSize: 18,),),
                    SizedBox(width: 70,),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: priceEditingController,
                        decoration: InputDecoration(
                          hintText: "请输入价格",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  children: [
                    Text("简介",style: TextStyle(fontSize: 18,),),
                    SizedBox(width: 70,),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: summaryEditingController,
                        decoration: InputDecoration(
                          hintText: "请输入简介",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  children: [
                    Text("封面",style: TextStyle(fontSize: 18,),),
                    SizedBox(width: 70,),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: imageEditingController,
                        decoration: InputDecoration(
                          hintText: "知识分享的封面",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Constant.lineColor,width: .5,style: BorderStyle.solid)),
                ),
                child: Row(
                  children: [
                    Text("下载地址",style: TextStyle(fontSize: 18,),),
                    SizedBox(width: 35,),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: downloadEditingController,
                        decoration: InputDecoration(
                          hintText: "知识分享的下载地址",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  _sunmit();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Constant.miancolor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "提交",
                      style: TextStyle(
                          color: Constant.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _sunmit() async {
      Map<String,dynamic> map={
        "author": authorEditingController.text,
        "title": titleEditingController.text,
        "isOriginal": selectedValue,
        "price":priceEditingController.text,
        "downloadUrl": downloadEditingController.text,
        "cover": imageEditingController.text,
        "summary": summaryEditingController.text
      };
      var result=await DioUtils.instance.postRequest(
          url: ApiHelper.tocontribute,
          data: map
      );
      if(result.success==true){
        Fluttertoast.showToast(msg: "投稿成功，等待审核");
      }else{
        Fluttertoast.showToast(msg:result.message!);
      }
  }
}