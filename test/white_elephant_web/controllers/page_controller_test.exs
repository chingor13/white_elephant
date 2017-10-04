defmodule WhiteElephantWeb.PageControllerTest do
  use WhiteElephantWeb.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to White Elephant!"
  end
end
