(function($,document,window,undefined){
	var timetable = {
		colorIdx: 0,
		timeitems: [],
		isAdvancedSearch: false,

		bongswae: function(e) {
			e.preventDefault();
			return false;
		},

		getList: function() {
			$.ajax({
				url: "/timeitem/getList/" + timetable_id,
				dataType: "json",
				type: "GET",
				async: false,
				success: function(r) {
					for (var i=0; i<r.length; ++i)
						timetable.addLecture(r[i]);

					toastr.success('시간표를 불러왔습니다.')
				},
				error: function() {
					toastr.error('시간표 목록 받아오기 실패했어요. 다시 새로고침 해 주세요.')
				}
			});
		},

		addLecture: function(data) {
			var schedules = data.schedules;
			var elem = [];

			var colorId = (timetable.colorIdx++) % 9 + 1;

			for (var i=0; i<schedules.length; ++i) {
				var start_time = parseInt(Math.max(540, schedules[i].start_time), 10);
				var end_time   = parseInt(Math.min(1320,schedules[i].end_time  ), 10);
				var wday       = parseInt(schedules[i].wday      , 10);

				for (var t=start_time; t<=end_time; t+=30) {
					elem.push('#t'+wday+'_'+t);
					if (t > start_time)
						$('#t'+wday+'_'+t).hide();
				}

				$('<div />')
					.append($('<span class="ln" />').text(data.lecture_name))
					.append($('<span class="pn" />').text(data.professor_name))
					.append($('<span class="lc" />').text(data.lecture_code))
					.append($('<a href="#" class="rm" data-id="'+data.timeitem_id+'" />').html('<i class="glyphicon glyphicon-remove" />'))
					.append($('<a href="/lecture/' + data.lecture_id + '" class="if" target="_blank" />').html('<i class="glyphicon glyphicon-info-sign" />'))
					.appendTo('#t'+wday+'_'+start_time);

				$('#t'+wday+'_'+start_time).attr('rowspan', parseInt((end_time - start_time) / 30, 10) + 1)
					.addClass('c c' + colorId);

				$('#t'+wday+'_'+start_time+' .pn').css('top', $('#t'+wday+'_'+start_time+' .ln').height() + 7);
				$('#t'+wday+'_'+start_time+' .lc').css('top', $('#t'+wday+'_'+start_time+' .ln').height() + $('#t'+wday+'_'+start_time+' .pn').height() + 7);
			}

			if ($('#lecListItem_'+data.lecture_code).length < 1)
			$('#lecList tbody').append('<tr id="lecListItem_'+data.lecture_code+'">'
				+ '<th>' + data.lecture_code + '</th>'
				+ '<td><a href="/lecture/' + data.lecture_id + '" target="_blank">' + data.lecture_name + '</a></td>'
				+ '<td>' + data.lecture_credit + '</td>'
				+ '<td>' + data.lecture_div + '</td>'
				+ '<td>' + data.lecture_enroll + '(' + data.lecture_pack + ')/' + data.lecture_limit + '</td>'
				+ '<td><button class="btn btn-xs btn-danger rm" data-id="' + data.timeitem_id + '"><i class="glyphicon glyphicon-remove"></i></button></td>'
				+ '</tr>');

			$('#total-credit').text(parseInt($('#total-credit').text(), 10) + parseInt(data.lecture_credit, 10));

			$(elem.join(',')).addClass('t'+data.timeitem_id+' has');
			timetable.timeitems.push(parseInt(data.timeitem_id, 10));
		},

		deleteTimeItem: function(timeitem_id) {
			$.ajax({
				url: "/timeitem/delete/" + timetable_id + "/" + timeitem_id,
				dataType: "json",
				type: "GET",
				async: false,
				success: function(r) {
					if (r.result == "deleted") {
						$(".t"+timeitem_id+" div").remove();
						$(".t"+timeitem_id).show().removeClass('c c1 c2 c3 c4 c5 c6 c7 c8 c9 has t'+timeitem_id).attr('rowspan','1');
						$('#total-credit').text(parseInt($('#total-credit').text(), 10) - parseInt(r.lecture_credit, 10));

						if ($.inArray(parseInt(timeitem_id, 10), timetable.timeitems) != -1)
							timetable.timeitems.splice($.inArray(parseInt(timeitem_id, 10), timetable.timeitems), 1);

						$('#lecListItem_'+r.lecture_code).remove();
					} else {
						toastr.error('삭제에 실패했습니다. 다시 시도해 주세요. (' + r.result + ')');
					}
				},
				error: function() {
					toastr.error('삭제에 실패했습니다. 다시 시도해 주세요.');
				}
			});
		},

		doSearch: function(page) {
			if (timetable.isAdvancedSearch) {
				var searchOpt = {
					term: $('#searchOptionTerm').val(),
					location: $('#searchOptionLocation').val(),
					credit: $('#searchOptionCredit').val(),
					open_univ: $('#searchOptionOpenUniv').val(),
					div: $('#searchOptionDiv').val(),
					no_duplicate: $('#searchOptionNoDuplicate').is(':checked') ? $('#searchOptionNoDuplicate').val() : 0,
					sem: timetable_sem
				};

				var timeOpt = [];
				$('#time-option-container .row').each(function(){
					if ($(this).hasClass('hide') == false) {
						var start_time = $('select.start-time', $(this)).val();
						var end_time = $('select.end-time', $(this)).val();
						var time_opt = $('select.time-opt', $(this)).val();
						var wday = $('select.wday', $(this)).val();

						if (time_opt)
							timeOpt.push({
								wday: wday,
								start_time: start_time,
								end_time: end_time,
								time_opt: time_opt
							});
					}
				});

				if (timeOpt.length > 0)
					searchOpt['time'] = timeOpt;
			} else {
				var searchOpt = {term: $('#search-term').val(), sem: timetable_sem};
			}

			$('#search-result').html('');
			$('#search-result-loading').removeClass('hide');

			var _page = page || 0;
			$.post("/lecture/search/" + _page, searchOpt, function(r) {
				$('#search-result').html('');
				$('#list-pagination, #total-rows').removeClass('hide');
				$('#total-rows > strong').text(r.total_rows);
				$('#list-pagination').html(r.pagination_link);
				$('#timetable td.active').removeClass('active');
				$('#search-result-loading').addClass('hide');

				// if (typeof console !== "undefined" && r.query.length > 0)
				// 	console.log(r.query);

				for (var i=0; i<r.result.length; i++) {
					var _r = r.result[i];
					var pack_count_style = '';
					if (_r.pack_count >= _r.lecture_limit)
						pack_count_style = ' style="color:#c00;"';
					else if (_r.pack_count * 2 >= _r.lecture_limit)
						pack_count_style = ' style="color:#ECAF13;"';

					$('<a href="#" class="list-group-item clearfix" data-id="'+_r.lecture_id+'" data-hover="'+_r.hover+'" />')
						.append($('<div class="pull-left" />')
							.append($('<h4 class="list-group-item-heading" style="font-size:16px;" />').html(
								'<span style="color:#295c8f;font-weight:bold;">'+_r.lecture_name+'</span>'
								+ (_r.avr_score > 0 ? (' <small '
									+ (_r.avr_score >= 5 ? 'style="font-weight:bold;color:#CC7300;"' : '')
									+ (_r.avr_score >= 4 ? 'style="color:#FFB75B;"' : '')
									+ '><i class="glyphicon glyphicon-star"></i> ' + _r.avr_score + '</small>') : '')
								+ (_r.pack_count > 0 ? (' <small'+pack_count_style+'><i class="glyphicon glyphicon-user"></i> ' + _r.pack_count + '</small>') : '')))
							.append($('<p class="list-group-item-text" />').html(
								(/상주/.exec(_r.schedule_token) ? '<strong style="color:#18BC9C;font-size:95%;margin-right:3px;">상주캠!</strong> ' : '') +
								(_r.professor_name || '-') + '<span style="margin-left:5px;font-size:12px;color:#777;font-weight:bold;">'+ _r.lecture_code.substr(0,7)
									+ '</span><span style="font-size:12px;color:#999;">' + _r.lecture_code.substr(7,3) + '</span> ')
							)
						)
						.append($('<div class="pull-right btn-group btn-group-xs hide" style="z-index:9999" />')
							.append($('<button class="btn btn-xs btn-primary" />').html('<i class="glyphicon glyphicon-plus" />'))
							.append($('<button data-id="'+_r.lecture_id+'" class="open-info btn btn-xs btn-default" />').html('<i class="glyphicon glyphicon-info-sign" />'))
						)
						.append($('<div style="position:absolute;bottom:0px;right:0px;" />')
							.html(_r.univ_name ? '<span class="label label-default" style="font-size:12px;">' + _r.univ_name + '</span>' : ''))
						.appendTo('#search-result');
				}
			}, "json");
		},

		init: function() {
			timetable.getList();

			$('#search-term').keydown(function(e){
				if (e.keyCode == 13) {
					timetable.isAdvancedSearch = false;
					timetable.doSearch();
					return timetable.bongswae(e);
				}
			});

			$('#search-btn').click(function(e){
				timetable.isAdvancedSearch = false;
				timetable.doSearch();
				return timetable.bongswae(e);
			});

			$('#do-advance-search').click(function(e){
				timetable.isAdvancedSearch = true;
				timetable.doSearch();

				$('#searchOptionModal').modal('hide');
				$('#search-term').val('상세 검색').prop('disabled', true);
				$('#search-option-cancel').removeClass('hide');
				$('#search-btn').addClass('hide');
				return timetable.bongswae(e);
			});

			$('#search-favorite-lecture').click(function(e){
				$('#search-option-cancel').click();
				timetable.isAdvancedSearch = false;
				$('#search-term').val('인기강의');
				timetable.doSearch();

				// return timetable.bongswae(e);
			});

			$('#search-option-cancel').click(function(e){
				$('#searchOptionTerm,#searchOptionLocation,#searchOptionCredit,#searchOptionOpenUniv,#searchOptionDiv').val('');
				$('#searchOptionNoDuplicate').prop('checked', false);

				$('#time-option-container .row:not(:first)').remove();
				$('select.start-time,select.end-time,select.time-opt,select.wday').val('');
				$('#add-new-time-option-btn').prop('disabled', false);

				$(this).addClass('hide');
				$('#search-term').val('').prop('disabled', false).focus();
				$('#search-btn').removeClass('hide');
				return timetable.bongswae(e);
			});

			$(document).on('click', 'a.rm, button.rm', function(e) {
				if (confirm('정말 삭제하실건가요?')) {
					timetable.deleteTimeItem($(this).attr('data-id'));
					toastr.warning('강의가 삭제됬어요.')
				}
				return timetable.bongswae(e);
			});

			$(document).on('click', '#list-pagination ul.pagination li a', function(e){
				var href = $(this).attr('href');

				timetable.doSearch(href.substr(2));
				return timetable.bongswae(e);
			});

			$(document).on('click', '#search-result a.list-group-item', function(e) {
				if ($("td.has.active").length > 0) {
					var clss = $("td.has.active")[0].className.split(' ');
					for (var i=0; i<clss.length; i++)
						if (clss[i][0] == 't')
							toastr.error('"' + $(".ln", $("td.c." + clss[i])[0]).text() + '" 강의와 겹치기 때문에, 추가할 수 없어요.');
				} else {
					$.ajax({
						url: "/timeitem/addLecture",
						dataType: "json",
						type: "POST",
						async: false,
						data: { timetable_id: timetable_id, lecture_id: $(this).attr('data-id') },
						success: function (r) {
							if (r.result == "added") {
								timetable.addLecture(r.data);
								toastr.success('강의가 모의시간표에 추가되었어요.');
							} else if (r.result == "login") {
								alert('로그인 해주세요.'); location.href = '/member/login';
							} else if (r.result == "timetable_not_found") {
								toastr.error('시간표를 찾을 수 없거나 본인의 시간표가 아닙니다.');
							} else if (r.result == "lecture_not_found") {
								toastr.error('추가할 강의를 찾을 수 없거나 추가할 시간표와 학기가 맞지 않습니다.');
							} else if (r.result == "already_added") {
								toastr.error('이미 추가된 강의네요.');
							} else {
								toastr.error('Unknown code (' + r.result + ')');
							}
						},
						error: function() {
							toastr.error('시간표 등록을 실패했습니다. 일시적인 오류일 수 있으니 다시 시도해주세요 T_T');
						}
					});
				}

				return timetable.bongswae(e);
			});

			$(document).on('click', '#add-new-time-option-btn', function(e) {
				$('#time-option-container').append('<div class="row" style="margin-top: 10px;">'
					+ $('#time-option-container .row:first').html()
					+ '<button style="position:absolute;margin-top:10px;" class="btn btn-danger btn-xs remove-time-option-btn" type="button"><i class="glyphicon glyphicon-remove"></i></button>'
					+ '</div>');

				if ($('#time-option-container .row').length >= 3)
					$(this).prop('disabled', true);
				else
					$(this).prop('disabled', false);

				return timetable.bongswae(e);
			});

			$(document).on('click', 'button.remove-time-option-btn', function(e) {
				$(this).closest('.row').remove();

				if ($('#time-option-container .row').length >= 3)
					$('#add-new-time-option-btn').prop('disabled', true);
				else
					$('#add-new-time-option-btn').prop('disabled', false);

				return timetable.bongswae(e);
			});

			$(document).on('click', 'button.open-info', function(e){
				window.open('/lecture/'+$(this).attr('data-id'));
				return timetable.bongswae(e);
			});

			$(document).on('mouseenter', '#search-result a.list-group-item', function(e){
				$($(this).attr('data-hover')).each(function(){
					var match;
					if (match = /t([0-9]*)/.exec($(this)[0].className)) {
						$('.t'+match[1]).addClass('active');
					}
				});

				$($(this).attr('data-hover')).addClass('active');

				var h = $(document).scrollTop();
				var h2 = $(window).height();
				var f = $('#timetable').offset().top;

				$('#notimealert,#previewupperalert').addClass('hide');

				if ($(this).attr('data-hover') == "")
					$('#notimealert').removeClass('hide');
				else {
					$('#timetable td.active').each(function(){
						if (!isElementInViewport(this)) {
							$('#previewupperalert').removeClass('hide');
							return false;
						}
					})
				}
			});

			$(document).on('mouseleave', '#search-result a.list-group-item', function(e){
				$($(this).attr('data-hover')).each(function(){
					var match;
					if (match = /t([0-9]*)/.exec($(this)[0].className)) {
						$('.t'+match[1]).removeClass('active');
					}
				});

				$($(this).attr('data-hover')).removeClass('active');
				$('#notimealert,#previewupperalert').addClass('hide');
			});
		}
	};

	if ($(window).width() >= 980) {
		var $srw = $('#search-result-wrapper');
		var $sr = $('#search-result');

		var checkSr = function(force) {
			if (force && $srw.hasClass('fixed')) {
				$srw.css('height', ($(window).height() - 100) + 'px');
			} else if (!$srw.hasClass('fixed') && $(document).scrollTop() > 200) {
				$srw.addClass('fixed')
				$srw.attr('style', 'background:#fff;z-index:99999;position: fixed; top: 65px; left: '+$srw.offset().left+'px; width: ' + $sr.css('width') + '; height: ' + ($(window).height() - 100) + 'px; overflow: auto;');
			} else if ($srw.hasClass('fixed') && $(document).scrollTop() <= 200) {
				$srw.removeClass('fixed')
				$srw.attr('style', '')
			}
		};
		var rszTimer = null;

		$(window).scroll(function(){
			checkSr(false);
		})

		$(window).resize(function(){
			if (rszTimer == null) {
				rszTimer = setTimeout(function(){
					clearTimeout(rszTimer);
					rszTimer = null;

					checkSr(true);
				}, 100);
			}
		})
	}

	$(document).ready(timetable.init);
})(jQuery,document,window);

function isElementInViewport (el) {
    //special bonus for those using jQuery
    if (typeof jQuery === "function" && el instanceof jQuery) {
        el = el[0];
    }

    var rect = el.getBoundingClientRect();

    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && /*or $(window).height() */
        rect.right <= (window.innerWidth || document.documentElement.clientWidth) /*or $(window).width() */
    );
}