defmodule BrbackendWeb.QueryUserController do
  use BrbackendWeb, :controller
  alias Brbackend.Client.Gateways.QueryUser

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {integer_id, ""} ->
        query_result = QueryUser.index(integer_id)
        case query_result do
          {:ok, user} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Informações do usuário foram encontradas.", details: user})

          {:error, error_query} ->
            conn
            |> put_status(:not_found)
            |> json(%{details: error_query})
        end

      :error ->
        conn
        |> put_status(:bad_request)
        |> json(%{details: "O parâmetro ID deve ser do tipo número/inteiro."})
    end
  end
end
