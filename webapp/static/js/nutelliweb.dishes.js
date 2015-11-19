function Dishes()
{
	this.removeEntry = function(entryHref)
	{
		$(entryHref).parents("tr").remove();
		
		var items = [];
		$("div#dishes table tbody tr").each(function(i, tr){
			var name = $(tr).find("td.name").html();
			var amount = $(tr).find("span.amount").html();
			var unit = $(tr).find("span.unit").html();
			items.push("<input type='text' name='dishes[][name]' value='" + name + "'>");
			items.push("<input type='text' name='dishes[][amount]' value='" + amount + "'>");
			items.push("<input type='text' name='dishes[][unit]' value='" + unit + "'>");
		});
		
		$("<form>", { "method": "put", "action": "/ajax/dishes", html: items.join("") }).appendTo("div#dishes div#hidden_div");
		$("div#dishes div#hidden_div form").ajaxSubmit({
			type: "PUT",
			success: function(){
				dishes.update();
			}
		});
		$("div#dishes div#hidden_div").children().remove();
		
	}
	
	this.update = function()
	{
		$.getJSON( "/ajax/dishes", function( data ) {
			$("div#dishes table tbody").children().remove();
			if(data == null)
			{
				$("<div>", {"class" : "row", html: "<div class='col-sm-12 name' style='text-align: center'>Please add dishes</div>"}).appendTo("div#dishes>div.data");
			}
			else
			{
				$.each( data, function( key, val ) {
					var items = [];
					items.push( "<td class='name'>" + val.name + "</td>" );
					items.push( "<td class='amount'><span class='amount'>" + val.amount + "</span> <span class='unit'>" + val.unit + "</span></td>" );
					items.push( "<td class='tools'><a class='remove' href='#' onclick='javascript: dishes.removeEntry(this); return false;'>Remove</a></td>" );
					$("<tr>", { html: items.join("")}).appendTo("div#dishes table tbody");
				});
			}
		});
	}
	
	this.ready = function()
	{
		$('form#dishes_add_form').ajaxForm({
			success: function(){
				dishes.update();
			}
		});
		
		$('div#dishes a.reset').on("click",function(){
			$.ajax({
				url: "/ajax/dishes",
				method: "DELETE"
			}).done(function(){
				dishes.update();
			});
			return false;
		});
		
		$("<div>", { "id": "hidden_div", "style": "display: block" }).appendTo('div#dishes');
		
		var availableTags = [
		  "ActionScript",
		  "AppleScript",
		  "Asp",
		  "BASIC",
		  "C",
		  "C++",
		  "Clojure",
		  "COBOL",
		  "ColdFusion",
		  "Erlang",
		  "Fortran",
		  "Groovy",
		  "Haskell",
		  "Java",
		  "JavaScript",
		  "Lisp",
		  "Perl",
		  "PHP",
		  "Python",
		  "Ruby",
		  "Scala",
		  "Scheme"
		];
		$( "input#dishes_input_name" ).autocomplete({
			source: availableTags
		});
		
		dishes.update();
	}
}

var dishes = new Dishes();

$(document).ready(
	function() 
	{
		dishes.ready();
	} 
);
