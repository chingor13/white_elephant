let Game = {
  init(el, socket) {
    this.socket = socket
    this.el = $(el)
    this.gameId = $(el).data('game')

    // logger
    this.socket.logger = (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) };

    console.log('starting game', this.gameId)

    // attach form listener
    this.el.find('#new_item').on('submit', this._handleSubmit)

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
  },

  _handleSubmit(evt) {
    let itemName = $(this).find("[name='item[name]']").val()
    if(itemName != "") {
      Game.channel.push("create_item", {name: itemName})
    }

    evt.preventDefault()
  },

  addItem(item) {
    console.log('adding item', item)
  }

}
export default Game