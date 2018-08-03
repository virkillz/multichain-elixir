defmodule Multichain do
  @moduledoc """
    This library is a thin wrapper for Multichain JSON RPC. Instead of manually craft HTTP call with all params, we can put the param in config and call one function as interface to all Multichain api.


    Everything in this module represent lowest Multichain API. Any Multichain API which didn't take any argument can be called directly with format `Multichain.<method_name>/0`.

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

  @doc """
  This function will return list of balance. If not found will return empty list.

  ```
  iex(1)> Multichain.balance("1DEd7MqSxLgpDs9uUipcmfXqWxxpzwiJ8SojmY")
  {:ok,
     %{
       "error" => nil,
       "id" => nil,
       "result" => [
         %{"assetref" => "176-266-23437", "name" => "MMK", "qty" => 1.0e3}
       ]
     }}
  ```

  """
  def balances(address) do
    Http.jsonrpccall("getaddressbalances", [address, 1, true])
  end

  @doc """
  This function will return spesific balance. It will always return number. 

  Any other problem such as wrong address and even connection problem will be translated to zero (0).

  ```
  iex(1)> Multichain.balance("1DEd7MqSxLgpDs9uUipcmfXqWxxpzwiJ8SojmY", "176-266-23437")
  1.0e3
  ```

  """
  def balance(address, assetcode) do
    # TODO do lock unspent! read the api docs and include the locked unspent.
    case Http.jsonrpccall("getaddressbalances", [address, 1, true]) do
      {:ok, result} -> find_asset(result["result"], assetcode)
      _ -> 0
    end
  end

  @doc """
  This function will return spesific balance. It will return tuple with atom and result.

  While `balance/2` will always return number, `balance!/2` will tell you if error happened. 

  ```
  iex(1)> Multichain.balance!("1DEd7MqSxLgpDs9uUipcmfXqWxxpzwiJ8SojcmY", "176-266-23437")
  {:error,
  "Error code: 500. Reason: Invalid address: 1DEd7MqSxLgpDs9uUipcmfXqWxxpzwiJ8SojcmY"
  iex(2)> Multichain.balance!("1DEd7MqSxLgpDs9uUipcmfXqWxxpzwiJ8SojmY", "176-266-23437")
  {:ok, 1.0e3}  
  ```

  """
  def balance!(address, assetcode) do
    case Http.jsonrpccall("getaddressbalances", [address, 1, true]) do
      {:ok, result} -> find_asset!(result["result"], assetcode)
      other -> other
    end
  end

  @doc """
  This function will return list of all asset own by the node's wallet where is_mine is true. 

  ```
  iex(1)> Multichain.nodebalance
  {:ok,
   [
     %{"assetref" => "6196-266-29085", "name" => "MMKP", "qty" => 9.0e7},
     %{"assetref" => "176-266-23437", "name" => "MMK", "qty" => 1.74e5},
     %{"assetref" => "60-266-6738", "name" => "GET", "qty" => 9970.0}
   ]}
  ```

  """
  def nodebalance do
    case Http.jsonrpccall("gettotalbalances", []) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  @doc """
  This function will return configuration of run time parameter of the multichain.

  """
  def getruntimeparams do
    case Http.jsonrpccall("getruntimeparams", []) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  @doc """
  Get the list of Multichain api. 

  """
  def help do
    case Http.jsonrpccall("help", []) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  @doc """
  This function will return information about the connected Multichain's node.

  Usually this is used to check the connection.

  """
  def getinfo do
    case Http.jsonrpccall("getinfo", []) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  @doc """
  This function will return list of all address own by the Node's wallet including each asset list.

  ```
  iex(1)> Multichain.allbalances
  {:ok,
   %{
     "1MRUjzje91QBpnBqkhAdrnCDKHikXFhsPQ4rA2" => [
       %{"assetref" => "6196-266-29085", "name" => "MMKP", "qty" => 9.0e7},
       %{"assetref" => "176-266-23437", "name" => "MMK", "qty" => 1.74e5},
       %{"assetref" => "60-266-6738", "name" => "GET", "qty" => 9970.0}
     ],
     "total" => [
       %{"assetref" => "6196-266-29085", "name" => "MMKP", "qty" => 9.0e7},
       %{"assetref" => "176-266-23437", "name" => "MMK", "qty" => 1.74e5},
       %{"assetref" => "60-266-6738", "name" => "GET", "qty" => 9970.0}
     ]
   }}
  ```

  """
  def allbalances do
    case Http.jsonrpccall("getmultibalances", []) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  # ------------------------------------------------Private Area ----------------------------------

  defp find_asset(list, assetcode) do
    case Enum.filter(list, fn x -> x["assetref"] == assetcode end) do
      [] -> 0
      [ada] -> ada["qty"]
      _ -> 0
    end
  end

  defp find_asset!(list, assetcode) do
    case Enum.filter(list, fn x -> x["assetref"] == assetcode end) do
      [] -> {:ok, 0}
      [ada] -> {:ok, ada["qty"]}
      _ -> {:error, "Unknown Error"}
    end
  end
end
