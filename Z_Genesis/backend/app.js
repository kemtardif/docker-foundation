const express = require('express');
const bodyParser = require('body-parser');

var numbersOfColumns = function (floors) { // [OK]
	return Math.ceil(floors / 20);	
};

var residential = function(apartments, floors, basements){ // [OK]
	return Math.ceil((apartments / (floors - basements)) / 6) * numbersOfColumns(floors - basements);
};

var commercial = function (cages) { // [OK]
	return cages;
};

var corporate = function (occupants, floors) { // [OK]
	var numbersOfColumn = numbersOfColumns(floors);
	numbersOfElevators = Math.ceil((occupants * (floors) / 1000));
	var elevatorsPerColumn = Math.ceil(numbersOfElevators / numbersOfColumn);
	return numbersOfColumn * elevatorsPerColumn;
};

var calculPrice = function (model) { // [OK]
	if (model == "std") {
		return Math.round(7565 * 1.1 * 100);
	} else if (model == "pre") {
		return Math.round(12345 * 1.13 * 100);
	} else if (model == "exc")  {
		return Math.round(15400 * 1.16 * 100);
	} else {
		0;
	};
};


const app = express();

app.use((req, res, next) => {
	res.setHeader('Access-Control-Allow-Origin', '*');
	res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content, Accept, Content-Type, Authorization');
	res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
	next();
  });

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.post('/residential',(req, res, next) => {
	console.log("Residential request received");
	let data = req.body;
	let numbersOfElevators = residential(data.apartments, data.floors, data.basements);
	res.send({numbersOfElevators: numbersOfElevators});
	res.status(201).json({message: 'request successfully!'});
});

app.post('/commercial',(req, res, next) => {
	console.log("Commercial request received");
	let data = req.body;
	let numbersOfElevators = commercial(data.cages);
	res.send({numbersOfElevators: numbersOfElevators});
	res.status(201).json({message: 'request successfully!'});
});

app.post('/corporate',(req, res, next) => {
	console.log("Corporate request received");
	let data = req.body;
	let numbersOfElevators = corporate(data.occupants, data.floors);
	res.send({numbersOfElevators: numbersOfElevators});
	res.status(201).json({message: 'request successfully!'});
});

app.post('/model', (req, res, next) =>{
	console.log("Calcul request received");
	let data = req.body;
	console.log(data.model);
	let priceU = calculPrice(data.model);
	res.send({priceU: priceU});
	res.status(201).json({message: 'request successfully!'});
});

module.exports = app;