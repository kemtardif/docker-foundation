// Variable declaration
var floors = 0;
var basements = 0;
var apartments = 0;
var occupants = 0;
var cages = 0;
var priceElevator = 0;
var numbersOfElevators = 0;

var error = function(){
	$("#recommended").text("0");
	$("#price").text("0");
}

var refresh = function(){ // [OK new] Refresh inputs
	$("#form > div").each(function(){
		$(this).hide();
		$("#form > div > input").val(0);
	})
	error();
};

var getElements = function(){ // [OK new] Get values in the form
	// console.log("---------- GetElements ----------");
	floors = parseInt($("#floors").val());	
	basements = parseInt($("#basements").val());
	apartments = parseInt($("#apartments").val());
	occupants = parseInt($("#occupants").val());
	cages = parseInt($("#cages").val());
};

var numbersOfColumns = function () { // [OK]
	return Math.ceil(floors / 20);	
};

var residential = function(){ // [OK]
	console.log("---------- Residential ----------");
	let liste = [apartments, floors, basements];
	for(i = 0; i < liste.length; i++){
		if (isNaN(liste[i])){
			return false
		};
	}; 
	if(apartments <= 0 || floors <= 1 || basements >= floors || floors > apartments){
		return false
	};
	numbersOfElevators = Math.ceil((apartments / (floors - basements)) / 6) * numbersOfColumns((floors - basements));
	display();
};

var commercial = function () { // [OK]
	console.log("---------- Commercial ----------");
	if (isNaN(cages) || cages <= 0){
		return false
	}
	numbersOfElevators = cages;
	display();
};

var corporate = function () { // [OK]
	console.log("---------- Corporate ----------");
	let liste = [occupants, floors, basements];
	for(i = 0; i < liste.length; i++){
		if (isNaN(liste[i])) {
			return false
		};
	};
	if (occupants <= 0 || floors <= 1 || basements >= floors) {
		return false
	};
	var numbersOfColumn = numbersOfColumns(floors);
	numbersOfElevators = Math.ceil((occupants * (floors) / 1000));
	var elevatorsPerColumn = Math.ceil(numbersOfElevators / numbersOfColumn);
	numbersOfElevators = numbersOfColumn * elevatorsPerColumn;
	display();
};

var calculElevators = function () { // [new]
	getElements();
	var getType = $("#type option:selected").val();
	if (getType == "residential") {
		if(residential() == false){
			error();
		};
	} else if (getType == "commercial"){
		if(commercial() == false){
			error();
		};
	} else if (getType == "corporate" || getType == "hybrid"){
		if(corporate() == false){
			error();
		};
	}
}

var calculPrice = function () { // [OK]
	// console.log("-------- calculPrice --------");
	// console.log("priceElevator : ", priceElevator);
	// console.log("numbersOfElevators : ", numbersOfElevators);
	var price = priceElevator * numbersOfElevators;
	// console.log(price);
	var model = $("input[name='models']").attr("id");
	if (model == "std") {
		return parseInt(price * 1.1);
	} else if (model == "pre") {
		return parseInt(price * 1.13);
	} else if (model == "exc")  {
		return parseInt(price * 1.16);	
	} else {
		0;
	};
};

var display = function () { // [OK]
	$("#price").text(calculPrice);
	$("#recommended").text(numbersOfElevators);
};

// main function
$(document).ready(function() {
	$("#form input").each(function(){ // add attributes HTML
		$(this).attr("min", "0");
		$(this).attr("max", "9999");
		$(this).attr("value", "0");
		$(this).attr("oninput", "validity.valid||(value='');");
	});
	$("#type").change(function(){ // Hide Form no used
		refresh();
		$("#form > ." + $("#type option:selected").val()).show();	
	});
	$("#form input").change(function(){ // Get inputs
		// console.log("---------- Get inputs ----------");
		calculElevators();
	});
	$("input[name='models']").change(function(){ // Get model checked
		priceElevator = parseInt($("input[name='models']:checked").val());
		calculElevators();

	});

});

