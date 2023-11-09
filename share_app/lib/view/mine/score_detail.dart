import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/compnent/score_item.dart';
import 'package:share_app/model/score_log.dart';

import '../../db/sp_utils.dart';
import '../../model/login_model.dart';
import '../../net/api_helper.dart';
import '../../net/dio_utils.dart';

class ScoreDetailPage extends StatefulWidget {
  const ScoreDetailPage({super.key});

  @override
  State<ScoreDetailPage> createState() => _ScoreDetailPageState();
}

class _ScoreDetailPageState extends State<ScoreDetailPage> {
  List<ScoreLog> datas=[];
  String title='';
  LoginModel? model;
  User? user;
  String loadingTip="暂无更多数据...";
  ScrollController _scrollController=ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    title=ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Constant.miancolor,
          centerTitle: true,
          title: Text(title,style: TextStyle(color: Constant.white,fontSize: 20,fontWeight: FontWeight.bold))
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody())
        ],
      ),
    );
  }

  Widget _buildBody(){
    return Stack(
      children: [
        RefreshIndicator(
            child:ListView.builder(
              ///当listview内容高度没有充满屏幕时，使用这个属性可以始终实现记载更多功能
              physics: const AlwaysScrollableScrollPhysics(),
              ///控制器
              controller: _scrollController,
              itemCount: datas.length+1,
              ///构建子类
              itemBuilder: (context,index){
                if(index<datas.length){
                  ScoreLog model=datas[index];
                  return _item(model);
                }
                return _getMoreWidget();
              },) ,
            onRefresh: _onRefresh)
      ],
    );
  }

  Widget _item(ScoreLog scoreLog){
    return ScoreItem(scoreLog);
  }

  getData() async {
    if (SpUtils.getInstance().get(Constant.USER_INFO, "") != '') {
      model = LoginModel.fromJson(
          json.decode(SpUtils.getInstance().get(Constant.USER_INFO, "")!));
      user = model!.user;
      String path = ApiHelper.scoredetail + user!.id.toString();
      var result = await DioUtils.instance.getRequest(url: path, params: null);
      if (result.success == true) {
        for (Map<String, dynamic> map in result.data) {
          ScoreLog scoreLog = ScoreLog.fromJson(map);
          datas.add(scoreLog);
        }
        setState(() {});
      }
    }
    else{
    }
  }

  Future<void> _onRefresh() async{
    await Future.delayed(const Duration(seconds: 3),(){
      datas.clear();
      getData();
      setState(() {});
    });
  }

  Widget _getMoreWidget(){
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(loadingTip,style: const TextStyle(fontSize: 16.0),),
            Visibility(
                visible: false,
                child: const CircularProgressIndicator(
                  strokeWidth: 1.0,
                ))
          ],
        ));
  }
}
