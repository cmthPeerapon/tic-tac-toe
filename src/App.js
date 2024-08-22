import React, { useState } from "react";

function Board({ currentBoardStatus, updateMove, xTurn, winner }) {

  function makeMove(rowIndex, boxIndex) {
    if (rowIndex != null && boxIndex != null && currentBoardStatus[rowIndex][boxIndex] === null && winner === null) {
      const nextBoardStatus = currentBoardStatus.map((row) => [...row]);
      (xTurn) ? nextBoardStatus[rowIndex][boxIndex] = '✕' : nextBoardStatus[rowIndex][boxIndex] = '◯';
      updateMove(nextBoardStatus);
    }
  }

  const endOrContinue = () => {
    if (winner === null) {
      return `Next Player: ${(xTurn) ? '✕' : '◯'}`;
    }

    return `The winner is ${winner[1]}`;
  }

  function highlight(rowIndex, boxIndex) {
    let classNameString = 'text-center border-collapse border border-slate-400 w-10 h-10';

    if (rowIndex != null && boxIndex != null && winner != null) {
      const box = (3 * rowIndex) + boxIndex + 1;
      if ((winner[0]).includes(box)) {
        classNameString = 'text-center border-collapse border border-slate-400 w-10 h-10 bg-red-400';
      }
    }
    
    return classNameString;
  }

  return (
    <div>
      <h1>{endOrContinue()}</h1>
      <table>
        <tbody>
          {currentBoardStatus.map((row, rowIndex) => (
            <tr key={`${rowIndex}`} id={`${rowIndex}`}>
              {row.map((box, boxIndex) => (
                <td
                  key={`${rowIndex}_${boxIndex}`}
                  className={`${highlight(rowIndex, boxIndex)}`} id={`${box}`}
                  onClick={() => makeMove(rowIndex, boxIndex)}
                >
                  {box}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function MoveHistory({ gameHistory, timeTravel }) {
  return (
    <div className="ml-20">
      {
        gameHistory.map((turn, index) => (
          <div key={index} className="w-full">
            <button
              type="button"
              className="w-[140px] text-white bg-gradient-to-br from-purple-600 to-blue-500 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 font-medium rounded-lg text-sm px-3 py-1.5 text-center me-2 mb-2"
              onClick={() => timeTravel(index)}
            >
              {(index === 0) ? 'Go to game start' : `Go to move #${index}`}
            </button>
          </div>
        ))
      }
    </div>
  );
}

function Version() {
  return (
    <div className="absolute bottom-0 right-0 select-none">
      <span>Version 2.0</span>
    </div>
  )
}

function App() {
  const [currentBoardStatus, setCurrentBoardStatus] = useState(Array(3).fill(Array(3).fill(null)));
  const [gameHistory, setGameHistory] = useState([Array(3).fill(Array(3).fill(null))]);
  const [xTurn, setXTurn] = useState(true);
  
  function timeTravel(move) {
    setCurrentBoardStatus(gameHistory[move]);
    setXTurn(move % 2 === 0)
  }

  function updateMove(nextMove) {
    const currentTurn = nextMove.reduce((acc, row) => {
      row.map((box) => (box != null) ? acc += 1 : void(0))
      return acc;
    }, 0);
    const oldGameHistory = gameHistory.slice(0, currentTurn).map((turn) => (
      turn.map((row) => [...row])
    ));
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
      [3, 5, 7]
    ];
    const x = [];
    const o = [];

    currentBoardStatus.map((row, rowIndex) => {
      return row.map((box, boxIndex) => {
        if (box) {
          return (box === '✕')
            ? x.push((3 * rowIndex) + boxIndex + 1)
            : o.push((3 * rowIndex) + boxIndex + 1)
        }
      })
    })

    let winner = null;
    winning.forEach((pattern) => {
      if (pattern.every((move) => x.includes(move))) {
        winner = [pattern, '✕']
      }
      
      if (pattern.every((move) => o.includes(move))) {
        winner = [pattern, '◯']
      }
    })

    return winner;
  }

  return (
    <div className="h-screen flex items-center justify-center">
      <Board currentBoardStatus={currentBoardStatus} updateMove={updateMove} xTurn={xTurn} winner={winner()} />
      <MoveHistory gameHistory={gameHistory} timeTravel={timeTravel} />
      <Version />
    </div>
  );
}

export default App;