import { render, screen } from "@testing-library/react";
import { Version } from "../../components/Version";

test("check version", () => {
  render(<Version />);
  const version = screen.getByRole("text", { name: /version/i });
  expect(version.innerHTML).toBe("Version 1.1");
});
