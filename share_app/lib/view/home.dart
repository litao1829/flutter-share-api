import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_app/compnent/item_card.dart';
import 'package:share_app/net/api_helper.dart';
import 'package:share_app/net/dio_utils.dart';
import 'package:share_app/notification/custom_event.dart';
import 'package:share_app/notification/custom_notification.dart';

import '../common/constant.dart';
import '../model/article_model.dart';
import '../model/knowledge_model.dart';
import '../model/login_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  //tabbars数据
  List<String> tabbars=["发现","使用说明"];

  //tab控制器
  TabController? _tabController;

  TextEditingController textcontroller=TextEditingController();

  FocusNode focusNode=FocusNode();

  ScrollController _scrollController=ScrollController();
  List<ArticleModel> datas=[];

  bool isHashMore=false;

  int page=1;
  int pageSize=11;

  String loadingTip="加载中...";

  double x=20;
  double y=20;

  bool returnTop=false;

  String searchValue="";


  //定义一个订阅者
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    //初始化订阅者
    subscription=eventBus.on<CustomEvent>().listen((event) {
      var msg=event.msg;
      createDialog(msg!);
    });

    _tabController=TabController(length: tabbars.length, vsync: this);
    getData();
    ///注册滚动监听
    _scrollController.addListener(() {
      if(_scrollController.position.pixels>50){
        returnTop=true;
      }
      else{
        returnTop=false;
      }
      setState(() {
      });
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
        title: Text("首页",style: TextStyle(fontSize: 24,color: Constant.white,fontWeight: FontWeight.bold),),
        backgroundColor: Constant.miancolor,
      ),
      body: Column(
        children: [
            _buildTabbar(),
            _buildSearch(),
            Expanded(child: _buildBody())
        ],
      ),
    );
  }

  Widget _buildTabbar(){
    return TabBar(
    labelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
        labelColor: Constant.miancolor,
        unselectedLabelColor: Constant.black,
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        controller: _tabController,
        indicatorColor: Constant.miancolor,
        onTap: (index){},
        tabs: tabbars.map((e){
      return Tab(text: e,);
    }).toList());
  }
  Widget _buildSearch(){
    return Container(
      margin: const EdgeInsets.all(10),
      width: 400,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Constant.grey
      ),
      child: TextField(
        controller: textcontroller,
        focusNode: focusNode,
        onSubmitted: (String value){
          focusNode.unfocus();
          if(value!=''){
            searchValue=value;
            datas = datas.where((element) => element.title!.contains(value)).toList();
            isHashMore=false;
            loadingTip="加载完成";
            setState(() {

            });
          }
          else{
            datas.clear();
            page=1;
            getData();
          }
        },
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "请输入搜索内容",
          isCollapsed: true,
          contentPadding: EdgeInsets.all(5),
          prefixIcon: Padding(padding: const EdgeInsets.all(5),
          child: Image.asset("assets/images/search.png",width: 24,height: 24,),),
          prefixIconConstraints: const BoxConstraints(maxHeight: 30,maxWidth: 30)
        ),
      ),
    );
  }
  Widget _buildBody(){
    return Stack(
      children: [
        //注册监听
        NotificationListener<CustomNotification>(
          onNotification: (notification){
              var msg=notification.msg;
              _getItemInfo(notification);
              return true;
          },
          child: RefreshIndicator(
            onRefresh:_onRefresh,
            child: ListView.builder(
              ///当listview内容高度没有充满屏幕时，使用这个属性可以始终实现记载更多功能
              physics: const AlwaysScrollableScrollPhysics(),

              ///控制器
              controller: _scrollController,

              ///子类数量
              itemCount: datas.length+1,

              ///构建子类
              itemBuilder: (context,index){
                if(index<datas.length){
                  ArticleModel model=datas[index];
                  return _buildListItem(model);
                }
                return _getMoreWidget();
              },
            ),
          ),
        ),
        Positioned(
          right: x,
          bottom: y,
          child: GestureDetector(
            onTap: (){
              _scrollController.animateTo(
                0.0, // 设置滚动位置为0，即顶部
                duration: Duration(milliseconds: 500), // 滚动动画的持续时间
                curve: Curves.easeInOut, // 滚动动画的曲线
              );
            },
            onDoubleTap: (){
              createDialog("双击事件弹出信息");
            },
            // onLongPress: (){
            //   createDialog("长按事件弹出信息");
            // },
            onPanDown: (details){
              print("用户手指按下：${details.globalPosition}");

            },
            onPanUpdate: (DragUpdateDetails e){
              print("用户手滑动过程的座标位置：${e.delta.dx}");
              setState(() {

                 x-=e.delta.dx;
                 y-=e.delta.dy;
              });
            },
            onPanEnd: (DragEndDetails e){
              print("用户手指抬起：${e.velocity}");
            },
            child: Visibility(
              visible: returnTop,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Constant.miancolor,
                  borderRadius: BorderRadius.circular(40)
                ),
                child: Icon(Icons.upload,size: 32,color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }


  createDialog(String msg){
    // var time=formatDate(DateTime.now(),[yyyy,'年',mm,'月',dd,'日',hh,'：',mm]);
    showDialog(context: context, builder: (context){
      return AlertDialog(
          content: Container(
            height: 20,
            width: 60,
            alignment: Alignment.center,
            child: Text(msg),
          )
      );
    });

    Future.delayed(Duration(seconds: 1)).then((value) => Navigator.pop(context));
  }

  ///创建item
  _buildListItem(item){
     return ItemCard(item);
  }

  ///初始化数据
  void getData() async {
    List<ArticleModel> data=[];
    Map<String,dynamic> map= {
      "pageNo":page,
      "pageSize":pageSize
    };
    var result=await DioUtils.instance.getRequest(url: ApiHelper.shareList,params:map);
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
      }
      else{
        loadingTip="加载数据...";
        isHashMore=true;
      }
      setState(() {});
    }
  }


  Future<void> _onRefresh() async{
    await Future.delayed(const Duration(seconds: 3),(){
      page=1;
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
            visible: isHashMore,
            child: const CircularProgressIndicator(
              strokeWidth: 1.0,
            ))
          ],
        ));
  }

  void _getItemInfo(CustomNotification notification) {
    createDialog("获取子类item："+notification.msg);
  }
  @override
  void dispose() {

    super.dispose();
    //销毁
    if(subscription!=null){
      subscription.cancel();
    }
  }
}
