defmodule WhiteElephantWeb.PageController do
  use WhiteElephantWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
