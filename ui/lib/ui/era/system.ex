defmodule Era.System do
    def start_link do
      Supervisor.start_link(
        [
          Era.ProcessRegistry,
          Era.Database,
          Era.Cache
        ],
        strategy: :one_for_one
      )
    end
  end