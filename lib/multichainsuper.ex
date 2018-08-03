defmodule Multichain.Super do
  @moduledoc """
    This module combine basic Multichain api to perform common tasks, such as create address and sending asset using external keypairs. 

    This function collection also contain handy function which used by Finance admin such as issue asset, reissue asset, block an address, etc.

    
  """

  alias Multichain.Http

  @doc """
  This function will return information about the connected Multichain's node.

  Usually this is used to check the connection.

  """
  def create_external_address do
    # 1 create keypair
    case Http.jsonrpccall("createkeypairs", [1]) do
      {:ok, result} ->
        [keypair] = result["result"]
         # 2. import address 
        case Http.jsonrpccall("importaddress", [keypair["address"], "", false]) do
          # 3. grant permission sent
          {:ok, _result2} ->
            case Http.jsonrpccall("grant", [keypair["address"], "receive, receive"]) do
              {:ok, _result4} -> {:ok, keypair}
              other -> other
            end

          other ->
            other
        end

      other ->
        other
    end
  end

  def who_can_issue() do
    case Http.jsonrpccall("listpermissions", ["issue"]) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  def print_money(assetname, qty) do
    case who_can_issue() do
      {:ok, result} ->
        if length(result) == 0 do
          {:error, "No issuer founded"}
        else
          [first | _] = result
          issuer = first["address"]

          case Http.jsonrpccall("issuemorefrom", [issuer, issuer, assetname, qty, 0]) do
            {:ok, result} -> {:ok, result}
            error -> error
          end
        end

      error ->
        error
    end
  end

  def transfer(assetcode, from, to, qty, privkey) do
    case Http.jsonrpccall("createrawsendfrom", [from, %{to => %{assetcode => qty}}]) do
      {:ok, %{"error" => nil, "id" => nil, "result" => result}} ->
        case Http.jsonrpccall("signrawtransaction", [result, [], [privkey]]) do
          {:ok, %{"error" => nil, "id" => nil, "result" => %{"complete" => true, "hex" => hex}}} ->
            hex

            case Http.jsonrpccall("sendrawtransaction", [hex]) do
              {:ok, %{"error" => nil, "id" => nil, "result" => trxid}} -> {:ok, trxid}
              other -> other
            end

          other ->
            other
        end

      other ->
        other
    end
  end

  def transfer(assetcode, from, to, qty) do
    case Http.jsonrpccall("sendassetfrom", [from, to, assetcode, qty]) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  def list_internal_address() do
    case Multichain.api("getaddresses", [true]) do
      {:ok, result} ->
        hasil = result["result"] |> Enum.filter(fn x -> x["ismine"] == true end)
        {:ok, %{"count" => length(hasil), "result" => hasil}}

      other ->
        other
    end
  end

  def create_internal_address() do
    case Http.jsonrpccall("getnewaddress", []) do
      {:ok, result} -> result
      error -> error
    end
  end

  def topup(address, assetcode, qty) do
    case Http.jsonrpccall("sendasset", [address, assetcode, qty]) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  def block(address) do
    case Http.jsonrpccall("revoke", [address, "send"]) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  def unblock(address) do
    case Http.jsonrpccall("grant", [address, "send"]) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  def grant_send_receive(address) do
    case Http.jsonrpccall("grant", [address, "send,receive"]) do
      {:ok, result} -> {:ok, result["result"]}
      error -> error
    end
  end

  def blockstatus(address) do
    case Multichain.api("listpermissions", ["*", address]) do
      {:ok, result} -> find_send_permission(result["result"])
      error -> error
    end
  end

  # ------------------------------------------------Private Area ----------------------------------

  defp find_send_permission(list) do
    case Enum.filter(list, fn x -> x["type"] == "send" end) do
      [] -> true
      _ -> false
    end
  end
end
