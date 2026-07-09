$(function() {
	// 窗口滚动时判断 返回顶部 按钮 和 悬浮分享区域 是否显示
	$(window).scroll(function() {
		// 窗口滚动距离超过50，显示 返回顶部 按钮，否则隐藏
		if ($(window).scrollTop() >= 50) {
			$(".to_top").fadeIn();
		} else {
			$(".to_top").fadeOut();
		}
		//renderFixedShare();

	});

	$('.to_top').on('click', function() {
		$("html,body").animate({ scrollTop: 0 }, 500);
	});
});