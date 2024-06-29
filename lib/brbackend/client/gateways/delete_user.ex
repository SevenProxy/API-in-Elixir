
defmodule Brbackend.Client.Gateways.DeleteUser do
  alias Brbackend.Client.ClientUseCase

  @spec index(integer()) :: :ok | {:error, any()}
  def index(id) when is_integer(id) do
    case ClientUseCase.delete_client_one(id) do
      {:ok} -> :ok
      {:error, message_error_query} -> {:error, message_error_query}
    end
  end

end
