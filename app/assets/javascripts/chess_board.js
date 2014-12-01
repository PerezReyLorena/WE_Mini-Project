var NUMBER_OF_COLS = 8,
	NUMBER_OF_ROWS = 8,
	BLOCK_SIZE = 100;

var BLOCK_COLOUR_1 = '#5d420f',
	BLOCK_COLOUR_2 = '#debf83',
	HIGHLIGHT_COLOUR = '#fb0006';

var piecePositions = null;

function set_pieceCode(pieceCode){
    var code = null;
    switch(pieceCode) {
        case "R":
            code = 2
            break;
        case "P":
            code = 0
            break;
        case "N":
            code = 1
            break;
        case "B":
            code = 3
            break;
        case "Q":
            code = 4
            break;
        case "K":
            code = 5
            break;
    }
    return code;
}

function set_TurnCode(turnCode){
    var code = null;
    switch(turnCode) {
        case "W":
            code = 1
            break;
        case "B":
            code = 0
            break;
    }
    return code;
}
var //P = 0,
	//N = 1,
	//R = 2,
	//B = 3,
	//Q = 4,
	//K = 5,
	IN_PLAY = 0,
	TAKEN = 1,
	pieces = null,
	ctx = null,
	json = null,
	canvas = null,
	BLACK_TEAM = 0,
	WHITE_TEAM = 1,
	SELECT_LINE_WIDTH = 5,
	currentTurn = set_TurnCode($('meta[name="turn"]').attr('content'))
	selectedPiece = null,
    from = null,
    to = null;

function screenToBlock(x, y) {
	var block =  {
		"row": Math.floor(y / BLOCK_SIZE),
		"col": Math.floor(x / BLOCK_SIZE)
	};

	return block;
}

function getPieceAtBlockForTeam(teamOfPieces, clickedBlock) {

	var curPiece = null,
		iPieceCounter = 0,
		pieceAtBlock = null;

	for (iPieceCounter = 0; iPieceCounter < teamOfPieces.length; iPieceCounter++) {

		curPiece = teamOfPieces[iPieceCounter];

		if (curPiece.status == "IN_PLAY" &&
				curPiece.col === clickedBlock.col &&
				curPiece.row === clickedBlock.row) {
			curPiece.position = iPieceCounter;

			pieceAtBlock = curPiece;
			iPieceCounter = teamOfPieces.length;
		}
	}

	return pieceAtBlock;
}

function blockOccupiedByEnemy(clickedBlock) {
	var team = (currentTurn === BLACK_TEAM ? json.white : json.black);

	return getPieceAtBlockForTeam(team, clickedBlock);
}


function blockOccupied(clickedBlock) {
	var pieceAtBlock = getPieceAtBlockForTeam(json.black, clickedBlock);

	if (pieceAtBlock === null) {
		pieceAtBlock = getPieceAtBlockForTeam(json.white, clickedBlock);
	}

	return (pieceAtBlock !== null);
}

function getPieceAtBlock(clickedBlock) {

	var team = (currentTurn === BLACK_TEAM ? json.black : json.white);

	return getPieceAtBlockForTeam(team, clickedBlock);
}

function getBlockColour(iRowCounter, iBlockCounter) {
	var cStartColour;

	// Alternate the block colour
	if (iRowCounter % 2) {
		cStartColour = (iBlockCounter % 2 ? BLOCK_COLOUR_1 : BLOCK_COLOUR_2);
	} else {
		cStartColour = (iBlockCounter % 2 ? BLOCK_COLOUR_2 : BLOCK_COLOUR_1);
	}

	return cStartColour;
}

function drawBlock(iRowCounter, iBlockCounter) {
	// Set the background
	ctx.fillStyle = getBlockColour(iRowCounter, iBlockCounter);

	// Draw rectangle for the background
	ctx.fillRect(iRowCounter * BLOCK_SIZE, iBlockCounter * BLOCK_SIZE,
		BLOCK_SIZE, BLOCK_SIZE);

	ctx.stroke();
}

function getImageCoords(pieceCode, bBlackTeam) {
    pieceCode = set_pieceCode(pieceCode)
	var imageCoords =  {
		"x": pieceCode * BLOCK_SIZE,
		"y": (bBlackTeam ? 0 : BLOCK_SIZE)
	};

	return imageCoords;
}

function drawPiece(curPiece, bBlackTeam) {

	var imageCoords = getImageCoords(curPiece.piece, bBlackTeam);

	// Draw the piece onto the canvas
	ctx.drawImage(pieces,
		imageCoords.x, imageCoords.y,
		BLOCK_SIZE, BLOCK_SIZE,
		curPiece.col * BLOCK_SIZE, curPiece.row * BLOCK_SIZE,
		BLOCK_SIZE, BLOCK_SIZE);
}

function removeSelection(selectedPiece) {
	drawBlock(selectedPiece.col, selectedPiece.row);
	drawPiece(selectedPiece, (currentTurn === BLACK_TEAM));
}

function drawTeamOfPieces(teamOfPieces, bBlackTeam) {
	var iPieceCounter;

	// Loop through each piece and draw it on the canvas	
	for (iPieceCounter = 0; iPieceCounter < teamOfPieces.length; iPieceCounter++) {
		drawPiece(teamOfPieces[iPieceCounter], bBlackTeam);
	}
}

function drawPieces() {
	drawTeamOfPieces(json.black, true);
	drawTeamOfPieces(json.white, false);
}

function drawRow(iRowCounter) {
	var iBlockCounter;

	// Draw 8 block left to right
	for (iBlockCounter = 0; iBlockCounter < NUMBER_OF_ROWS; iBlockCounter++) {
		drawBlock(iRowCounter, iBlockCounter);
	}
}

function drawBoard() {
	var iRowCounter;

	for (iRowCounter = 0; iRowCounter < NUMBER_OF_ROWS; iRowCounter++) {
		drawRow(iRowCounter);
	}

	// Draw outline
	ctx.lineWidth = 3;
	ctx.strokeRect(0, 0,
		NUMBER_OF_ROWS * BLOCK_SIZE,
		NUMBER_OF_COLS * BLOCK_SIZE);
}
function Positions(state) {
    json = JSON.parse(state)
}

function selectPiece(pieceAtBlock) {
	// Draw outline
	ctx.lineWidth = SELECT_LINE_WIDTH;
	ctx.strokeStyle = HIGHLIGHT_COLOUR;
	ctx.strokeRect((pieceAtBlock.col * BLOCK_SIZE) + SELECT_LINE_WIDTH,
		(pieceAtBlock.row * BLOCK_SIZE) + SELECT_LINE_WIDTH,
		BLOCK_SIZE - (SELECT_LINE_WIDTH * 2),
		BLOCK_SIZE - (SELECT_LINE_WIDTH * 2));

	selectedPiece = pieceAtBlock;
    from = "f" + selectedPiece.row + "r" + selectedPiece.col;
}

function checkIfPieceClicked(clickedBlock) {
	var pieceAtBlock = getPieceAtBlock(clickedBlock);

	if (pieceAtBlock !== null) {
		selectPiece(pieceAtBlock);
	}
}

function movePiece(clickedBlock, enemyPiece) {
	// Clear the block in the original position
	drawBlock(selectedPiece.col, selectedPiece.row);

	var team = (currentTurn === WHITE_TEAM ? json.white : json.black),
		opposite = (currentTurn !== WHITE_TEAM ? json.white : json.black);

	team[selectedPiece.position].col = clickedBlock.col;
	team[selectedPiece.position].row = clickedBlock.row;

	if (enemyPiece !== null) {
		// Clear the piece your about to take
		drawBlock(enemyPiece.col, enemyPiece.row);
		opposite[enemyPiece.position].status = "TAKEN";
	}

	// Draw the piece in the new position
	drawPiece(selectedPiece, (currentTurn === BLACK_TEAM));

    //switch the turn
	//currentTurn = (currentTurn === WHITE_TEAM ? BLACK_TEAM : WHITE_TEAM);

	selectedPiece = null;
}

function processMove(clickedBlock) {

	var pieceAtBlock = getPieceAtBlock(clickedBlock),
		enemyPiece = blockOccupiedByEnemy(clickedBlock);

	if (pieceAtBlock !== null) {
		removeSelection(selectedPiece); //the to field is already occupied
		checkIfPieceClicked(clickedBlock);
	} else {
        to = "f" + clickedBlock.row + "r" + clickedBlock.col
        var from_to = from + "->" + to;
        $.ajax({
            url: "/moves", // the URL for the moves_path create goes in here
            cache: false,
            type: "POST",
            data: JSON.stringify({game_id: canvas.getAttribute("game_id"), user_id: canvas.getAttribute("user_id"), from_to: from_to}),
            contentType: "application/json",
            datatype: "application/json",
            //return the formatted from_to string to be displayed in the recent moves table
            success: function (json) {
                //the move is valid, so change the position of the figure from 'from' to 'to'
                movePiece(clickedBlock, enemyPiece);
                //update recent moves
                $("#recent_moves").append(json['last_move']);
                //update the turn box
                if (json['game_status'] !== undefined) {
                    $("#status_header").html(json['game_status']);
                }
                $("#op_name").html($("#opponent_name").text()+"'s");
                $("#draw_request").remove();

            },
            error: function(xhr,status,error) {
                alert( "Your move is invalid!");
            }
         });
	}
}

function board_click(ev) {
	var x = ev.pageX - canvas.offsetLeft;
    var y = ev.pageY - canvas.offsetTop;
	var clickedBlock = screenToBlock(x, y);

	if (selectedPiece === null) {
        // select the clicked block (draw a rectangle around it)  if it contains a figure
        // set selected_Piece to the the given figure
		checkIfPieceClicked(clickedBlock);
	} else {
		processMove(clickedBlock);
	}
 }

function draw() {
	// Main entry point got the HTML5 chess board example

	canvas = document.getElementById('chess');
    state = $('meta[name="state"]').attr('content')

	// Canvas supported?
	if (canvas.getContext) {
		ctx = canvas.getContext('2d');

		// Calculdate the precise block size
		BLOCK_SIZE = canvas.height / NUMBER_OF_ROWS;

		// Draw the background
		drawBoard();

        Positions(state);
		// Draw pieces
		pieces = new Image();
		pieces.src = '/assets/pieces.png';
		pieces.onload = drawPieces;

		canvas.addEventListener('click', board_click, false);

	} else {
		alert("Canvas not supported!");
	}
}