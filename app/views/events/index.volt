{{ content() }}
<?php
	$url_share = rawurlencode("https://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]");
	$title_share = rawurlencode( isset($metaTitle) ? $metaTitle : 'Tiktx - Events' );
?>


    <div class="container">
		<div class="row">
			<div class="col-xs-12">

				<ul class="event-list">
					<?php foreach ($events as $event) : ?>
					<?php
						$url_share = rawurlencode($this->url->get() . 'event/' . $event->id . '/' . $event->slug);
						$title_share = rawurlencode( $event->name . ', ' . date('d-M', strtotime($event->date_start)) );
					?>
					<li>
						<time datetime="{{ event.date_start }}">
							<span class="day"><?php echo date('d', strtotime($event->date_start)) ?></span>
							<span class="month"><?php echo $this->t->_(date('M', strtotime($event->date_start))) ?></span>
							<span class="year"><?php echo date('Y', strtotime($event->date_start)) ?></span>
							<span class="time"><?php echo date('H:i', strtotime($event->date_start)) ?></span>
						</time>
						<a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}">
							<?php if ( isset($event->EventsImages[0]) ) : ?>
								<img alt="{{ event.name }}" src="{{ url() }}img/shows/{{ event.EventsImages[0].name }}" />
							<?php endif ; ?>
						</a>
						<div class="info">
							<h2 class="title">
								<a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}">
									{{ event.name }}
								</a>
							</h2>
							<p class="desc">{{ event.ticket_sub_name }}</p>
							<p class="desc"><?php echo $this->getDI()->getFormatdates()->format($event->date_opening, '17:00h');?></p>
							<p class="desc">{{ event.Cities.name }}, {{ event.Regions.acronym }}</p>
							<p class="desc buy">
								<a href="{{ url() }}event/{{ event.id }}/{{ event.slug }}" class="btn btn-default">
									{{ t._('buy') }}
								</a>
							</p>
						</div>
						<div class="social">
							<ul>
								<li class="facebook" style="width:33%;">
									<a href="javascript:window.open('https://www.facebook.com/sharer/sharer.php?u={{ url_share }}', 'Compartilhe no Facebook', 'width=565, height=352')">
										<span class="fa fa-facebook"></span>
									</a>
								</li>

								<li class="twitter" style="width:34%;">
									<a href="javascript:window.open('https://twitter.com/home?status={{ title_share }}%20-%20{{ url_share }}', 'Compartilhe no Twitter', 'width=565, height=360')">
										<span class="fa fa-twitter"></span>
									</a>
								</li>

								<li class="whatsapp" style="width:34%;">
									<a href="javascript:window.open('https://api.whatsapp.com/send?text={{ url_share }}', 'Compartilhe no Whatsapp', 'width=565, height=352')">
										<span class="fa fa-whatsapp"></span>
									</a>
								</li>
							</ul>
						</div>
					</li>
					<?php endforeach ; ?>

				</ul>
			</div>
		</div>
	</div>


<style type="text/css">

	@import url("//fonts.googleapis.com/css?family=Lato:100,300,400,700,900,400italic");
    @import url("//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.css");
    body {
		padding: 20px 0px;
	}
	a, a:hover {
		text-decoration: none;
	}
	.container {
		max-width: 750px;
		margin: 0 auto;
	}

    .event-list {
		list-style: none;
		font-family: 'Lato', sans-serif;
		margin: 0px;
		padding: 0px;
	}
	.event-list > li {
		background-color: rgb(255, 255, 255);
		box-shadow: 0px 0px 5px rgb(51, 51, 51);
		box-shadow: 0px 0px 5px rgba(51, 51, 51, 0.7);
		padding: 0px;
		margin: 0px 0px 20px;
	}
	.event-list > li:hover {
		box-shadow: 0px 0px 10px rgb(51, 51, 51);
		box-shadow: 0px 0px 10px rgba(51, 51, 51, 0.7);
	}
	.event-list > li > time {
		display: inline-block;
		width: 100%;
		color: rgb(255, 255, 255);
		/* background-color: rgb(197, 44, 102); */
		background-color: #07648b;
		padding: 5px;
		text-align: center;
		text-transform: uppercase;
	}
	.event-list > li:nth-child(even) > time {
		/* background-color: rgb(165, 82, 167); */
		background-color: #02b7e4;
	}
	.event-list > li > time > span {
		display: none;
	}
	.event-list > li > time > .day {
		display: block;
		font-size: 56pt;
		font-weight: 100;
		line-height: 1;
	}
	.event-list > li time > .month {
		display: block;
		font-size: 24pt;
		font-weight: 900;
		line-height: 1;
	}
	.event-list > li  img {
		width: 100%;
	}
	.event-list > li > .info {
		padding-top: 5px;
		text-align: center;
	}
	.event-list > li > .info > .title {
		font-size: 17pt;
		font-weight: 700;
		margin: 0px;
	}
	.event-list > li > .info > .desc {
		font-size: 13pt;
		font-weight: 300;
		margin: 0px;
	}
	.event-list > li > .info > .buy {
	    margin: 10px;
	}
	.event-list > li > .info > ul,
	.event-list > li > .social > ul {
		display: table;
		list-style: none;
		margin: 10px 0px 0px;
		padding: 0px;
		width: 100%;
		text-align: center;
	}
	.event-list > li > .social > ul {
		margin: 0px;
	}
	.event-list > li > .info > ul > li,
	.event-list > li > .social > ul > li {
		display: table-cell;
		cursor: pointer;
		color: rgb(30, 30, 30);
		font-size: 11pt;
		font-weight: 300;
        padding: 3px 0px;
	}
    .event-list > li > .info > ul > li > a {
		display: block;
		width: 100%;
		color: rgb(30, 30, 30);
		text-decoration: none;
	}
    .event-list > li > .social > ul > li {
        padding: 0px;
    }
    .event-list > li > .social > ul > li > a {
        padding: 3px 0px;
	}
	.event-list > li > .info > ul > li:hover,
	.event-list > li > .social > ul > li:hover {
		color: rgb(30, 30, 30);
		background-color: rgb(200, 200, 200);
	}
	.facebook a,
	.twitter a,
	.whatsapp a {
		display: block;
		width: 100%;
		color: rgb(75, 110, 168) !important;
	}
	.twitter a {
		color: rgb(79, 213, 248) !important;
	}
	.whatsapp a {
		color: rgb(17, 139, 9) !important;
	}
	.facebook:hover a {
		color: rgb(255, 255, 255) !important;
		background-color: rgb(75, 110, 168) !important;
	}
	.twitter:hover a {
		color: rgb(255, 255, 255) !important;
		background-color: rgb(79, 213, 248) !important;
	}
	.whatsapp:hover a {
		color: rgb(255, 255, 255) !important;
		background-color: rgb(17, 139, 9) !important;
	}

	@media (min-width: 768px) {
		.event-list > li {
			position: relative;
			display: block;
			width: 100%;
			height: 120px;
			padding: 0px;
		}
		.event-list > li > time,
		.event-list > li  img  {
			display: inline-block;
		}
		.event-list > li > time,
		.event-list > li  img {
			width: 120px;
			float: left;
		}
		.event-list > li > .info {
			background-color: rgb(245, 245, 245);
			overflow: hidden;
		}
		.event-list > li > time,
		.event-list > li  img {
			width: 120px;
			height: 120px;
			padding: 0px;
			margin: 0px;
		}
		.event-list > li  img {
			width: auto;
			height: 120px;
		}
		.event-list > li > .info {
			position: relative;
			height: 120px;
			text-align: left;
			padding-right: 40px;
		}
		.event-list > li > .info > .title,
		.event-list > li > .info > .desc {
			padding: 0px 10px;
		}
		.event-list > li > .info > .buy {
			position: absolute;
			bottom: 10px;
			margin: 0;
		}
		.event-list > li > .info > ul {
			position: absolute;
			left: 0px;
			bottom: 0px;
		}
		.event-list > li > .social {
			position: absolute;
			top: 0px;
			right: 0px;
			display: block;
			width: 40px;
		}
        .event-list > li > .social > ul {
            border-left: 1px solid rgb(230, 230, 230);
        }
		.event-list > li > .social > ul > li {
			display: block;
            padding: 0px;
		}
		.event-list > li > .social > ul > li > a {
			display: block;
			width: 40px;
			padding: 10px 0px 9px;
		}
	}
	</style>