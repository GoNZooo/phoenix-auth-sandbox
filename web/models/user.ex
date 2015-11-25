defmodule AuthSandbox.User do
  use AuthSandbox.Web, :model

  schema "users" do
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(username password)
  @optional_fields ~w(encrypted_password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 5)
  end

  def login_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(username password), ~w())
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3)
    |> validate_length(:password, min: 5)
  end

  def store_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(username encrypted_password), ~w())
  end
end
