class GameList extends React.Component {
  render() {
    let gameLines = this.props.data.map(function(item) {
      return (
        <GameLine id={item.id} name={item.name} steals={item.steals} />
      )
    })
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
            {gameLines}
          </tbody>
        </table>
        <ItemForm />
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
  render() {
    return (
      <form className="form-inline">
        <div className="form-group">
          <input className="form-control" placeholder="New Item"/>
        </div>
        <input type="submit" value="Add Item" className="btn btn-sm btn-success"/>
      </form>
    )
  }
}
export default GameList