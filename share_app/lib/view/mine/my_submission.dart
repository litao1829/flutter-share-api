import 'package:flutter/material.dart';
import 'package:share_app/common/constant.dart';
import 'package:share_app/compnent/my_contribute_card.dart';
import 'package:share_app/compnent/submit_item.dart';
import 'package:share_app/model/submit_model.dart';

import '../../compnent/item_card.dart';
import '../../model/article_model.dart';
import '../../net/api_helper.dart';
import '../../net/dio_utils.dart';

class MySubmissionPage extends StatefulWidget {
  const MySubmissionPage({super.key});

  @override
  State<MySubmissionPage> createState() => _MySubmissionPageStateState();
}

class _MySubmissionPageStateState extends State<MySubmissionPage> {
  List<ArticleModel> datas=[];


  int page=1;
  int pageSize=11;

  String loadingTip="加载中...";
  bool isHashMore=false;

  ScrollController _scrollController=ScrollController();
  @override
  void initState() {
    super.initState();
    getData();
    ///注册滚动监听
    _scrollController.addListener(() {
      ///判断当前滚动的位置是否处于可见试图的最底部
      if(_scrollController.position.pixels==
          _scrollController.position.maxScrollExtent){
        if(isHashMore){
          print("上滑加载");
          page++;
          Future.delayed(const Duration(seconds: 2,)).then((value) => getData());
        }
      }
    });
    print(datas.length);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.miancolor,
        centerTitle: true,
        title: Text("我的投稿",style: TextStyle(color: Constant.white,fontSize: 20,fontWeight: FontWeight.bold))
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
                  ArticleModel model=datas[index];
                  return _buildListItem(model);
                }
                return _getMoreWidget();
              },) ,
            onRefresh: _onRefresh)
      ],
    );
  }

  ///创建item
  _buildListItem(item){
    return MyContributeItem(item);
  }

  Future<void> _onRefresh() async{
    await Future.delayed(const Duration(seconds: 3),(){
      page=1;
      datas.clear();
      getData();
      setState(() {});
    });
  }

  getData() async {

    List<ArticleModel> data=[];
    Map<String,dynamic> map= {
      "pageNo":page,
      "pageSize":pageSize
    };
    var result=await DioUtils.instance.getRequest(url: ApiHelper.contribute,params:map);
    if(result.success==true){
      for(Map<String,dynamic>  map in result.data){
        ArticleModel articleModel=ArticleModel.fromJson(map);
        data.add(articleModel);
      }
      if(page==1){
        ///刷新，初始化数据
        datas=data;
      }
      else if(page>1){
        ///加载更多
        datas.addAll(data);
      }
      ///判断是否有更多数据
      if(data.length<pageSize){
        isHashMore=false;
        loadingTip="暂无更多数据...";
        print(loadingTip);
      }
      else{
        loadingTip="加载数据...";
        isHashMore=true;
      }
      setState(() {});
    }
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
                visible: isHashMore,
                child: const CircularProgressIndicator(
                  strokeWidth: 1.0,
                ))
          ],
        ));
  }
}
