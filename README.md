# Multichain

Multichain is a permissioned blockchain platform as a fork from bitcoin protocol. It is very useful to be an immutable ledger system which can be used in various project. Multichain by default provide JSON RPC api interface. This library is a wrapper to the JSON RPC to make easy and simple operation with Multichain instance.


## Installation

1. Add followind dependency into your `mix.exs`

```elixir
def deps do
  [
    {:multichain, "~> 0.1.0"}  
  ]
end
```


2. Get the dependency

```
mix deps.get
```


3. Add your Multichain node configuration into `config.exs`, match the value to your own credential.

```
config :multichain,
  protocol: "http",
  port: "1234",
  host: "188.199.177",
  username: "multichainrpc",
  password: "xxxxxxxxxxxxxxx",
  chain: "chain1"

```

Done! Now you can use it inside your Module.

## How to use

You can now call all of Multichain api in simple way by calling `Multichain.api/2`

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

The docs of this package can be found at [https://hexdocs.pm/multichain](https://hexdocs.pm/multichain).

Multichain complete API can be found [https://www.multichain.com/developers/json-rpc-api/](https://www.multichain.com/developers/json-rpc-api/).

### TODO

Some of common task is a combination of multiple api call. Previously has been implemented in python and nodejs. We should make it here too to simplify common operation.

- [ ] Check balance api
- [ ] Create Address api
- [ ] Publish Stream api
- [ ] Retreive stream api
- [ ] Create new asset
- [ ] Reissue new asset
- [ ] List asset
- FIX STREAM DECODEE


