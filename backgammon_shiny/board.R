#--------------------------------------------------------
# April 22, 2019
# Fiona paine
# ** code inspired by Shiny Tic-Tac-Toe
# Board is 28 long with the last 4 off the board. 
# indexes 1 through 14 starting in 
# bottom right corner (white home)
# positive numbers are white
# negative numbers are black
# each index is a location that denotes
# the numer of pieces at location
# 25=white bar, 26=white off, 27=black off, 28=black bar

df_board.x = NULL
df_board.y = NULL

# Points on main board
x.points = seq(3,47, by=4)
for (i in x.points){
  df_board.x = c(df_board.x, rep(i, times = 42))
  df_board.y = c(df_board.y, seq(4,7,by=.125), seq(1,3,by=.125))
}

# Points for bearing off
df_board.x = c(df_board.x, rep(52, times = 15), rep(55, times = 15))
df_board.y = c(df_board.y, seq(1.4,7,by=.4), seq(1.4,7,by=.4))

df_board.x = c(df_board.x, 17.5, 20, 22.5, 17.5, 20, 22.5, 
  27.5, 30, 32.5, 27.5, 30, 32.5 )
df_board.y = c(df_board.y, 3.75, 3.75, 3.75, 4.25, 4.25, 4.25, 
  3.75, 3.75, 3.75, 4.25, 4.25, 4.25)  

df_board = data.frame(cbind(df_board.x,df_board.y))
colnames(df_board)<- c("x", "y")

require(plyr)
# initialize board global variable

possible <- function(){
  # Return False if no possible moves
  if(playerB){
    x = find.all.possible.moves(flip.board(board), roll)
    if (length(x)==0){
      return(F)
    }
    else{
      return(T)
    }
    
  }
  else{
  x = find.all.possible.moves(board, roll)
  if (length(x)==0){
    return(F)
  }
  else{
    return(T)
  }
  }
  
}

turn <- function(selected_points) {
  x.move = selected_points$x
  y.move = selected_points$y
  valid2 = !empty(selected_points)
  
  #print("PLAYER B")
  #print(playerB)
  #print(valid2)
  print("Dice moves remaining:")
  print(roll.track)
  
  if (playerB && move){
    # tracking whose turn
    
    return("Player Black should select piece to move")
  }
  else if (!playerB && move) {
    # tracking whose turn
    
    return("Player White should select piece to move")
  }
  
  else if (playerB && !move) {
   # if (valid2){
   # playerB <<- !playerB
   # print("Player Changed")
   # }
    return("Player Black should select where to place the piece")
  }
  
  else if (!playerB && !move) {
   # if (valid2){
   # playerB <<- !playerB
   # print("Player Changed")
   # }
    return("Player White should select where to place the piece")
  }
  
    }


random_turn <- function(){
  if (playerB){
  moves=find.all.possible.moves(flip.board(board),roll)
  board <<- moves[[sample(1:length(moves), 1)]]
    return(flip.board(board))
  }
  else {
    moves=find.all.possible.moves(board,roll)
    board <<- moves[[sample(1:length(moves), 1)]]
    return(board)
  }
}

# Helper function called in board_update
board_move <- function(selected_points){
  x.move = selected_points$x
  y.move = selected_points$y
  # xpoints = c(3,47) by 4, ylim = c(7,5)&c(3,1) by 0.5
  # top of board::: loc = (i-13)*4 + 3 [solve for i]
  
  # we are adding to selected location
  if (!move){  
    print("adding point")
    print(move)
    move <<- !move
    if(y.move >=4.5){
      index = 0.25*(x.move - 3) + 13
      error_str = check_move(index)
      print(error_str)
    
      if(error_str == "Valid move"){
        
        if (board[index] > 0){
          board[index] = board[index] + 1
        }
        else if(board[index] < 0){
          board[index] = board[index] - 1
        }
        else {
          if (playerB){
            board[index] = board[index] - 1
          }
          else{
            board[index] = board[index] + 1
          }
        }
      }
      else if(error_str == "Illegal move"){
        move <<- !move # undo move
        return(board)
      }
      else if(error_str == "Piece to bar"){
        # PIECE TO BAR
        # # 25=white bar, 26=white off, 27=black off, 28=black bar
        if(playerB){
          board[25] = board[25] + 1
          board[index] = -1
        }
        else{
          board[28] = board[28] - 1
          board[index] = 1
          
        }
        return(board)
      }
      
      else {
        move <<- !move # undo move
        return(board)
      }
    }
    
    # bottom of board::: loc = 50 - ((i-1)*4 + 3)  [solve for i]
    else if(y.move <=3.5){
      index = 1 - (x.move - 47)*0.25
      error_str = check_move(index)
      print(error_str)
      if(error_str == "Valid move"){
        if (board[index] > 0){
          board[index] = board[index] + 1
        }
        else if(board[index] < 0){
          board[index] = board[index] - 1
        }
        else {
          if (playerB){
            board[index] = board[index] - 1
          }
          else{
            board[index] = board[index] + 1
          }
        }
      }
      else if(error_str == "Illegal move"){
        move <<- !move # undo move
        return(board)
      }
      else{
        # PIECE TO BAR
        # # 25=white bar, 26=white off, 27=black off, 28=black bar
        if(playerB){
          board[25] = board[25] + 1
          board[index] = -1
        }
        else{
          board[28] = board[28] - 1
          board[index] = 1
          
        }
        return(board)
      }
    }
    
    print("New Board ")
    print(board)
    return(board)
  }
  
  # We are deleting from selected location
  else{
    print("deleting point")
    print(move)
    move <<- !move
    
    # Top of the board
    if(y.move >=5){
      index = 0.25*(x.move - 3) + 13
      pick <<- index
      if (board[index] > 0){
        board[index] = board[index] - 1
      }
      else if(board[index] < 0){
        board[index] = board[index] + 1
      }
      else {
        if (playerB){
          board[index] = board[index] + 1
        }
        else{
          board[index] = board[index] - 1
        }
      }
    }
    
    # bottom of board::: loc = 50 - ((i-1)*4 + 3)  [solve for i]
    else {
      index = 1 - (x.move - 47)*0.25
      pick <<- index
      if (board[index] > 0){
        board[index] = board[index] - 1
      }
      else if(board[index] < 0){
        board[index] = board[index] + 1
      }
      
      else {
        if (playerB){
          board[index] = board[index] + 1
        }
        else{
          board[index] = board[index] - 1
        }
      }
      #print(paste("BOTTOM: ", index))
    }
    
    print("New Board ")
    print(board)
    return(board)
    
  }
  
}  
  

check_off <- function(){
  # Checking if we can legally bear off
    if (playerB){
      return(can.bear.off(flip.board(board)))
    }
    else {
      return(can.bear.off(board))
    }
  }
  
check_move <- function(index){
  # positive numbers are white
  # negative numbers are black
  
  if ((index-pick) == 0){
    return("Valid move")
  }
  # Checking if should be sent to bar
  # Or if legal move
    if (playerB){
      diff = index - pick
      
      if(board[index]>1){
        return("Illegal move")
      }
      else if ( !(diff %in% roll.track)) {
        return("Illegal move")
      }
      else if(board[index]==1){
        roll.track <<- roll.track[-match(diff, roll.track)]
        return("Piece to bar")
      }
      else{
        roll.track <<- roll.track[-match(diff, roll.track)]
        return("Valid move")
        
      }
    }
  
    else {
      print("white")
      diff =  pick - index
      if(board[index] < -1){
        return("Illegal move")
      }
      else if ( !(diff %in% roll.track)) {
        return("Illegal move")
      }
      else if(board[index]== -1){
        roll.track <<- roll.track[-match(diff, roll.track)]
        return("Piece to bar")
      }
      else{
        roll.track <<- roll.track[-match(diff, roll.track)]
        return("Valid move")
        
      }
      
      
      
    }
  
}
  #make.single.move(board, roll[i])
# check_choice(old.b, new.b)
# check_choice <- function(old.b, new.b){
#   if (playerB){
#     b.flip = flip.board(old.b)
#     if(length(roll)==2){
#       moves=c(make.single.move(b.flip,roll[1]), make.single.move(b.flip,roll[2]))
#     }
#     else {
#       moves=c(make.single.move(b.flip,roll[1]), make.single.move(b.flip,roll[2]),
#               make.single.move(b.flip,roll[3]), make.single.move(b.flip,roll[4]))
#     }
#     print("checking move.....")
#     print(flip.board(new.b) %in% moves)
#   return(flip.board(new.b) %in% moves)
#   }
#   else {
#     if(length(roll)==2){
#       moves=c(make.single.move(new.b,roll[1]), make.single.move(new.b,roll[2]))
#     }
#     else {
#       moves=c(make.single.move(new.b,roll[1]), make.single.move(new.b,roll[2]),
#               make.single.move(new.b,roll[3]), make.single.move(new.b,roll[4]))
#     }
#     print("checking move....")
#     print(new.b %in% moves)
#     return(new.b %in% moves)
#   }
# }

board_update <- function(selected_points) {
  
  x.move = selected_points$x
  y.move = selected_points$y
  
  print("x.move  ||  y.move")
  print(x.move)
  print(y.move)
  # TO DO check choice is valid
  #valid = check_choice(selected_points)
  valid = !empty(selected_points)
   
  if(valid && !inactive){
    
   if(x.move > 50 && x.move <53){
     if(check_off()){
       
      board[26] <<- board[26] + 1
      move <<- !move
      
     }
      return(board)
    }
    else if (x.move >53 && x.move < 56){
      if(check_off()){
        # black off
        board[27] <<- board[27] - 1
          move <<- !move

      }
      return(board)
    }
# 25=white bar, 26=white off, 27=black off, 28=black bar    
    else if(y.move > 3.5 && y.move <4.5 && x.move <25){
      print("white bar")
      if (move){
        board[25] <<- board[25] - 1
        move <<- !move
        pick <<- 25
        return(board)
      }
      else {
        board[25] <<- board[25] + 1
        move <<- !move
        return(board)
      }
    }
    else if (y.move >3.5 && y.move < 4.5 && x.move >25){
      print("black bar")
     if(move){
       move <<- !move
       pick <<- 0
       board[28] <<- board[28] + 1
       return(board)
     }
      else{
        move <<- !move
        board[28] <<- board[28] - 1
        return(board)
      }
    }
    else if(x.move < 50){
      board_move(selected_points)
    }
    
  }
  else {
    return(board)
  }
}

 board_plot <- function(selected) {
   
 #  print("Debugging Information")
  #  print(selected)
  # print(board_update(selected))
   
    board <<- board_update(selected)
   

   
    yB = c(1,2,3,2,1 )
    yT = c(7,6,5,6,7 )
    plot(x = c(1,2,3,4,5) , y = yB, type = "l", col = c("red"), 
         xlim = c(1,55), ylim = c(1,7), lwd = 4, tck=0,
         ylab = "", xlab = "")
    
    #Placing pieces on the board
    
    for (i in 1:12){
      if (board[i] != 0){
        if (board[i] > 0){
          colP = "lightgrey"
        }
        if (board[i] < 0){
          colP = "black"
        }
        num = abs(board[i])
        loc = 50 - ((i-1)*4 + 3)
        #print(paste("bottom ",loc))
        for (j in 1:num){
          if (num <= 5){
            points(x = loc, y = .5+(j*.5), pch = 19, cex = 3, col =colP)
          }
          else if (5 < num && num <=9){
          points(x = loc, y = .75+(j*.3), pch = 19, cex = 3, col =colP)
          }
          else {
            points(x = loc, y = .75+(j*.2), pch = 19, cex = 3, col =colP)
          }
         
          
        }
      }
    }
    
    for (i in 13:24){
      if (board[i] != 0){
        
        if (board[i] > 0){
          colP = "lightgrey"
        }
        if (board[i] < 0){
          colP = "black"
        }
        num = abs(board[i])
        loc = (i-13)*4 + 3
        #print(paste("top",loc))
        for (j in 1:num){
          if (num <6){
          points(x = loc, y = 7.5-j*.5, pch = 19, cex = 3, col = colP)
          }
          else if (6 <= num && num <= 9){
            points(x = loc, y = 7.3-j*.3, pch = 19, cex = 3, col = colP)
          }
          else {
            points(x = loc, y = 7.2-j*.2, pch = 19, cex = 3, col = colP)
          }
      }
      }
    }
    # 25=white bar, 26=white off, 27=black off, 28=black bar
    # -----   BAR  -------
    count.grey = 0
    for ( b in 1:3){
      if (count.grey < board[25]){
        points(x = 15+(2.5*b), y = 3.75, pch = 19, cex = 3, col = "grey")
        count.grey = count.grey + 1
      }
      else{
        points(x = 15+(2.5*b), y = 3.75, pch = 1, cex = 3, col = "grey")
      }
    }
    for ( b in 4:6){
      if (count.grey < board[25]){
        points(x = 7.5+(2.5*b), y = 4.25, pch = 19, cex = 3, col = "grey")
        count.grey = count.grey + 1
      }
      else{
        points(x = 7.5+(2.5*b), y = 4.25, pch = 1, cex = 3, col = "grey")
      }
    }
    # **********   BLACK   **********
    count.black = 0
    for ( b in 1:3){
      if (count.black < abs(board[28])){
        points(x = 25+(2.5*b), y = 3.75, pch = 19, cex = 3, col = "black")
        count.black = count.black + 1
      }
      else{
        points(x = 25+(2.5*b), y = 3.75, pch = 1, cex = 3, col = "black")
      }
    }
    for ( b in 4:6){
      if (count.black < abs(board[28])){
        points(x = 17.5 +(2.5*b), y = 4.25, pch = 19, cex = 3, col = "black")
        count.black = count.black + 1
      }
      else{
        points(x = 17.5 +(2.5*b), y = 4.25, pch = 1, cex = 3, col = "black")
      }
    }
    # 25=white bar, 26=white off, 27=black off, 28=black bar
    # ------  OFF ----------
    count.grey = 0
    for ( b in 1:15){
      if (count.grey < board[26]){
        points(x = 52, y = 1+(b*.4), pch = 19, cex = 3, col = "grey")
        count.grey = count.grey + 1
      }
      else{
        points(x = 52, y = 1+(b*.4), pch = 1, cex = 3, col = "grey")
      }
    }
    count.black = 0
    for ( b in 1:15){
      if (count.black < abs(board[27])){
        points(x = 55, y = 1+(b*.4), pch = 19, cex = 3, col = "black")
        count.black = count.black + 1
      }
      else{
        points(x = 55, y = 1+(b*.4), pch = 1, cex = 3, col = "black")
      }
    }
    
    lines(x = 5:9, y = yB, col = "blue", lwd = 4)
    lines(x = 9:13, y = yB, col = "red", lwd = 4)
    lines(x = 13:17, y = yB, col = "blue", lwd = 4)
    lines(x = 17:21, y = yB, col = "red", lwd = 4)
    lines(x = 21:25, y = yB, col = "blue", lwd = 4)
    
    lines(x = 1:5, y = yT, col = "blue", lwd = 4)
    lines(x = 5:9, y = yT, col = "red", lwd = 4)
    lines(x = 9:13, y = yT, col = "blue", lwd = 4)
    lines(x = 13:17, y = yT, col = "red", lwd = 4)
    lines(x = 17:21, y = yT, col = "blue", lwd = 4)
    lines(x = 21:25, y = yT, col = "red", lwd = 4)
    # Vertical Line -- half way
    lines(x = rep(25, times = 9), y = 0:8, col = "black", lwd = 4)
    # Vertical Line -- end board
    lines(x = rep(50, times = 9), y = 0:8, col = "black", lwd = 2)
    
    lines(x = (1:5)+24, y = yB, col = "red", lwd = 4)
    lines(x = (5:9)+24, y = yB, col = "blue", lwd = 4)
    lines(x = (9:13)+24, y = yB, col = "red", lwd = 4)
    lines(x = (13:17)+24, y = yB, col = "blue", lwd = 4)
    lines(x = (17:21)+24, y = yB, col = "red", lwd = 4)
    lines(x = (21:25)+24, y = yB, col = "blue", lwd = 4)
    
    lines(x = (1:5)+24, y = yT, col = "blue", lwd = 4)
    lines(x = (5:9)+24, y = yT, col = "red", lwd = 4)
    lines(x = (9:13)+24, y = yT, col = "blue", lwd = 4)
    lines(x = (13:17)+24, y = yT, col = "red", lwd = 4)
    lines(x = (17:21)+24, y = yT, col = "blue", lwd = 4)
    lines(x = (21:25)+24, y = yT, col = "red", lwd = 4)
    
    
    # Making a box in the middle of the board
    # Horizontal line
    lines(x = seq(15,35,by=1), y = rep(3.5, times = 21), col = "black", lwd = 2, lty=2)  
    lines(x = seq(15,35,by=1), y = rep(4.5, times = 21), col = "black", lwd = 2, lty=2)  
    
    # Verticle line
    lines(x = rep(15, times = 2), y = seq(3.5, 4.5, by = 1), col = "black", lwd = 2, lty=2)  
    lines(x = rep(35, times = 2), y = seq(3.5, 4.5, by = 1), col = "black", lwd = 2, lty=2)       
    
    # Adding dice rolls
    text(x = 5.3, y=4.4, labels= "DICE ROLL", cex = 1.25)
    text(x = 5.3, y=4, labels= toString(roll), cex= 1.75)
    
 }
 
 
 
 
 
 