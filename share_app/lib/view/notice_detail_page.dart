import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_app/model/ArticleDetail.dart';
import 'package:share_app/net/api_helper.dart';
import 'package:share_app/net/dio_utils.dart';
import 'package:share_app/utils/channel_utils.dart';

import '../common/constant.dart';

class NoticeDetailPage extends StatefulWidget {
  final String id;
  const NoticeDetailPage(this.id,{super.key});

  @override
  State<NoticeDetailPage> createState() => _NoticeDetailPageState();

}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  ArticleDetail model=ArticleDetail();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChannelUtils.instance.init();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("详情",style: TextStyle(fontSize: 24,color: Constant.white),),
        backgroundColor: Constant.miancolor,
      ),
      body: model.share==null ?
          Container()
          : Container(
        color: Constant.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.share!.title!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Constant.black
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("作者：${model.share!.author}",
                        style: TextStyle(fontSize: 14),),
                      Text("发布人：${model.nickname}",
                        style: TextStyle(fontSize: 14),),
                      Text("下载次数：${model.share!.buyCount}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Constant.grey,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Image(
                image: NetworkImage(model.share!.cover!),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10),
                child: Text(
                  model.share!.summary ?? "",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "下载地址：",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "${model.share!.downloadUrl}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),

            GestureDetector(
              onTap: () async {
                var result = await ChannelUtils.instance
                    .sendData(model.share!.downloadUrl, "copyUrl");
                if (result) {
                  Fluttertoast.showToast(
                      msg: "文本复制成功", gravity: ToastGravity.CENTER);
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  width: 280,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xff44d344),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "复制下载地址",
                    style: TextStyle(
                        color: Constant.white, fontSize: 16),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Text(
                "",
                style: TextStyle(fontSize: 14),
              ),
            ),

          ],
        ),
      )
    );
  }

  ///获取item详情页
  void getData() async{
    var result=await DioUtils.instance.getRequest(url: ApiHelper.shareDetail+widget.id);
    if(result.success==true){
      model=ArticleDetail.fromJson(result.data);
    }else{
      Fluttertoast.showToast(msg: "获取详情异常");
    }
    setState(() {});
    print(result);
  }
}
