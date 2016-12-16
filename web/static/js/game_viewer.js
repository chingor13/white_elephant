import React from 'react'
import classNames from 'classnames'

class GameViewer extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.gameId = props.gameId
    this.socket = props.socket
    this.maxSteals = props.maxSteals

    this.channel = this.socket.channel(`games:${this.gameId}`, {})
    this.channel.join()
      .receive("ok", (resp) => {
        this.channel.on("item_created", this.addOrUpdateItem.bind(this))
        this.channel.on("item_deleted", this.removeItem.bind(this))
        this.channel.on("item_updated", this.addOrUpdateItem.bind(this))
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
            maxSteals={this.maxSteals}
          />
        )}
      </div>
    )
  }
}

class GameViewerLine extends React.Component {
  constructor(props) {
    super(props)
    this.maxSteals = parseInt(props.maxSteals, 10)
    this.state = this.propsToState(props)
  }

  componentWillReceiveProps(props) {
    this.setState(this.propsToState(props))
  }

  propsToState(props) {
    const state = {
      name: props.name,
      statusClass: 'panel-success',
      stealsLeft: this.maxSteals - parseInt(props.steals, 10)
    }
    if (state.stealsLeft <= 0) {
      state.statusClass = 'panel-danger'
    } else if (state.stealsLeft < 2) {
      state.statusClass = 'panel-warning'
    }
    return state
  }

  render() {
    return (
      <div className="gift" data-steals={this.state.stealsLeft} style={{transform: `rotate(${(Math.random() * 6) - 3}deg)`}}>
        <h3 className="gift-name">{this.state.name}</h3>
        <span className="gift-steals">{this.state.stealsLeft}</span>
      </div>
    )
  }
}
export default GameViewer
