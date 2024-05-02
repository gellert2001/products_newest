class VoteCounter{
  int upvote = 0;
  int downvote = 0;
 // bool hasvoted;

  VoteCounter(this.upvote,this.downvote/*, this.hasvoted*/);
  void increaseUpvote(){ upvote++;}
  void increaseDownvote(){downvote++;}
}