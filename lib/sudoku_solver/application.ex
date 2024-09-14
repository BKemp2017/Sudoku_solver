defmodule SudokuSolver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SudokuSolverWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:sudoku_solver, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SudokuSolver.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SudokuSolver.Finch},
      # Start a worker by calling: SudokuSolver.Worker.start_link(arg)
      # {SudokuSolver.Worker, arg},
      # Start to serve requests, typically the last entry
      SudokuSolverWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SudokuSolver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SudokuSolverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
