defmodule Brbackend.Cache do
  @moduledoc """
  Conection with Redis from cache the requests.
  """
  @pool_name :redix

  @spec set(String.t(), String.t()) :: :ok | {:error, any()}
  def set(key, value) do
    case Redix.start_link() do
      {:ok, _conn} ->
        case Redix.command(@pool_name, ["SET", key, value]) do
          {:ok, _value} -> :ok
          {:error, error} -> {:error, error}
        end
      {:error, error} -> {:error, error}
    end
  end

  @spec get(String.t()) :: {:ok, String.t() | nil} | {:error, any()}
  def get(key) do
    case Redix.start_link() do
      {:ok, _conn} ->
        case Redix.command(@pool_name, ["GET", key]) do
          {:ok, value} -> {:ok, value}
          {:error, error} -> {:error, error}
        end
      {:error, error} ->
        {:error, error}
    end
  end

  @spec increment(String.t()) :: :ok | {:error, any()}
  def increment(key) do
    case Redix.start_link() do
      {:ok, _conn} ->
        case Redix.command(@pool_name, ["INCR", key]) do
          {:ok, _value} -> :ok
          {:error, error} -> {:error, error}
        end
      {:error, error} -> {:error, error}
    end
  end

  @spec expire(String.t(), integer()) :: :ok | {:error, any()}
  def expire(key, seconds) do
    case Redix.start_link() do
      {:ok, _conn} ->
        case Redix.command(@pool_name, ["EXPIRE", key, Integer.to_string(seconds)]) do
          {:ok, _value} -> :ok
          {:error, error} -> {:error, error}
        end
      {:error, error} -> {:error, error}
    end
  end
end
