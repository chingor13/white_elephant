import React from 'react'

class SearchForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({value: event.target.value.toUpperCase()});
  }

  handleSubmit(event) {
    window.location.href = "/play/" + this.state.value;
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div className="form-group form-group-lg">
          <label className="sr-only" for="search_key">Game code</label>
          <input id="search_key" className="form-control" placeholder="Game code" type="text" value={this.state.value} onChange={this.handleChange} />
        </div>
        <button className="btn btn-lg btn-info" type="submit">Find A Game</button>
      </form>
    )
  }
}
export default SearchForm
