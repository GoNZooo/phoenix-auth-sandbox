defmodule AuthSandbox.AuthPlug do
  import Phoenix.Controller, only: [redirect: 2]
  import Plug.Conn, only: [get_session: 2]

  alias AuthSandbox.Router.Helpers
  alias AuthSandbox.Endpoint

  def init(defaults), do: defaults

  def ensure_logged_in(conn, defaults) do
    case get_session(conn, :logged_in) do
      nil ->
        conn |> redirect(to: Helpers.session_path(conn, :new))
      username ->
        conn
    end
  end
end
