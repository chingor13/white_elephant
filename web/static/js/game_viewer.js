class GameViewer extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.gameId = props.gameId
    this.socket = props.socket

    this.channel = this.socket.channel("games:" + this.gameId, {})
    this.channel.join()
      .receive("ok", resp => {
        this.channel.on("item_created", this.addItem.bind(this))
        this.channel.on("item_deleted", this.removeItem.bind(this))
        this.channel.on("item_updated", this.updateItem.bind(this))
      })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  addItem(item) {
    let items = this.state.items
    items.push(item)
    this.setState({items: items})
  }

  removeItem(itemToRemove) {
    let items = this.state.items.filter((item, i) =>
      itemToRemove.id !== item.id
    );
    this.setState({items: items})
  }

  updateItem(itemToUpdate) {
    let items = this.state.items.map((item, i) =>  {
      if(item.id == itemToUpdate.id) {
        return itemToUpdate
      } else {
        return item
      }
    });
    this.setState({items: items})
  }

  render() {
    return (
      <table className="table">
        <thead>
          <tr>
            <th>Item</th>
            <th>Steals</th>
          </tr>
        </thead>
        <tbody>
          {this.state.items.map((item, i) =>
            <GameViewerLine id={item.id} name={item.name} steals={item.steals} />
          )}
        </tbody>
      </table>
    )
  }
}

class GameViewerLine extends React.Component {
  constructor(props) {
    super(props)
    this.state = {name: props.name, steals: props.steals}
  }

  componentWillReceiveProps(props) {
    this.setState({name: props.name, steals: props.steals})
  }

  render() {
    return (
      <tr>
        <td>{this.state.name} ({this.props.id})</td>
        <td>{this.state.steals}</td>
      </tr>
    )
  }
}
export default GameViewer