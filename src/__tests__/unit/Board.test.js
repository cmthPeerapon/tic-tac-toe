import { render, screen } from "@testing-library/react";
import { Board } from "../../components/Board";

const testcases = [
  {
    currentBoardStatus: [
      ["✕", "✕", "✕"],
      ["◯", null, "◯"],
      ["◯", null, null],
    ],
    updateMove: () => void 0,
    xTurn: false,
    winner: [[1, 2, 3], "✕"],
  },
  {
    currentBoardStatus: [
      ["◯", "✕", "✕"],
      ["◯", null, "✕"],
      ["◯", null, null],
    ],
    updateMove: () => void 0,
    xTurn: true,
    winner: [[1, 4, 7], "◯"],
  },
  {
    currentBoardStatus: [
      ["◯", "✕", "✕"],
      ["◯", "◯", "✕"],
      [null, null, null],
    ],
    updateMove: () => void 0,
    xTurn: true,
    winner: null,
  },
];

test.each(testcases)(
  "test game current status display",
  ({ currentBoardStatus, updateMove, xTurn, winner }) => {
    render(
      <Board
        currentBoardStatus={currentBoardStatus}
        updateMove={updateMove}
        xTurn={xTurn}
        winner={winner}
      />
    );
    const header = screen.getByRole("heading", {
      name: /game current status/i,
    });
    expect(header.innerHTML).toBe(
      winner
        ? `The winner is ${winner[1]}`
        : `Next Player: ${xTurn ? "✕" : "◯"}`
    );
  }
);
