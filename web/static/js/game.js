import GameList from "./game_list"
let Game = {
  init(el, socket) {
    this.socket = socket
    this.gameId = el.getAttribute('data-game-id')

    // logger
    this.socket.logger = (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) };

    console.log('starting game', this.gameId)

    // listen to the channel
    this.channel = socket.channel("games:" + this.gameId, {})
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    this.channel.on("new_item", payload => {
      console.log("got new item")
      console.log(payload)
      this.addItem(payload)
    })

    // draw the game
    ReactDOM.render(
      <GameList socket={socket} gameId={this.gameId} data={window.items}/>,
      el
    )

  },

  addItem(item) {
    console.log('adding item', item)
  }

}
export default Game