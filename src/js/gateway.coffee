require.config 
	paths:
		jquery: ['//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min', 'jquery'],
		tweenmax: ['//cdnjs.cloudflare.com/ajax/libs/gsap/latest/TweenMax.min', 'tweenmax']
		scrollorama: ['scrollorama']
	shim:
		scrollorama: ['jquery', 'tweenmax']
		
require ['app'], (App) ->
	App.initialize()