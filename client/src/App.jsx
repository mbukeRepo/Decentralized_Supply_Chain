import { EthProvider } from "./contexts/EthContext";
import Intro from "./components/Intro/";
import "./App.css";

function App() {
  return (
    <EthProvider>
      <div id="App">
        <div className="container">
          <Intro />
        </div>
      </div>
    </EthProvider>
  );
}

export default App;
