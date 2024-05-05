class VoteCounter{
  int upvote = 0;
  int downvote = 0;
  VoteCounter(this.upvote,this.downvote);
  void increaseUpvote()
  {
    upvote++;
  }
  void increaseDownvote(){downvote++;}
}