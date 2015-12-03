class GameList extends React.Component {
  render() {
    let gameLines = this.props.data.map(function(item) {
      return (
        <GameLine id={item.id} name={item.name} steals={item.steals} />
      )
    })
    return (
      <table className="table">
        <thead>
          <tr>
            <th>Item</th>
            <th>Steals</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {gameLines}
        </tbody>
      </table>
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
export default GameList