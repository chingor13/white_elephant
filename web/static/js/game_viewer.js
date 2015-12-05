let classNames = require('classnames');

class GameViewer extends React.Component {
  constructor(props) {
    super(props)
    this.state = {items: props.initialItems}
    this.gameId = props.gameId
    this.socket = props.socket
    this.maxSteals = props.maxSteals

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
      <div className="row">
        {this.state.items.map((item, i) =>
          <GameViewerLine id={item.id} name={item.name} steals={item.steals} maxSteals={this.maxSteals} />
        )}
      </div>
    )
  }
}

class GameViewerLine extends React.Component {
  constructor(props) {
    super(props)
    this.maxSteals = parseInt(props.maxSteals)
    this.state = this.propsToState(props)
  }

  componentWillReceiveProps(props) {
    this.setState(this.propsToState(props))
  }

  propsToState(props) {
    let state = {
      name: props.name,
      statusClass: 'panel-success',
      stealsLeft: this.maxSteals - parseInt(props.steals)
    }
    if(state.stealsLeft <= 0) {
      state.statusClass = 'panel-danger'
    } else if(state.stealsLeft < 2) {
      state.statusClass = 'panel-warning'
    }
    return state
  }

  render() {
    return (
      <div className="col-sm-4">
        <div className={classNames('panel', this.state.statusClass)}>
          <div className="panel-heading">
            <div className="panel-title">
              {this.state.name}
              <span className="pull-right">{this.state.stealsLeft}</span>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
export default GameViewer