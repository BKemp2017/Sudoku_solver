defmodule SudokuSolver.Sudoku do
  @moduledoc """
  This module is responsible for solving the sudoku puzzle.
  """

  @doc """
  Solves the sudoku puzzle.
  """
  @spec solve(board :: list(list(integer()))) :: {:ok, list(list(integer()))} | :error
  def solve(board) do
    IO.inspect(board, label: "Solving board")

    case find_empty_cell(board) do
      nil ->
        IO.puts("Solution found!")
        {:ok, board}  # Solved board

      {row, col} ->
        Enum.reduce_while(1..9, :error, fn num, _acc ->
          if valid?(board, num, {row, col}) do
            new_board = List.update_at(board, row, fn r ->
              List.replace_at(r, col, num)
            end)

            case solve(new_board) do
              {:ok, solved_board} ->
                {:halt, {:ok, solved_board}}
              :error ->
                {:cont, :error}
            end
          else
            {:cont, :error}
          end
        end)
    end
  end

  defp find_empty_cell(board) do
    Enum.with_index(board)
    |> Enum.reduce_while(nil, fn {row, i}, _acc ->
      case Enum.find_index(row, &(&1 == 0)) do
        nil -> {:cont, nil}
        j -> {:halt, {i, j}}
      end
    end)
  end

  defp valid?(board, num, {row, col}) do
    row_values = Enum.at(board, row)
    col_values = Enum.map(board, fn r -> Enum.at(r, col) end)

    !Enum.member?(row_values, num) &&
      !Enum.member?(col_values, num) &&
      !in_subgrid?(board, num, {row, col})
  end

  defp in_subgrid?(board, num, {row, col}) do
    start_row = 3 * div(row, 3)
    start_col = 3 * div(col, 3)

    subgrid_values =
      for i <- start_row..(start_row + 2), j <- start_col..(start_col + 2), into: [] do
        Enum.at(Enum.at(board, i), j)
      end

    Enum.member?(subgrid_values, num)
  end
end
