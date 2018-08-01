defmodule Multichain do
  @moduledoc """
  Documentation for Multichain.
  """

  alias Multichain.Http

  def api(param) do
    Http.jsonrpccall(param)
  end

  @doc """
  This function is used primarily to test your connection without performing any transaction. It will return information regarding connected multichain network

  """
  def getinfo do
    param = %{
      method: "getinfo",
      params: []
    }

    Http.jsonrpccall(param)
  end

  @doc """
  This function is used primarily to test your connection without performing any transaction. It will return information regarding connected multichain network

  """
  def getruntimeparams do
    param = %{
      method: "getruntimeparams",
      params: []
    }

    Http.jsonrpccall(param)
  end

  def help do
    param = %{
      method: "help",
      params: []
    }

    Http.jsonrpccall(param)
  end
end
