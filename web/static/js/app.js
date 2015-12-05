// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import GameList from "./game_list"

import GameViewer from "./game_viewer"

// admin controls
let game = document.getElementById("game_container")
if(game) {
  ReactDOM.render(
    <GameList
      socket={socket}
      gameId={game.getAttribute('data-game-id')}
      maxSteals={game.getAttribute('data-max-steals')}
      initialItems={window.items} />,
    game
  )
}

// viewer
let gameViewer = document.getElementById("game_viewer")
if(gameViewer) {
  ReactDOM.render(
    <GameViewer
      socket={socket}
      gameId={gameViewer.getAttribute('data-game-id')}
      maxSteals={gameViewer.getAttribute('data-max-steals')}
      initialItems={window.items} />,
    gameViewer
  )
}
