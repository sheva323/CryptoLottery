import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useAccount } from "wagmi";
import { ChakraProvider } from "@chakra-ui/react";
import { Attestooooooor } from "./components";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import LoginPage from "./pages/loginPage";
import HomePage from "./pages/homePage";
import Navbar from "./components/navBar";
export function App() {
  /**
   * Wagmi hook for getting account information
   * @see https://wagmi.sh/docs/hooks/useAccount
   */
  const { isConnected } = useAccount();

  return (
    // <>
    //   <h1>OP Starter Project</h1>

    //   {/** @see https://www.rainbowkit.com/docs/connect-button */}

    //   {isConnected && (
    //     <>
    //       <hr />
    //       <Attestooooooor />
    //       <hr />
    //     </>
    //   )}
    // </>
    <ChakraProvider>
      <Router>
        <Navbar />
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<HomePage />} />
        </Routes>
      </Router>
    </ChakraProvider>
  );
}
