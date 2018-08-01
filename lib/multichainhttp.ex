defmodule Multichain.Http do
  @moduledoc false

  @doc false
  def jsonrpccall(method, param) do

    params = %{
      method: method,
      params: param
    }

    case getconfig() do
      {:ok, config} ->
        url = "#{config.protocol}://#{config.host}:#{config.port}"
        headers = [{"Content-type", "application/json"}]
        body = Poison.encode!(params |> Map.put("chain_name", config.chain))
        options = [hackney: [basic_auth: {config.username, config.password}]]

        case HTTPoison.post(url, body, headers, options) do
          # check the status code
          {:ok, result} ->
            case result.status_code do
              200 -> Poison.decode(result.body)
              401 -> {:error, "Unauthorized. The supplied credential is incorrect"}
              error -> {:error, "Error code: #{error}. Reason: #{get_error_msg(result.body)}"}
            end

          _ ->
            {:error, "Cannot connect to Multichain node. Check the server address and port."}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp getconfig do
    port = Application.get_env(:multichain, :port)
    host = Application.get_env(:multichain, :host)
    username = Application.get_env(:multichain, :username)
    password = Application.get_env(:multichain, :password)
    chain = Application.get_env(:multichain, :chain)
    protocol = Application.get_env(:multichain, :protocol)

    if port == nil or username == nil or host == nil or password == nil or chain == nil or
         protocol == nil do
      {:error, "Some of config parameter is not available. Check your config file"}
    else
      {:ok,
       %{
         port: port,
         host: host,
         username: username,
         password: password,
         chain: chain,
         protocol: protocol
       }}
    end
  end

  defp get_error_msg(body) do
    case Poison.decode(body) do
      {:ok, result} -> result["error"]["message"]
      _ -> "Unknown"
    end
  end
end
