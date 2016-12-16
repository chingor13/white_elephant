import React from 'react'

class PlayerList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {players: []};
  }

  addPlayer(name) {
    this.state.players.push(name)
    this.setState({players: this.state.players})
  }

  render() {
    return (
      <div>
        <h2>Players</h2>
        <ol>
        {this.state.players.map((player, i) =>
          <li key={"player_" + i}>{player}</li>
        )}
        </ol>
        <PlayerForm addPlayer={this.addPlayer.bind(this)}/>
      </div>
    )
  }
}
export default PlayerList

class PlayerForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};

    this.addPlayer = props.addPlayer;
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value});
  }

  handleSubmit(event) {
    // alert("Adding player: " + this.state.value)

    this.addPlayer(this.state.value)
    this.setState({value: ''})
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div className="form-group">
          <label className="sr-only" htmlFor="player_name">Name</label>
          <input id="player_name" className="form-control" placeholder="Name" type="text" value={this.state.value} onChange={this.handleChange} />
        </div>
        <button className="btn btn-info" type="submit">Add Player</button>
      </form>
    )
  }
}
