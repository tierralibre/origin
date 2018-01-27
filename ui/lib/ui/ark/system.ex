defmodule Ark.System do
    def start_link do
      Supervisor.start_link(
        [
          Ark.ProcessRegistry,
          Ark.Database,
          Ark.Cache
        ],
        strategy: :one_for_one
      )
    end
  end