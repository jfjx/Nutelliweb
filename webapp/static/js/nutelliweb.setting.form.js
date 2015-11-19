function SettingForm()
{
	this.ready = function()
	{
		$("div.setting>form").submit(function( event ) {
			if(!settingForm.onSubmit($(this)))
				event.preventDefault();
		});
	}
	
	this.onSubmit = function($form)
	{
		if(settingForm.checkEmptyInput($form.find("input:text[name='person[name]']"), "Please type your name")
			&& settingForm.checkRadioInput($form.find("input:radio[name='person[gender]']"), "Please select your gender")
			&& settingForm.checkInputConstraint($form.find("input:text[name='person[age]']"), /^[0-9]+$/, "Please type your age")
			&& settingForm.checkInputConstraint($form.find("input:text[name='person[weight]']"), /^[0-9]+(\.[0-9]+)?$/, "Please type your weight")
			&& settingForm.checkInputConstraint($form.find("input:text[name='person[height]']"), /^[0-9]+(\.[0-9]+)?$/, "Please type your height"))
		{
			return true;
		}
		else
			return false;
	}
	
	this.checkEmptyInput = function($input, onEmptyMsg)
	{
		if($input.val() == "")
		{
			alert(onEmptyMsg);
			return false;
		}
		
		return true;
	}
	
	this.checkInputConstraint = function($input, regex, onInvalidMsg)
	{
		if(!regex.test($input.val()))
		{
			alert(onInvalidMsg);
			return false;
		}
		
		return true;
	}
	
	this.checkRadioInput = function($inputs, onNotSelectedMsg)
	{
		if(!$inputs.is(':checked'))
		{
			alert(onNotSelectedMsg);
			return false;
		}
		
		return true;
	}
}

var settingForm = new SettingForm();

$(document).ready(
	function() 
	{
		settingForm.ready();
	}
);
