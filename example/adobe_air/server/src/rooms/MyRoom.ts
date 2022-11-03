import { Room, Client, Delayed } from "colyseus";
import { MyRoomState, Player } from "./schema/MyRoomState";

const TURN_TIMEOUT = 10
const BOARD_WIDTH = 3;

export class MyRoom extends Room<MyRoomState> {

  maxClients = 2;
  randomMoveTimeout: Delayed;

  onCreate () {
    this.setState(new MyRoomState());
    this.onMessage("action", (client, message) => this.playerAction(client, message));
  }

  onJoin (client: Client) {
    this.state.players.set(client.sessionId, true);
    console.log("total players", this.state.players.size);
    if (this.state.players.size === 2) {
      this.state.currentTurn = client.sessionId;
      this.broadcast("game_state", {state: 1, starting_player:this.state.currentTurn});
      const interval = setInterval((): void => {
        this.startGame();
        clearInterval(interval);
      }, 3000);
     
      this.lock();
      //setTimeout(this.startGame, 3000);
      // lock this room for new users
    }else{
      this.broadcast("game_state", {state: 0});
    }
  }

  startGame(){
    this.broadcast("data", {current_turn: this.state.currentTurn });
    this.setAutoMoveTimeout();
  }

  endGame(){
    const interval = setInterval((): void => {
      clearInterval(interval);
      this.broadcast("game_state", {state: 3});
      this.disconnect();
    }, 5000);
  }

  playerAction (client: Client, data: any) {
    if (this.state.winner || this.state.draw) {
      return false;
    }

    if (client.sessionId === this.state.currentTurn) {
      const playerIds = Array.from(this.state.players.keys());

      const index = data.x + BOARD_WIDTH * data.y;

      if (this.state.board[index] === 0) {
        const move = (client.sessionId === playerIds[0]) ? 1 : 2;
        this.state.board[index] = move;

        if (this.checkWin(data.x, data.y, move)) {
          this.state.winner = client.sessionId;
          this.broadcast("result", {winner: this.state.winner, status: 0, line: this.state.winline});
          this.endGame();

        } else if (this.checkBoardComplete()) {
          this.broadcast("game_state", {state: 2});
          this.state.draw = true;
          this.endGame();
        } else {
          // switch turn
          const otherPlayerSessionId = (client.sessionId === playerIds[0]) ? playerIds[1] : playerIds[0];

          this.state.currentTurn = otherPlayerSessionId;
          this.broadcast("data", {current_turn: this.state.currentTurn });
          this.setAutoMoveTimeout();
        }

      }
    }
  }

  setAutoMoveTimeout() {
    if (this.randomMoveTimeout) {
      this.randomMoveTimeout.clear();
    }

    this.randomMoveTimeout = this.clock.setTimeout(() => this.doRandomMove(), TURN_TIMEOUT * 1000);
  }

  checkBoardComplete () {
    return this.state.board
      .filter(item => item === 0)
      .length === 0;
  }

  doRandomMove () {
    const sessionId = this.state.currentTurn;
    for (let x=0; x<BOARD_WIDTH; x++) {
      for (let y=0; y<BOARD_WIDTH; y++) {
        const index = x + BOARD_WIDTH * y;
        if (this.state.board[index] === 0) {
          this.playerAction({ sessionId } as Client, { x, y });
          return;
        }
      }
    }
  }

  checkWin (x:any, y:any, move:any) {
    let won = false;
    let board = this.state.board;

    // horizontal
    for(let y = 0; y < BOARD_WIDTH; y++){
      const i = x + BOARD_WIDTH * y;
      if (board[i] !== move) { break; }
      if (y == BOARD_WIDTH-1) {
        this.state.winline = String("h"  + x);
        console.log("horizontal x = ", x);
        won = true;
      }
    }

    // vertical
    for(let x = 0; x < BOARD_WIDTH; x++){
      const i = x + BOARD_WIDTH * y;
      if (board[i] !== move) { break; }
      if (x == BOARD_WIDTH-1) {
        won = true;
        this.state.winline = String("v"  + y);
        console.log("vertical y = ", y);
      }
    }

    // cross forward
    if(x === y) {
      for(let xy = 0; xy < BOARD_WIDTH; xy++){
        const i = xy + BOARD_WIDTH * xy;
        if(board[i] !== move) { break; }
        if(xy == BOARD_WIDTH-1) {
          won = true;
          this.state.winline = String("d"  + y);
          console.log("d1 y = ", y);
        }
      }
    }

    // cross backward
    for(let x = 0;x<BOARD_WIDTH; x++){
      const y =(BOARD_WIDTH-1)-x;
      const i = x + BOARD_WIDTH * y;
      if(board[i] !== move) { break; }
      if(x == BOARD_WIDTH-1){
        won = true;
        this.state.winline = String("d"  + y);
        console.log("d2  y = ", y);
      }
    }

    return won;
  }

  onLeave (client:Client) {
    console.log(client.sessionId, " left the game :(");
    this.state.players.delete(client.sessionId);

    if (this.randomMoveTimeout) {
      this.randomMoveTimeout.clear()
    }

    let remainingPlayerIds = Array.from(this.state.players.keys());
    if (!this.state.winner && !this.state.draw && remainingPlayerIds.length > 0) {
      this.state.winner = remainingPlayerIds[0];
      this.broadcast("result", {winner: this.state.winner, status: 1});
      this.endGame();
    }
  }

}
