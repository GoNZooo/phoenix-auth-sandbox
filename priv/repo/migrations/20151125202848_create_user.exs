defmodule AuthSandbox.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :encrypted_password, :string

      timestamps
    end

  end
end
