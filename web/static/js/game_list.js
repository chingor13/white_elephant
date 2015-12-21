let classNames = require('classnames');

class GameList extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.maxSteals = props.maxSteals
    this.gameId = props.gameId
    this.socket = props.socket

    // connect to the channel for this game
    this.channel = this.socket.channel("games:" + this.gameId, {})
    this.channel.join()
      .receive("ok", resp => { 
        // listen to channel events and modify the view
        this.channel.on("item_created", this.addOrUpdateItem.bind(this))
        this.channel.on("item_deleted", this.removeItem.bind(this))
        this.channel.on("item_updated", this.addOrUpdateItem.bind(this))
      })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  removeItem(itemToRemove) {
    let items = this.state.items.filter((item, i) =>
      itemToRemove.id !== item.id
    );
    this.setState({items: items})
  }

  addOrUpdateItem(itemToUpdate) {
    let updated = false
    let items = this.state.items.map((item, i) =>  {
      if(item.id == itemToUpdate.id) {
        updated = true
        return itemToUpdate
      } else {
        return item
      }
    });

    if(!updated) {
      items.push(itemToUpdate)
    }
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
              <GameLine channel={this.channel} itemId={item.id} name={item.name} steals={item.steals} maxSteals={this.maxSteals} />
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
    this.maxSteals = props.maxSteals
    this.state = {name: props.name, steals: props.steals}

    // listen for updates to this item
    this.channel = props.channel
  }

  componentWillReceiveProps(props) {
    this.setState({name: props.name, steals: props.steals})
  }

  delete(evt) {
    this.channel.push('remove_item', {id: this.props.itemId})
    evt.preventDefault()
  }

  increment(evt){
    this.channel.push('steal_item', {id: this.props.itemId})
    evt.preventDefault()
  }

  decrement(evt){
    this.channel.push('undo_steal_item', {id: this.props.itemId})
    evt.preventDefault()
  }

  render() {
    return (
      <tr>
        <td>{this.state.name} ({this.props.itemId})</td>
        <td>
          <GameLineDecrementer channel={this.channel} steals={this.state.steals} maxSteals={this.maxSteals} itemId={this.props.itemId} />
          &nbsp;
          {this.state.steals}
          &nbsp;
          <GameLineIncrementer channel={this.channel} steals={this.state.steals} maxSteals={this.maxSteals} itemId={this.props.itemId} />
        </td>
        <td className="text-right"><a className="btn btn-danger" onClick={this.delete.bind(this)}>Delete</a></td>
      </tr>
    )
  }
}

class GameLineIncrementer extends React.Component {
  constructor(props) {
    super(props)
    this.maxSteals = parseInt(props.maxSteals)
    this.channel = props.channel
    this.state = this.propsToState(props)
  }

  componentWillReceiveProps(props) {
    console.log('will receive')
    this.setState(this.propsToState(props))
  }

  handleClick(evt) {
    this.channel.push('steal_item', {id: this.props.itemId})
  }

  propsToState(props) {
    return {
      steals: props.steals,
      shouldRender: parseInt(props.steals) < this.maxSteals
    }
  }

  render() {
    return (
      <a className={classNames("btn", "btn-default", this.state.shouldRender ? '' : 'invisible')} onClick={this.handleClick.bind(this)}>+</a>
    )
  }
}

class GameLineDecrementer extends React.Component {
  constructor(props) {
    super(props)
    this.maxSteals = parseInt(props.maxSteals)
    this.channel = props.channel
    this.state = this.propsToState(props)
  }

  componentWillReceiveProps(props) {
    console.log('will receive')
    this.setState(this.propsToState(props))
  }

  handleClick(evt) {
    this.channel.push('undo_steal_item', {id: this.props.itemId})
  }

  propsToState(props) {
    return {
      steals: props.steals,
      shouldRender: parseInt(props.steals) > 0
    }
  }

  render() {
    return (
      <a className={classNames("btn", "btn-default", this.state.shouldRender ? '' : 'invisible')} onClick={this.handleClick.bind(this)}>-</a>
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