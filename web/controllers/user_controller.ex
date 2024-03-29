defmodule AuthSandbox.UserController do
  use AuthSandbox.Web, :controller

  alias AuthSandbox.User
  alias Comeonin.Bcrypt

  require Logger

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    current_user = get_session(conn, :logged_in)
    users = Repo.all(User)
    render(conn, "index.html", users: users, current_user: current_user)
  end

  def new(conn, _params) do
    changeset = User.login_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.login_changeset(%User{}, user_params)

    pw = user_params["password"]
    pwhash = Bcrypt.hashpwsalt(pw)
    stored_params = Map.put user_params, "encrypted_password", pwhash
    stored_changeset = User.store_changeset(%User{}, stored_params)

    case Repo.insert(stored_changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
