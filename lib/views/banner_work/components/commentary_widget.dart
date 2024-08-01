import 'package:flutter/material.dart';
import 'package:sport_social_mobile_mock/models/match_commentary_model.dart';
import 'package:sport_social_mobile_mock/services/live_game_service.dart';
import 'package:sport_social_mobile_mock/services/service_locator.dart';

class CommentaryWidget extends StatefulWidget {
  final bool isDragging;
  const CommentaryWidget({super.key, this.isDragging = false});

  @override
  CommentaryWidgetState createState() => CommentaryWidgetState();
}

class CommentaryWidgetState extends State<CommentaryWidget> {
  bool isDragging = false;
  final dataMockService = ServiceLocator.get<LiveGameService>();

  @override
  void initState() {
    super.initState();
    isDragging = widget.isDragging;
  }

  @override
  void didUpdateWidget(covariant CommentaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(isDragging != widget.isDragging) {
      setState(() {
        isDragging = widget.isDragging;
      });
    }
  }


  Widget _getCommentaryItem(MatchCommentaryModel commentary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      padding: const EdgeInsets.all(3.0),      
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF606580), width: 1.0),
          borderRadius: BorderRadius.circular(3.0)),
      child: Row(
        children: [
          Text(
            commentary.time,
            style: const TextStyle(fontSize: 10.0, color: Color(0xFF8699E4)),
          ),
          const SizedBox(width: 3.0),
          Expanded(
              child: Column(
            children: [
              Text(
                commentary.message,
                style: const TextStyle(fontSize: 10.0, color: Colors.white),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _getCommentaryList(List<MatchCommentaryModel> lstData) {
    return ListView.builder(
            itemCount: lstData.length,          
            padding: EdgeInsets.zero,  
            itemBuilder: (context, index) {
              return _getCommentaryItem(lstData[index]);
            });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dataMockService.commentaryNotifier,
        builder: (context, commentaries, child) {
          return _getCommentaryList(commentaries);
        });
  }
}
