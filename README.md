# Multichain

**TODO: Add description**

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

The docs can be found at [https://hexdocs.pm/multichain](https://hexdocs.pm/multichain).



