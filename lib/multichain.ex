defmodule Multichain do
  @moduledoc """
    This library is a thin wrapper for Multichain JSON RPC. Instead of manually craft HTTP call with all params, we can put the param in config and call one function as interface to all Multichain api.

    How to use


    1. Add dependency
      In your mix.exs:

      ```
          defp deps do
            [
              {:multichain, "~> 0.0.1"}
            ]
          end
      ```

    2. Add config
      Add your node information to your config.exs:

      ```
      config :multichain,
        protocol: "http",
        port: "1234",
        host: "127.0.0.1",
        username: "multichainrpc",
        password: "xxxxxxxxxxxxxxx",
        chain: "chain1"
      ```

    3. Done. You can now call any multichain api using `api/2`
        
        For example you want to call `getinfo` api, you only need to create Map and pass to the function.

      ```
      iex(1)> param = %{method: "getinfo", params: []}
      %{method: "getinfo", params: []}
      iex>(2)> Multichain.api(param)
      {:ok,
      %{
       "error" => nil,
       "id" => nil,
       "result" => %{
         "balance" => 0.0,
         "blocks" => 1001,
         "burnaddress" => "1XXXXXXWjEXXXXXXxiXXXXXXMvXXXXXXUd2fZG",
         "chainname" => "getchain",
         "connections" => 0,
         "description" => "MultiChain awesome",
         "difficulty" => 6.0e-8,
         "errors" => "",
         "incomingpaused" => false,
         "keypoololdest" => 1526642153,
         "keypoolsize" => 2,
         "miningpaused" => false,
         "nodeaddress" => "getchain@188.177.166.55.:1234",
         "nodeversion" => 10004901,
         "paytxfee" => 0.0,
         "port" => 9243,
         "protocol" => "multichain",
         "protocolversion" => 10010,
         "proxy" => "",
         "reindex" => false,
         "relayfee" => 0.0,
         "setupblocks" => 60,
         "testnet" => false,
         "timeoffset" => 0,
         "version" => "1.0.4",
         "walletdbversion" => 2,
         "walletversion" => 60000
       }
      }} 
      ```

    The full api and params you need to pass can be found on official [Multichain API Documentation](https://www.multichain.com/developers/json-rpc-api/). Basically you put the method name
    

  """

  alias Multichain.Http

  @doc """
  This is the function where you can call all individual Multichain API. Only pass the method name as `String` and params as `List`.

  Some of example can be seen below:

  ```
  Multichain.api("listaddresses", ["*", true, 3, -3])

  Multichain.api("getinfo", [])

  Multichain.api("help", [])

  ```

  ```
  iex(1)> Multichain.api("validateaddress", ["1KFjut7GpLN2DSvRrh6UATxYxy5nxYaY7EGhys"])
  {:ok,
   %{
     "error" => nil,
     "id" => nil,
     "result" => %{
       "account" => "",
       "address" => "1KFjut7GpLN2DSvRrh6UATxYxy5nxYaY7EGhys",
       "ismine" => false,
       "isscript" => false,
       "isvalid" => true,
       "iswatchonly" => true,
       "synchronized" => false
     }
   }}

  ```

  """
  def api(method, params) do
    Http.jsonrpccall(method, params)
  end

end
