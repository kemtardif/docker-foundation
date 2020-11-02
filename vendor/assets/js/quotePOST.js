// Variable declaration
var floors = 0;
var basements = 0;
var apartments = 0;
var occupants = 0;
var cages = 0;
var numbersOfElevators = 0;

const server = "https://rocketelevator-env.herokuapp.com";

var error = function(){
	$("#recommended").text(0);
	$("#price").text(0);
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

var residential = function(){ // [OK new]
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
	return data = {
		type: "residential",
		apartments: apartments,
		floors: floors,
		basements: basements
	};
};

var commercial = function () { // [OK new]
	console.log("---------- Commercial ----------");
	if (isNaN(cages) || cages <= 0){
		return false
	}
	return data = {
		type: "commercial",
		cages: cages,
	};
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
	return data = {
		type: "corporate",
		occupants: occupants,
		floors: floors
	};
};

var calculElevators = function () { // [new]
	getElements();
	var getType = $("#type option:selected").val();
	if (getType == "residential") {
		if(residential() == false){
			error();
		} else {
			$.post(server + '/residential', residential(),function(data){
				$("#recommended").text(data.numbersOfElevators);
				numbersOfElevators = data.numbersOfElevators;
			});
		};
	} else if (getType == "commercial"){
		if(commercial() == false){
			error();
		} else {
			$.post(server + '/commercial', commercial(),function(data){
				$("#recommended").text(data.numbersOfElevators);
			});
		};
	} else if (getType == "corporate" || getType == "hybrid"){
		if(corporate() == false){
			error();
		} else {
			$.post(server + '/corporate', corporate(),function(data){
				$("#recommended").html(data.numbersOfElevators);
			});
		};
	}
}

var calculPrice = function () { // [OK]
	var model = $("input[name='models']:checked").attr("id");
	if (model) {
		console.log("---------- model request ----------")
		$.post(server + '/model', {model: model}, (data)=> {
			$("#price").text("$ " + (data.priceU * $("#recommended").html() / 100).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,'));
		});
	} else {
		0;
	};
};

// main function
$(document).ready(function() {
	$("#form input").each(function(){ // add attributes HTML
		$(this).attr("min", "0");
		$(this).attr("value", "0");
		$(this).attr("oninput", "validity.valid||(value='');");
	});
	$("#type").change(function(){ // Hide Form no used
		refresh();
		$("#form > ." + $("#type option:selected").val()).show();	
	});
	$("#form input").change(function(){ // Calcul number of elevators
		calculElevators();
		calculPrice();
	});
	$("input[name='models']").change(function(){ // Calcul price
		calculPrice();
		$("#priceUnit").show();
		$("#priceUnit h4").text("$" + parseInt($("input[name='models']:checked").val()).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,'));

	});
});

