import React from "react"
import ReactDOM from "react-dom"
import "./index.css"
import App from "./App"
import 'bootstrap/dist/css/bootstrap.css';

/**
 * @dfinity/agent requires this. Can be removed once it's fixed
 */
window.global = window

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById("root"),
)
