import React from 'react'

class GameViewer extends React.Component {
  constructor(props) {
    super(props)
    this.state = { items: props.initialItems }

    const channel = props.socket.channel(`games:${props.gameId}`, {})
    channel.join()
      .receive("ok", (resp) => {
        channel.on("item_created", this.addOrUpdateItem.bind(this))
        channel.on("item_deleted", this.removeItem.bind(this))
        channel.on("item_updated", this.addOrUpdateItem.bind(this))
      })
      .receive("error", (resp) => { console.log("Unable to join", resp) })
  }

  removeItem(itemToRemove) {
    const items = this.state.items.filter((item, i) =>
      itemToRemove.id !== item.id
    )
    this.setState({items})
  }

  addOrUpdateItem(itemToUpdate) {
    let updated = false
    const items = this.state.items.map((item, i) =>  {
      if (item.id === itemToUpdate.id) {
        updated = true
        return itemToUpdate
      } else {
        return item
      }
    })

    if (!updated) {
      items.push(itemToUpdate)
    }
    this.setState({items})
  }

  render() {
    return (
      <div className="gifts">
        {this.state.items.map((item, i) =>
          <GameViewerLine
            key={item.id}
            id={item.id}
            name={item.name}
            steals={item.steals}
            maxSteals={this.props.maxSteals}
          />
        )}
      </div>
    )
  }
}

class GameViewerLine extends React.Component {
  stealsLeft() {
    return this.props.maxSteals - this.props.steals
  }

  render() {
    return (
      <div className="gift" data-steals={this.stealsLeft()}>
        <h3 className="gift-name">{this.props.name}</h3>
        <span className="gift-steals">
          {Array(this.props.steals + 1).join('X ')}
        </span>
      </div>
    )
  }
}
export default GameViewer
