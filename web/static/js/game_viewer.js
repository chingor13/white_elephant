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
        {this.props.steals === 3 &&
          <span className="gift-locked">
            <svg version="1.1" width="100" height="100" viewBox="0 0 512 512"><path d="M86.4,480h339.2c12.3,0,22.4-9.9,22.4-22.1V246c0-12.2-10-22-22.4-22H404v-30.9c0-41.5-16.2-87.6-42.6-115.4 C335.1,49.9,297.4,32,256.1,32c-0.1,0-0.1,0-0.1,0c0,0-0.1,0-0.1,0c-41.3,0-79,17.9-105.3,45.6c-26.4,27.8-42.6,73.9-42.6,115.4V224 H89h-2.6C74,224,64,233.9,64,246v211.9C64,470.1,74,480,86.4,480z M161,193.1c0-27.3,9.9-61.1,28.1-80.3l0,0l0-0.3 C206.7,93.9,231,83,255.9,83h0.1h0.1c24.9,0,49.2,10.9,66.8,29.5l0,0.2l-0.1,0.1c18.3,19.2,28.1,53,28.1,80.3V224h-17.5h-155H161 V193.1z"/></svg>

          </span>
        }
      </div>
    )
  }
}
export default GameViewer
