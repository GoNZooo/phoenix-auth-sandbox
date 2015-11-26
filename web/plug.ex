defmodule AuthSandbox.Plug do
  use Plug.Builder

  import AuthSandbox.Router.Helpers, only: [session_path: 2]
  import Phoenix.Controller, only: [redirect: 2]

  alias AuthSandbox.Endpoint

  plug :ensure_logged_in

  def ensure_logged_in(conn, redirect_path \\ session_path(Endpoint, :new)) do
    case get_session(conn, :logged_in) do
      nil ->
        conn
        redirect(conn, to: redirect_path)
      _ ->
        conn
    end
  end
end
