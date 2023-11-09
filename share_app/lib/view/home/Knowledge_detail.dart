import 'package:flutter/material.dart';
import 'package:share_app/model/article_model.dart';
import 'package:share_app/model/knowledge_model.dart';

class KnowledgeDetailPage extends StatefulWidget {
  ArticleModel model;
  KnowledgeDetailPage(this.model,{super.key});

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("分享详情"),
      ),
      body: Center(
        child: Text(widget.model.title!),
      ),
    );
  }
}
