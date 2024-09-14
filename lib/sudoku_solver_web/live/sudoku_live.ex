defmodule SudokuSolverWeb.SudokuLive do
  use SudokuSolverWeb, :live_view
  alias SudokuSolver.Sudoku

  require Logger

  def mount(_params, _session, socket) do
    board = List.duplicate(List.duplicate(0, 9), 9)
    {:ok, assign(socket, board: board, solved_board: nil, error: nil)}
  end

  def handle_event("update_cell", %{"row" => row_str, "col" => col_str, "value" => value_str}, socket) do
    value = case Integer.parse(value_str || "") do
      {num, _} when num in 1..9 -> num
      _ -> 0
    end

    row = String.to_integer(row_str)
    col = String.to_integer(col_str)

    # Add logging to see the updated cell values
    Logger.debug("Updating cell at row: #{row}, col: #{col}, value: #{value}")

    board = List.update_at(socket.assigns.board, row, fn r ->
      List.replace_at(r, col, value)
    end)

    # Log the updated board for debugging
    Logger.debug("Updated board: #{inspect(board)}")

    {:noreply, assign(socket, board: board, solved_board: nil, error: nil)}
  end

  def handle_event("solve", _params, socket) do
    Logger.debug("Attempting to solve the board: #{inspect(socket.assigns.board)}")

    # Run the Sudoku solver asynchronously to avoid blocking LiveView
    task = Task.async(fn -> Sudoku.solve(socket.assigns.board) end)

    case Task.await(task, 10_000) do  # Set a timeout (10 seconds)
      {:ok, solved_board} ->
        {:noreply, assign(socket, solved_board: solved_board, error: nil)}

      :error ->
        {:noreply, assign(socket, error: "No solution found", solved_board: nil)}
    end
  end

  def render(assigns) do
    IO.inspect(assigns.board, label: "Rendering Board")

    ~H"""
    <!-- Your template code goes here -->
    <h1>Sudoku Solver</h1>

    <%= if @error do %>
      <div class="error"><%= @error %></div>
    <% end %>

    <div class="sudoku-board">
      <%= for {row, row_idx} <- Enum.with_index(@board) do %>
        <div class="sudoku-row">
          <%= for {cell, col_idx} <- Enum.with_index(row) do %>
            <input
              type="number"
              min="1"
              max="9"
              value={if cell != 0, do: Integer.to_string(cell), else: ""}
              phx-blur="update_cell"
              phx-value-row={row_idx}
              phx-value-col={col_idx}
              class="sudoku-cell"
            />
          <% end %>
        </div>
      <% end %>
    </div>

    <button phx-click="solve">Solve</button>

    <%= if @solved_board do %>
      <h2>Solution:</h2>
      <div class="sudoku-board">
        <%= for row <- @solved_board do %>
          <div class="sudoku-row">
            <%= for cell <- row do %>
              <div class="sudoku-cell"><%= cell %></div>
            <% end %>
          </div>
        <% end %>
      </div>
    <% end %>
    """
  end
end
