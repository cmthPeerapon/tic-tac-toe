import { render, screen } from '@testing-library/react';
import App from './App';

test('renders tic-tac-toe app', () => {
  render(<App />);
  const linkElement = screen.getByText(/Next Player/i);
  expect(linkElement).toBeInTheDocument();
});
