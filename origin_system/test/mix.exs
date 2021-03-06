if Mix.env == :test do
  hash = :os.cmd('git rev-parse HEAD')
    |> to_string
    |> String.trim
  System.put_env("NERVES_FW_VCS_IDENTIFIER", hash)
end

defmodule Test.Mixfile do
  use Mix.Project

  def project do
    [app: :test,
     version: "0.1.0",
     elixir: "~> 1.4",
     archives: [nerves_bootstrap: "~> 0.7"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: Nerves.Bootstrap.add_aliases([]),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: []

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  def deps do
    [
      {:nerves_system_rpi0, path: "../", runtime: false},
      {:nerves_system_test, github: "nerves-project/nerves_system_test"}
    ]
  end

end
