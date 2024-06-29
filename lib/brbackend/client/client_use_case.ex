defmodule Brbackend.Client.ClientUseCase do
  @moduledoc """
  """
  import Ecto.Query, only: [from: 2]

  alias Brbackend.Adapter.Repo
  alias Brbackend.Client.Users

  @spec insert_db_one(map()) :: {:ok, Users.t()} | {:error, Ecto.Changeset.t()}
  def insert_db_one(user_params) do
    changeset = Users.changeset(%Users{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @spec query_client_one(integer()) :: Users.t() | any()
  def query_client_one(id) when is_integer(id) do
    query = from(client in Users, where: client.id == ^id)

    case Repo.one(query) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  @spec delete_client_one(integer()) :: {:error, String.t()} | {:ok}
  def delete_client_one(id) when is_integer(id) do
    query = from(client in Users, where: client.id == ^id)

    case Repo.one(query) do
      nil ->
        {:error, "User not found"}
      client ->
        case Repo.delete(client) do
          {:ok, _} ->
            {:ok}
          {:error, _} ->
            {:error, "Failed to delete user"}
        end
    end

  end

end
