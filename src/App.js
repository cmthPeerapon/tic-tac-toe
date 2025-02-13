import { useState } from "react";
import { Version } from "./components/Version";
import { Board } from "./components/Board";
import { MoveHistory } from "./components/MoveHistory";

export function App() {
  // const [componentDidMount, setComponentDidMount] = useState(false);
  const [currentBoardStatus, setCurrentBoardStatus] = useState(
    Array(3).fill(Array(3).fill(null))
  );
  const [gameHistory, setGameHistory] = useState([
    Array(3).fill(Array(3).fill(null)),
  ]);
  const [xTurn, setXTurn] = useState(true);

  function timeTravel(move) {
    setCurrentBoardStatus(gameHistory[move]);
    setXTurn(move % 2 === 0);
  }

  function updateMove(nextMove) {
    const currentTurn = nextMove.reduce((acc, row) => {
      row.map((box) => (box != null ? (acc += 1) : void 0));
      return acc;
    }, 0);
    const oldGameHistory = gameHistory
      .slice(0, currentTurn)
      .map((turn) => turn.map((row) => [...row]));
    setGameHistory([...oldGameHistory, nextMove]);
    setCurrentBoardStatus(nextMove);
    setXTurn(!xTurn);
  }

  const winner = () => {
    const winning = [
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 5, 9],
      [3, 5, 7],
    ];
    const x = [];
    const o = [];

    currentBoardStatus.forEach((row, rowIndex) =>
      row.forEach((box, boxIndex) => {
        if (box) {
          box === "✕"
            ? x.push(3 * rowIndex + boxIndex + 1)
            : o.push(3 * rowIndex + boxIndex + 1);
        }
      })
    );

    let winner = null;
    winning.forEach((pattern) => {
      if (pattern.every((move) => x.includes(move))) {
        winner = [pattern, "✕"];
      }

      if (pattern.every((move) => o.includes(move))) {
        winner = [pattern, "◯"];
      }
    });

    return winner;
  };

  return (
    <div className="h-screen flex items-center justify-center">
      <Board
        currentBoardStatus={currentBoardStatus}
        updateMove={updateMove}
        xTurn={xTurn}
        winner={winner()}
      />
      <MoveHistory gameHistory={gameHistory} timeTravel={timeTravel} />
      <Version />
    </div>
  );
}
