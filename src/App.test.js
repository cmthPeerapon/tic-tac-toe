import { act, render, screen } from "@testing-library/react";
import App from "./App";

test("renders tic-tac-toe app", () => {
  render(<App />);
  const linkElement = screen.getByText(/Next Player/i);
  expect(linkElement.innerHTML).toBe("Next Player: ✕");
});

test("click on 2 boxes", () => {
  render(<App />);
  const [leftBox, middleBox] = screen.getAllByRole("cell");

  expect(leftBox.tagName.toLowerCase()).toBe("td");
  expect(leftBox.innerHTML).toBe("");

  act(() => {
    leftBox.click();
  });

  // expect(leftBox.innerHTML).toBe("✕");
  expect(leftBox.innerHTML).toBe("");

  act(() => {
    middleBox.click();
  });

  expect(middleBox.innerHTML).toBe("◯");
});
