export function Board({ currentBoardStatus, updateMove, xTurn, winner }) {
  function makeMove(rowIndex, boxIndex) {
    if (
      rowIndex != null &&
      boxIndex != null &&
      currentBoardStatus[rowIndex][boxIndex] === null &&
      winner === null
    ) {
      const nextBoardStatus = currentBoardStatus.map((row) => [...row]);
      xTurn
        ? (nextBoardStatus[rowIndex][boxIndex] = "✕")
        : (nextBoardStatus[rowIndex][boxIndex] = "◯");
      updateMove(nextBoardStatus);
    }
  }

  const endOrContinue = () => {
    if (winner === null) {
      return `Next Player: ${xTurn ? "✕" : "◯"}`;
    }

    return `The winner is ${winner[1]}`;
  };

  function highlight(rowIndex, boxIndex) {
    let classNameString =
      "text-center border-collapse border border-slate-400 w-10 h-10";

    if (rowIndex != null && boxIndex != null && winner != null) {
      const box = 3 * rowIndex + boxIndex + 1;
      if (winner[0].includes(box)) {
        classNameString =
          "text-center border-collapse border border-slate-400 w-10 h-10 bg-red-400";
      }
    }

    return classNameString;
  }

  return (
    <div>
      <h1 aria-label="game current status">{endOrContinue()}</h1>
      <table>
        <tbody>
          {currentBoardStatus.map((row, rowIndex) => (
            <tr key={`${rowIndex}`} id={`${rowIndex}`}>
              {row.map((box, boxIndex) => (
                <td
                  key={`${rowIndex}_${boxIndex}`}
                  className={`${highlight(rowIndex, boxIndex)}`}
                  id={`${box}`}
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
