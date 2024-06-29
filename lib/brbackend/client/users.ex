defmodule Brbackend.Client.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email, :creation_date, :about, :avatar]}
  schema "clientes" do
    field :username, :string
    field :password, :string
    field :email, :string
    field :creation_date, :utc_datetime
    field :about, :string
    field :avatar, :string

  end

  @type t :: %__MODULE__{
    id: integer(),
    username: String.t(),
    password: String.t(),
    email: String.t(),
    creation_date: DateTime.t(),
    about: String.t(),
    avatar: String.t()
  }

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :about, :avatar, :creation_date])
    |> validate_required([:username, :password, :email])
    |> unique_constraint(:email, name: :clientes_email_key)
  end
end
