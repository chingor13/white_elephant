class GameList extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.gameId = props.gameId
    this.socket = props.socket

    // connect to the channel for this game
    this.channel = this.socket.channel("games:" + this.gameId, {})
    this.channel.join()
      .receive("ok", resp => { 
        // listen to channel events and modify the view
        this.channel.on("item_created", this.addItem.bind(this))
        this.channel.on("item_deleted", this.removeItem.bind(this))
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
    this.state = {name: props.name, steals: props.steals}

    // listen for updates to this item
    this.channel = props.channel
    this.channel.on("item_updated", (resp) => {
      if(this.props.id == resp.id) {
        this.setState({name: resp.name, steals: resp.steals})
      }
    })
  }
  componentWillReceiveProps(props) {
    this.state = {name: props.name, steals: props.steals}
  }

  delete(evt) {
    this.channel.push('remove_item', {id: this.props.id})
    evt.preventDefault()
  }

  increment(evt){
    this.channel.push('steal_item', {id: this.props.id})
    evt.preventDefault()
  }

  decrement(evt){
    this.channel.push('undo_steal_item', {id: this.props.id})
    evt.preventDefault()
  }

  render() {
    return (
      <tr>
        <td>{this.state.name} ({this.props.id})</td>
        <td>
          <a className="btn btn-default" onClick={this.decrement.bind(this)}>-</a> {this.state.steals} <a className="btn btn-default" onClick={this.increment.bind(this)}>+</a>
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