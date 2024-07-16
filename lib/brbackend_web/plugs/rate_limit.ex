defmodule BrbackendWeb.RateLimit do
  import Plug.Conn

  alias Brbackend.Cache

  @max_requests 20
  @ttl_seconds 120

  def init(default), do: default

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _) do
    case rate_limited?(conn) do
      :not_limited ->
        conn
      :limited ->
        conn
        |> put_status(:too_many_requests)
        |> put_resp_content_type("application/json")
        |> send_resp(429, "{\"error\": \"Rate limit exceeded\"}")
        |> halt()
    end
  end

  @spec rate_limited?(Plug.Conn.t()) :: :not_limited | :limited
  defp rate_limited?(conn) do
    ip_client = get_ip(conn)
    key = "rate_limit:#{ip_client}"

    case Cache.get(key) do
      {:ok, value} when is_binary(value) ->
        count = String.to_integer(value)
        if count >= @max_requests do
          :limited
        else
          Cache.increment(key)
          :not_limited
        end

      {:ok, _} ->
        Cache.set(key, "1")
        Cache.expire(key, @ttl_seconds)
        :not_limited

      {:error, %Redix.ConnectionError{reason: reason}} ->
        IO.puts("Redis Connection Error: #{inspect(reason)}")
        :not_limited

      {:error, reason} ->
        IO.puts("Redis Error: #{inspect(reason)}")
        :not_limited
    end
  end

  @spec get_ip(Plug.Conn.t()) :: String.t() | nil
  defp get_ip(conn) do
    case Tuple.to_list(conn.remote_ip) do
      [a, b, c, d] -> "#{a}.#{b}.#{c}.#{d}"
      _ -> nil
    end
  end
end
