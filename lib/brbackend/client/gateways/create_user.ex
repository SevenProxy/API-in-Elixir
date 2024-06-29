defmodule Brbackend.Client.Gateways.CreateUser do
  @moduledoc """
  This module is for user creation.
  ~ Postgresql Database
  """
  alias Brbackend.Client.ClientUseCase

  @doc """
  The method "create user" use business rules the cliente class
  """
  @spec index(%{
          :about => any(),
          :avatar => any(),
          :email => any(),
          :password => any(),
          :username => any(),
          optional(any()) => any()
        }) :: any()
  def index(user) do
    create_date_in_user = Map.merge(user, %{:creation_date => DateTime.utc_now() |> DateTime.add(30 * 60, :second)})
    create_date_in_user
    |> atomize_keys()
    |> ClientUseCase.insert_db_one()
  end

  @spec atomize_keys(map()) :: map()
  defp atomize_keys(map) do
    map
    |> Enum.map(fn {k, v} -> {atomize_key(k), v} end)
    |> Enum.into(%{})
  end

  defp atomize_key(k) when is_atom(k), do: k
  defp atomize_key(k) when is_binary(k), do: String.to_existing_atom(k)
end
