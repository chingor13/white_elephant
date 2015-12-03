class GameList extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.gameId = props.gameId
    this.socket = props.socket

    // connect to the channel for this game
    this.channel = this.socket.channel("games:" + this.gameId, {})
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    // listen to channel events and modify the view
    this.channel.on("item_created", this.addItem.bind(this))
    this.channel.on("item_deleted", this.removeItem.bind(this))
  }

  addItem(item) {
    let items = this.state.items
    items.push(item)
    this.setState({items: items})
  }

  removeItem(itemToRemove) {
    console.log(itemToRemove, itemToRemove.id)
    let items = this.state.items.filter((item, i) =>
      itemToRemove.id !== item.id
    );
    console.log(items)
    this.setState({items: items})
  }

  render() {
    return (
      <div>
        <table className="table">
          <thead>
            <tr>
              <th>Item</th>
              <th>Steals</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.state.items.map((item, i) =>
              <GameLine channel={this.channel} id={item.id} name={item.name} steals={item.steals} />
            )}
          </tbody>
        </table>
        <ItemForm channel={this.channel} />
      </div>
    );
  }
}

class GameLine extends React.Component {
  constructor(props) {
    super(props)
    this.channel = props.channel
    this.state = {name: props.name, steals: props.steals}
  }
  delete(evt) {
    console.log(this)
    let itemId = this.props.id
    console.log('should delete', this, itemId)
    this.channel.push('remove_item', {id: itemId})
    evt.preventDefault()
  }
  render() {
    return (
      <tr>
        <td>{this.state.name} ({this.props.id})</td>
        <td>
          <a className="btn btn-default">-</a> {this.state.steals} <a className="btn btn-default">+</a>
        </td>
        <td className="text-right"><a className="btn btn-danger" onClick={this.delete.bind(this)}>Delete</a></td>
      </tr>
    )
  }
}

class ItemForm extends React.Component {
  constructor(props) {
    super(props)
    this.channel = props.channel
    this.state = {name: ""}
  }
  handleSubmit(evt) {
    this.channel.push('create_item', this.state)
    this.setState({name: ""})
    evt.preventDefault()
  }
  handleChange(event) {
    this.setState({name: event.target.value});
  }
  render() {
    return (
      <form className="form-inline" onSubmit={this.handleSubmit.bind(this)}>
        <div className="form-group">
          <input className="form-control" value={this.state.name} onChange={this.handleChange.bind(this)} placeholder="New Item"/>
        </div>
        <input type="submit" value="Add Item" className="btn btn-sm btn-success"/>
      </form>
    )
  }
}
export default GameList