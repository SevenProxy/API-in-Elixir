
defmodule BrbackendWeb.DeleteUserController do
  use  BrbackendWeb, :controller
  alias Brbackend.Client.Gateways.DeleteUser

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {integer_id, ""} ->
        query_delete_user = DeleteUser.index(integer_id)
        case query_delete_user do
          :ok ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Usuário foi deletado com sucesso!"})
          {:error, message_error_query} ->
            conn
            |> put_status(:not_found)
            |> json(%{details: message_error_query})
        end
      :error ->
        conn
        |> put_status(:bad_request)
        |> json(%{details: "O parâmetro ID deve ser do tipo número/inteiro."})
    end
  end
end
