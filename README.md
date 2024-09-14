<<<<<<< HEAD
# Sudoku Solver

Welcome to the **Sudoku Solver**! This project is a web-based Sudoku puzzle solver built using the Elixir programming language, the Phoenix LiveView framework, and Tailwind CSS for styling. It allows users to manually input Sudoku puzzle numbers and automatically solve the puzzle with the click of a button.

![image](https://github.com/user-attachments/assets/64aa4a0e-ebfc-4a7c-96f1-9eabdd1d0125)
 <!-- Replace with actual image link -->

## Features

- **Grid Input**: Users can manually input Sudoku numbers into a 9x9 grid.
- **Real-Time Validation**: The solver ensures that each input fits the Sudoku rules.
- **Instant Solver**: A quick and efficient solver function that fills in the missing numbers.
- **Responsive UI**: A clean, responsive design powered by Tailwind CSS.
- **Phoenix LiveView**: No need to refresh the page, all changes happen in real-time.

## Installation

### Prerequisites

- Elixir and Phoenix installed on your system.
- PostgreSQL (if using a database; optional for this project).
- Node.js for managing assets (Tailwind CSS, etc.).

### Steps to Run the Application

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/sudoku_solver.git
    ```

2. Navigate into the project directory:

    ```bash
    cd sudoku_solver
    ```

3. Install dependencies:

    ```bash
    mix deps.get
    ```

4. Install Node.js dependencies for Tailwind CSS:

    ```bash
    cd assets && npm install
    ```

5. Compile the assets:

    ```bash
    npm run deploy
    ```

6. Go back to the root directory and start the Phoenix server:

    ```bash
    cd ..
    mix phx.server
    ```

7. Open your browser and go to `http://localhost:4000`.

## Usage

### Inputting Sudoku Numbers

- You will see a 9x9 grid where you can enter numbers between `1` and `9`. 
- Each cell allows only valid Sudoku numbers.
- The grid will automatically validate your input on the client side.

### Solving the Puzzle

- After you have entered your Sudoku puzzle numbers, simply click the "Solve" button.
- The system will calculate the solution and display it below the grid.

### Example

Here’s an example of a partially completed Sudoku grid:

![image](https://github.com/user-attachments/assets/03f8c484-2478-47bc-9fa5-582138d18bab)

 <!-- Replace with actual image link -->

## How It Works

### Backtracking Solver Algorithm

This project uses a **backtracking algorithm** to solve the Sudoku puzzle. Here's a simplified breakdown of the process:

1. **Find Empty Cell**: The solver checks for empty cells (cells with `0`).
2. **Test Numbers**: It tries numbers from `1` to `9` in the empty cell.
3. **Check Validity**: For each number, it checks whether the number fits the Sudoku rules (row, column, and subgrid).
4. **Recursion**: If a valid number is found, it moves to the next empty cell. If no valid number is found, it backtracks and tries a different number.
5. **Solution**: Once all empty cells are filled, the puzzle is solved.

![image](https://github.com/user-attachments/assets/771d36ae-2578-47a1-baba-c3f95d16c92b)


### Tailwind CSS Styling

Tailwind CSS is used to style the Sudoku grid and input fields. Each cell has custom dimensions to ensure that the numbers are visible and easy to input.

Here's the grid structure:

```css
.sudoku-board {
  display: grid;
  grid-template-columns: repeat(9, 40px);
  grid-gap: 5px;
  margin-bottom: 20px;
}

.sudoku-cell {
  width: 40px;
  height: 40px;
  text-align: center;
  font-size: 20px;
  border: 1px solid #ccc;
}
=======
# SudokuSolver

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
>>>>>>> 4840860 (Initial commit: Sudoku solver with larger grid and input styling")
