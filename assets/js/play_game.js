const PlayGame = {
  socket: null,
  code: null,

  init(el, socket) {
    this.socket = socket
    this.code = el.getAttribute('data-game')

    console.log('starting game', this.code)

    // listen to the channel
    const channel = socket.channel(`games:${this.code}`, {})
    channel.join()
      .receive("ok", (resp) => { console.log("Joined successfully", resp) })
      .receive("error", (resp) => { console.log("Unable to join", resp) })
  },

  addItem(item) {
    console.log('adding item', item)
  }

}
export default PlayGame
