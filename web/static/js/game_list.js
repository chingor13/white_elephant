class GameList extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.gameId = props.gameId
    this.socket = props.socket
    this.channel = this.socket.channel("games:" + this.gameId, {})
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
    this.channel.on("new_item", payload => {
      console.log("got new item")
      console.log(payload)
      this.addItem(payload)
    })
  }

  addItem(item) {
    let items = this.state.items
    items.push(item)
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
              <GameLine id={item.id} name={item.name} steals={item.steals} />
            )}
          </tbody>
        </table>
        <ItemForm channel={this.channel} />
      </div>
    );
  }
}

class GameLine extends React.Component {
  render() {
    return (
      <tr>
        <td>{this.props.name}</td>
        <td>
          <a className="btn btn-default">-</a> {this.props.steals} <a className="btn btn-default">+</a>
        </td>
        <td className="text-right"><a className="btn btn-danger">Delete</a></td>
      </tr>
    )
  }
}

class ItemForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {name: ""}
  }
  handleSubmit(evt) {
    this.props.channel.push('create_item', this.state)
    this.setState({name: ""})
    evt.preventDefault()
  }
  handleChange(event) {
    this.setState({name: event.target.value});
  }
  render() {
    let boundHandler = this.handleSubmit.bind(this)
    return (
      <form className="form-inline" onSubmit={boundHandler}>
        <div className="form-group">
          <input className="form-control" value={this.state.name} onChange={this.handleChange.bind(this)} placeholder="New Item"/>
        </div>
        <input type="submit" value="Add Item" className="btn btn-sm btn-success"/>
      </form>
    )
  }
}
export default GameList