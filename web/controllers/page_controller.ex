defmodule AuthSandbox.PageController do
  use AuthSandbox.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
