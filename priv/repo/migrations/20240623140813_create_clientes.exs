defmodule Brbackend.Adapter.Repo.Migrations.CreateClientes do
  use Ecto.Migration

  def change do
    create table(:clientes) do
      add :id, :serial, primary_key: true
      add :username, :string
      add :password, :string
      add :email, :string
      add :creation_date, :utc_datetime
      add :about, :string
      add :avatar, :string

    end
  end
end
