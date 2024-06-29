defmodule Brbackend.Client.Gateways.QueryUser do
  @moduledoc """
  This module is used to search the database for a user
  ~ Postgresql Database
  """

  alias Brbackend.Client.Users
  alias Brbackend.Client.ClientUseCase

  @doc """
  The index method will do a search using the client's business rule, then it returns values depending on the search that was made by x user.
  """
  @spec index(integer()) :: {:ok, Users.t()} | {:error, String.t()}
  def index(id) when is_integer(id) do
    case ClientUseCase.query_client_one(id) do
      {:ok, user} -> {:ok, user}
      {:error, query_error} -> {:error, query_error}
    end
  end
end
