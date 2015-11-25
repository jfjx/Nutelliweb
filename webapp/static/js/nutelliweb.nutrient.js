function Nutrient()
{
	
	this.myChart;
	this.chartData = {
		labels: ["Fat", 
			"Omega6FattyAcid", 
			"Omega3Fatty", 
			"Protein", 
			"Water", 
			"VitaminA", 
			"VitaminD", 
			"VitaminE", 
			"VitaminK", 
			"VitaminC", 
			"Thiamin", 
			"Riboflavin", 
			"Niacin", 
			"VitaminB6", 
			"Folate", 
			"VitaminB12", 
			"Pantothenic", 
			"Calcium", 
			"Phosphorus", 
			"Sodium", 
			"Potassium", 
			"Magnesium", 
			"Iron", 
			"Zinc", 
			"Copper", 
			"Fluoride", 
			"Manganese", 
			"Seleniu"],
		datasets: [
			{
				label: "My First dataset",
				fillColor: "rgba(220,220,220,0.5)",
				strokeColor: "rgba(220,220,220,0.8)",
				highlightFill: "rgba(220,220,220,0.75)",
				highlightStroke: "rgba(220,220,220,1)",
				data: [65, 59, 80, 81, 56, 55, 40]
			},
			{
				label: "My Second dataset",
				fillColor: "rgba(151,187,205,0.5)",
				strokeColor: "rgba(151,187,205,0.8)",
				highlightFill: "rgba(151,187,205,0.75)",
				highlightStroke: "rgba(151,187,205,1)",
				data: [28, 48, 40, 19, 86, 27, 90]
			}
		]
	};
	
	this.update = function()
	{
	}
	
	this.ready = function()
	{
		var ctx = $("div#nutrient canvas#myChart").get(0).getContext("2d");
		nutrient.myChart = new Chart(ctx).Bar(nutrient.chartData, {
			responsive : true
		});
	}
}

var nutrient = new Nutrient();

$(document).ready(
	function() 
	{
		nutrient.ready();
	} 
);
