# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Draw the chess board
canvas = document.getElementById "chess_board"
context = canvas.getContext "2d"
context.fillStyle = "black"
context.fillRect 0, 0, 60, 60
context.stroke