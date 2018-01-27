# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

# config :nerves, :firmware,
#   rootfs_overlay: "rootfs_overlay",
#   fwup_conf: "config/fwup.conf"

# Use bootloader to start the main application. See the bootloader
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :bootloader,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!(), ".ssh/id_rsa.pub"))
  ]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  mdns_domain: "origin.local",
  node_name: nil,
  node_host: :mdns_domain

config :nerves_network, regulatory_domain: "ES"

key_mgmt = System.get_env("NERVES_NETWORK_KEY_MGMT") || "WPA-PSK"

config :nerves_network, :default,
  wlan0: [
    ssid: System.get_env("NERVES_NETWORK_SSID"),
    psk: System.get_env("NERVES_NETWORK_PSK"),
    key_mgmt: String.to_atom(key_mgmt)
  ],
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :ui, UiWeb.Endpoint,
  http: [port: 80],
  url: [host: "origin.local", port: 80],
  # url: [host: "192.168.0.102", port: 80],
  secret_key_base: "6ccqlxld2X6JaYZzAXdvjLfsrI9d22Wk6mRJjlm2M39kojzcvZqmSzbVMzHIBVZJ",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Ui.PubSub, adapter: Phoenix.PubSub.PG2]

# config :ui, Ui.Repo,
#   adapter: Sqlite.Ecto2,
#   database: "/root/#{Mix.env()}.sqlite3"
#   pool: 5

# config :ui, ecto_repos: [Ui.Repo]

# import_config "#{Mix.Project.config[:target]}.exs"