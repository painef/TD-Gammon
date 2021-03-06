### ALL AGENTS must have a move function defined. This will be called in the play.game.
### each move function should take as arguments 1. current board state, and 2. roll; they should 
    # return the new board state


### AGENT No. 1: vanilla agent! ###
make_vanilla_agent=function(n.hid,f,df,n.in=28){
  weights = init.wgts(n.in,n.hid,1)
  ets = init.zeros(n.in,n.hid,1)
  move=td.move
  return(list(weights=weights,ets=ets,move=move,black.move=td.move.black,f=f,df=df,g=sigmoid,name="VanillaAgent"))
}

td.move=function(board,roll,vanilla_agent){
  moves=unique(find.all.possible.moves(board,roll))
  max = -1
  if (length(moves) <= 0) {
    return(board)
  }
  new_move = moves[[1]]
  for (i in 1:length(moves)){
    curr = fwd.prop(moves[[i]],vanilla_agent$weights,vanilla_agent$f)
    if (curr$a2 > max){
      new_move = moves[[i]]
      max = curr$a2
    }
  }
  return(new_move)
}

td.move.black=function(board,roll,vanilla_agent){
  # Thank you, Brian from the other team, for this line:
  moves=lapply(find.all.possible.moves(flip.board(board),roll),flip.board)
  min = 2
  if (length(moves) <= 0) {
    print('heya')
    return(board)
  }
  new_move = moves[[1]]
  for (i in 1:length(moves)){
    curr = fwd.prop(moves[[i]],vanilla_agent$weights,vanilla_agent$f)
    if (curr$a2 < min){
      new_move = moves[[i]]
      min = curr$a2
    }
  }
  return(new_move)
}

make_random_agent=function(){
  move=random.agent.move
  return(list(move=move,name="RandomAgent"))
}

random.agent.move=function(board, roll, self){
  moves=find.all.possible.moves(board,roll)
  n=length(moves)
  if (n>0) {
    i=sample(n,1)
    board=moves[[i]]
  } else {
    if(verbose)print(paste("unable to play"))
    return(board)
  }
  new.board=moves[[i]]
  return(new.board)
}


make_ai_opponent_agent=function(){
  move=ai_move_2
  return(list(move=move,name="Opponent!"))
}
ai_move_2=function(board,roll,self){
  moves=unique(find.all.possible.moves(board,roll))
  max = -1
  if (length(moves) <= 0) {
    return(board)
  }
  new_move = moves[[1]]
  for (i in 1:length(moves)){
    curr = win_prob(moves[[i]],FALSE)
    if (curr > max){
      new_move = moves[[i]]
      max = curr
    }
  }
  return(new_move)
  }