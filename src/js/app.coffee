define [
	'jquery',
	'underscore',
	'scrollorama',
	'waypoints',
	'mixitup'
], ($, _) ->

	inits = ->
		controller = $.superscrollorama
			triggerAtCenter: false,
			playoutAnimations: true

		winheight = $(window).height()
		winwidth = $(window).width()
		navheight = $('#js-nav').height()

		controller.addTween(
			'#hello',
			(new TimelineLite()).append([
				TweenMax.fromTo($('#hello .center'), 1, 
					{css:{'padding-top': 0}, immediateRender:true}, 
					{css:{'padding-top': winheight  * 0.25}}
				),
			]),
			winheight 
		)

		$('#about').css
			'margin-bottom': (winheight * 0.25) + 'px'

		controller.pin '#about', winheight * 0.5, {
			offset: -navheight
			anim: (new TimelineLite()).append([
				TweenMax.fromTo($('#js-team'), 0.25, 
					{css:{'opacity': 0}, immediateRender:true}, 
					{css:{'opacity': 1 }}
				)
			]),
		}

		controller.pin '#services', winheight * 0.5, {
			offset: -navheight
			anim: (new TimelineLite()).append([
				TweenMax.fromTo($('#services .service h3'), 0.25, 
					{css:{'opacity': 0, 'letter-spacing': '0em'}, immediateRender:true}, 
					{css:{'opacity': 1, 'letter-spacing': '0.3em' }}
				)
			]),
		}

		controller.addTween(
			'#services',
			(new TimelineLite()).append([
				TweenMax.fromTo($('#services .center'), 1, 
					{css:{'padding-top': 0}, immediateRender:true}, 
					{css:{'padding-top': winheight  * 0.25}}
				),
			]),
			winheight 
		)


		$('a.scrollto').on 'click', (e) ->
			$('body').animate({
					scrollTop: $( $(this).attr('href') ).offset().top
				}, 500)
			
			e.preventDefault()
			return false

		$('#js-navlist a').each ->
			$elem = $( $(this).attr('href'))

			$elem.waypoint =>
				$('#js-navlist li').removeClass 'active'
				$(this).parent('li').addClass 'active'

		$('#portfolio-grid').mixitup();
		$('#portfolio').waypoint ->
			$('#portfolio .thumbnail').each ->
				$(this).css 'background-image', 'url("' + $(this).attr('data-src') + '")'
			, { triggerOnce: true }

	isInViewport = (el) ->
		top = $(el).offset().top
		scrolled = $(window).scrollTop()
		viewheight = $(window).height()

		if scrolled + viewheight < top then return false

		height = $(el).height()
		if scrolled > top + height then return false

		return true


	intervalWhileVisible = (interval, element, func) ->
		started = false

		do startInterval = ->
			if started is true then return false

			started = true
			f = ->
				if isInViewport element
					func()
					start()
				else
					started = false

			do start = -> window.setTimeout f, interval

		$(element).waypoint startInterval


	centerElements = ->
		$('.center').each ->
			p_width  = $(this).parent().width();
			p_height = $(this).parent().height();

			width  = $(this).width();
			height = $(this).height();

			$(this).css
				top : Math.max((p_height - height) * 0.5, 40) + 'px'
				left: Math.max((p_width  - width ) * 0.5, 0 ) + 'px'

			$(this).parent().css
				'min-height': height

	setSlide = ->
		height = $(window).height()

		$('.slide').css
			height: height

	tickerGo = ->
		$('.ticker').each ->
			eh  = $('> *:first-child', this).height()
			num = $(this).children().length
			i = 0

			intervalWhileVisible 2000, this, =>
				if i >= num
					i = 0

				$('> *:first-child', this).css 'margin-top', (i * eh * -1) + 'px'
				i++



	resizeUpdates = _.throttle(
		->
			centerElements()
			setSlide()
		, 33
	)

	return {
		initialize: ->
			$(document).ready ->
				setSlide()
				centerElements()
				tickerGo()
				inits()

				$(window).on 'resize', resizeUpdates
	}