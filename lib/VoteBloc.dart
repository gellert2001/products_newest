  import 'dart:async';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/foundation.dart';
  import 'package:products_newest/VoteCounter.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:products_newest/main.dart';
  class VoteBloc{
    late VoteCounter votecounter;
    final _voteController = StreamController<VoteCounter>.broadcast();
    Stream<VoteCounter> get voteStream => _voteController.stream;
    late SharedPreferences prefs;
    int id;


    VoteBloc(this.votecounter,this.id);

    void initializeVoteCounter(VoteCounter voteCounter) async {
      WidgetsFlutterBinding.ensureInitialized();
      prefs = await SharedPreferences.getInstance();
      votecounter = voteCounter;

      await _loadVoteCounter();

      _voteController.add(votecounter);
    }

    void increaseUpvote() async{
        votecounter.increaseUpvote();
        _voteController.add(votecounter);
        _saveVoteCounter();
    }

    void increaseDownvote() async {
        votecounter.increaseDownvote();
        _voteController.add(votecounter);
        _saveVoteCounter();
    }
    Future<void> _loadVoteCounter() async {

      final upvote = (prefs.getInt('upvote_$id') ?? 0);
      final downvote = (prefs.getInt('downvote_$id') ?? 0);
      votecounter = VoteCounter(upvote,downvote);
      if (kDebugMode) {
        print('Az adatok sikeresen betöltve: upvote=${votecounter.upvote}, downvote=${votecounter.downvote}');
      }
    }

    Future<void> _saveVoteCounter() async {
      try {
        await prefs.setInt('upvote_$id', votecounter.upvote);
        await prefs.setInt('downvote_$id', votecounter.downvote);
        if (kDebugMode) {
          print('Az adatok sikeresen lementve: upvote=${votecounter.upvote},$id, downvote=${votecounter.downvote}');
        }
      } catch (error) {
        if (kDebugMode) {
          print('Hiba történt az adatok mentése közben: $error');
        }
      }
    }

    void dispose() {
      _saveVoteCounter();
      _voteController.close();
    }
  }