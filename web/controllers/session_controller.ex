defmodule AuthSandbox.SessionController do
  use AuthSandbox.Web, :controller

  import Ecto.Query

  alias AuthSandbox.User
  alias AuthSandbox.Repo
  alias Comeonin.Bcrypt

  def new(conn, _params) do
    changeset = User.login_changeset(%User{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{})
    username = user_params["username"]
    pw = user_params["password"]

    case Repo.get_by(User, username: user_params["username"]) do
      user ->
        pwhash = user.encrypted_password
        if Bcrypt.checkpw(pw, pwhash) do
          conn
          |> put_session(:logged_in, username)
          |> redirect(to: user_path(conn, :index))
        else
          conn
          |> render "new.html", changeset: changeset
        end
      nil -> render conn, "new.html", changeset: changeset
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:logged_in, nil)
    |> redirect(to: page_path(conn, :index))
  end
end
