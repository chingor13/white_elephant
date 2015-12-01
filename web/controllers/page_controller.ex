defmodule WhiteElephant.PageController do
  use WhiteElephant.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
