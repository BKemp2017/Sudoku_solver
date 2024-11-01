defmodule SudokuSolverWeb.SudokuLive do
  use SudokuSolverWeb, :live_view
  alias SudokuSolver.Sudoku

  require Logger

  def mount(_params, _session, socket) do
    board = create_board(9)
    {:ok, assign(socket, board: board, solved_board: nil, error: nil, grid_size: 9)}
  end

  def handle_event("update_cell", %{"row" => row_str, "col" => col_str, "value" => value_str}, socket) do
    value = case Integer.parse(value_str || "") do
      {num, _} when num in 1..9 -> num
      _ -> 0
    end

    row = String.to_integer(row_str)
    col = String.to_integer(col_str)

    board = List.update_at(socket.assigns.board, row, fn r ->
      List.replace_at(r, col, value)
    end)

    {:noreply, assign(socket, board: board, solved_board: nil, error: nil)}
  end

  def handle_event("solve", _params, socket) do

    # Run the Sudoku solver asynchronously to avoid blocking LiveView
    task = Task.async(fn -> Sudoku.solve(socket.assigns.board) end)

    case Task.await(task, 10_000) do  # Set a timeout (10 seconds)
      {:ok, solved_board} ->
        {:noreply, assign(socket, solved_board: solved_board, error: nil)}

      :error ->
        {:noreply, assign(socket, error: "No solution found", solved_board: nil)}
    end
  end

  def handle_event("change_grid_size", %{"grid_size" => grid_size_str}, socket) do
    grid_size = String.to_integer(grid_size_str)
    board = create_board(grid_size)
    Logger.debug("Changing grid size to #{grid_size}")
    {:noreply, assign(socket, board: board, solved_board: nil, error: nil, grid_size: grid_size)}
  end

  def render(assigns) do

    ~H"""
    <!-- Your template code goes here -->
    <h1>Sudoku Solver</h1>

    <div>
      <label for="grid-size">Grid Size:</label>
      <select id="grid-size" phx-change="change_grid_size">
        <option value="9" selected={@grid_size == 9}>9x9</option>
        <option value="5" selected={@grid_size == 5}>5x5</option>
        <option value="3" selected={@grid_size == 3}>3x3</option>
      </select>
    </div>

    <%= if @error do %>
      <div class="error"><%= @error %></div>
    <% end %>

    <div class="sudoku-board" style={"grid-template-columns: repeat(#{@grid_size}, 40px);"}>
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
      <div class="sudoku-board" style={"grid-template-columns: repeat(#{@grid_size}, 40px);"}>
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

  defp create_board(size) do
    List.duplicate(List.duplicate(0, size), size)
  end
end
