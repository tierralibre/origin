defmodule Ui.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    #:ok = setup_db!()

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      #supervisor(Ui.Repo, []),
      supervisor(UiWeb.Endpoint, []),
      supervisor(UiWeb.Presence, []),
      supervisor(Era.System, [])
      # Start your own worker by calling: Ui.Worker.start_link(arg1, arg2, arg3)
      # worker(Ui.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ui.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # @otp_app Mix.Project.config()[:app]

  # def setup_db!() do
  #   IO.puts "setup_db!"
  #   repos = Application.get_env(:ui, :ecto_repos)
  #   IO.inspect repos
    
  #   for repo <- repos do
  #     setup_repo!(repo)
  #     migrate_repo!(repo)
  #   end

  #   :ok
  # end

  # defp setup_repo!(repo) do
  #   db_file = Application.get_env(@otp_app, repo)[:database]

  #   unless File.exists?(db_file) do
  #     :ok = repo.__adapter__.storage_up(repo.config)
  #   end
  # end

  # defp migrate_repo!(repo) do
  #   opts = [all: true]
  #   {:ok, pid, apps} = Mix.Ecto.ensure_started(repo, opts)

  #   migrator = &Ecto.Migrator.run/4
  #   pool = repo.config[:pool]
  #   migrations_path = Path.join(:code.priv_dir(@otp_app) |> to_string, "repo")

  #   migrated =
  #     if function_exported?(pool, :unboxed_run, 2) do
  #       pool.unboxed_run(repo, fn -> migrator.(repo, migrations_path, :up, opts) end)
  #     else
  #       migrator.(repo, migrations_path, :up, opts)
  #     end

  #   pid && repo.stop(pid)
  #   Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  # end
end