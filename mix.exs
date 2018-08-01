defmodule Multichain.MixProject do
  use Mix.Project

  def project do
    [
      app: :multichain,
      version: "0.0.1",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.2"},
      {:poison, "~> 3.1"}
    ]
  end

  defp package do
  [
    files: ["lib", "mix.exs", "README", "LICENSE*"],
    maintainers: ["Arif Yuliannur"],
    licenses: ["MIT"],
    links: %{"GitHub" => "https://github.com/virkillz/multichain"}
  ]
end
end
