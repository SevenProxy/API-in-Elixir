defmodule BrbackendWeb.CreateUserController do
  use BrbackendWeb, :controller
  alias Brbackend.Client.Gateways.CreateUser

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    createUserResult = Enum.into(params, %{}, fn {k, v} -> {String.to_atom(k), v} end)
    result_user = CreateUser.index(createUserResult)
    case result_user do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{message: "Usuário foi criado com sucesso!", details: user})

      {:error, changeset} ->
        errors = translate_errors(changeset)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Usuário não foi criado!", details: errors})
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      String.replace(msg, "%{count}", to_string(opts[:count]))
    end)
  end
end
