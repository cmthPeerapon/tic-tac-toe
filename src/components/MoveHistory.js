export function MoveHistory({ gameHistory, timeTravel }) {
  return (
    <div className="ml-20">
      {gameHistory.map((turn, index) => (
        <div key={index} className="w-full">
          <button
            type="button"
            className="w-[140px] text-white bg-gradient-to-br from-purple-600 to-blue-500 hover:bg-gradient-to-bl focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 font-medium rounded-lg text-sm px-3 py-1.5 text-center me-2 mb-2"
            onClick={() => timeTravel(index)}
          >
            {index === 0 ? "Go to game start" : `Go to move #${index}`}
          </button>
        </div>
      ))}
    </div>
  );
}
