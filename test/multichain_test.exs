defmodule MultichainTest do
  use ExUnit.Case
  doctest Multichain

  test "jsonrpc wrong method call" do
    refute Multichain.Http.jsonrpccall(%{"method" => "mbuh"}) == %{ok: "ok"}
  end
end
