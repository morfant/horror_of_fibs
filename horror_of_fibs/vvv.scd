

(
var maxGroupNum = 20;
var w, wc, run = true;
var numSquares = 1; // 그릴 사각형 수
var size, pos, angle, direction, dirBase = 2; // 사각형 크기, 위치, 회전 각도
var spex, labels, initVals;
var list_rect = List.newClear(0);
var rect;
var frameCount;
var fillGR;
var rectColors = [
	[Color.new255(255, 100, 100, 60), Color.new255(0, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(100, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(0, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(100, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(0, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(100, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(0, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(100, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(0, 200, 100, 60)],
	[Color.new255(255, 100, 100, 60), Color.new255(100, 200, 100, 60)]
];
var isFilling = Array.fill(maxGroupNum, false);
var currentRectNum = Array.fill(maxGroupNum, 0); // 각 그룹의 현재 사각형 개수




// 창과 드로잉 설정
w = Window("Fibonacci Rectangles",
	Rect(100, 100, 600, 600)).front.background_(Color.white);
w.onClose = {run = false;};


// GR 그룹 컨테이너 추가
maxGroupNum.do{
	list_rect.add(List.newClear(0));
};


// Functions
fillGR = {|g_idx, r_num, x, y, interval = 0.5|
	// 중복 실행 및 목표 개수가 동일한 경우 방지
	if (isFilling[g_idx].not and: (currentRectNum[g_idx] != r_num), {
		isFilling[g_idx] = true; // 실행 중 플래그 설정
		list_rect[g_idx].clear(); // 기존 사각형 초기화

		direction = dirBase;
		pos = Point(x, y);

		Routine({
			r_num.do{|i|
				var side = fib(i+1)[i] * 20;

				// 사각형 객체 추가
				list_rect[g_idx].add(
					GradRect.new(pos, side, i % 4,
						rectColors[g_idx][0],
						rectColors[g_idx][1],
						0, side * 0.1
					)
				);

				// 다음 사각형 위치 업데이트
				switch(direction,
					0, { pos = pos + Point(side, 0); },  // 오른쪽
					1, { pos = pos + Point(0, side); },  // 아래쪽
					2, { pos = pos - Point(side, 0); }, // 왼쪽
					3, { pos = pos - Point(0, side); }  // 위쪽
				);
				direction = (direction + 1) % 4; // 시계방향으로 90도 회전

				interval.wait; // 대기 시간
			};
			// 실행 완료 후 플래그 해제 및 현재 개수 업데이트
			currentRectNum[g_idx] = r_num;
			isFilling[g_idx] = false;
		}).play(AppClock);
	});
};


frameCount = 20; // 시작 지점 설정
w.drawFunc = {

	// ("frameCount: "++frameCount).postln;

	// 그리기 기본 설정
	Pen.translate(w.bounds.width/2, w.bounds.height/2); // 캔버스의 중앙으로 이동
	Pen.strokeColor = Color.black;


	// 모든 그룹의 GR draw ??
	maxGroupNum.do{|i|
		// ("size of list_rect["++i++"]: "++list_rect[i].size()).postln;
		if (list_rect[i].size() > 0, {
			list_rect[i].do{|item, idx|
				item.draw;
			};
		});

	};



	if (frameCount > 30, {
		fillGR.(0, 2, 0, 0, 1.0);
	});

	if (frameCount > 60, {
		fillGR.(1, 6, 200, 100, 0.2);
	});





	// pos의 위치 표시
	// Pen.fillColor = Color.red;
	// Pen.addOval(Rect(pos.x, pos.y, 10, 10));
	// Pen.fill;



	frameCount = frameCount + 1;
};
// w.refresh;
{ while { run } { w.refresh; 0.1.wait } }.fork(AppClock);


//===================================================================
// Control panel
wc = Window("Control", Rect(800, 100, 400, 100)).front.background_(Color.white);
wc.view.decorator=FlowLayout(wc.view.bounds);
wc.view.decorator.gap=2@2;
spex = [
	[1, 20].asSpec,
	[0, 3].asSpec
];
labels = #[num, dir];
initVals = [1, 2];
2.do{|i|
	EZSlider(wc, // parent,
		390@20,    // bounds
		labels[i],  // label
		spex[i],     // controlSpec
		{ |ez| switch(i,

			0, {
				direction = dirBase;
				size = 0;
				pos = Point(0, 0);
				angle = 0;

				numSquares = ez.value.asInteger;
				// ("numSquares: "++numSquares).postln;
				list_rect[0].clear;

				numSquares.do { |i|
					var side = fib(i+1)[i] * 20;
					// ("side: "++side).postln;
					// ("i: "++i).postln;

					// 사각형 객체 추가
					list_rect[0].add(
						GradRect.new(pos, side, i % 4,
							Color.new255(255, 100, 100, 60),
							Color.new255(0, 200, 100, 60),
							1, (0.5 * (i+1))
						)
					);

					// 다음 사각형 위치 업데이트
					switch(direction,
						0, { pos = pos + Point(side, 0); },  // 오른쪽
						1, { pos = pos + Point(0, side); },  // 아래쪽
						2, { pos = pos - Point(side, 0); }, // 왼쪽
						3, { pos = pos - Point(0, side); }  // 위쪽
					);
					// ("direction: " ++ direction).postln;
					// ("pos: "++pos).postln;
					direction = (direction + 1) % 4; // 시계방향으로 90도 회전

				};



			},
			1, {dirBase = ez.value.asInteger;},
			{}
		);
		},
		initVals[i],
	);
};

// clear 버튼 추가
Button(wc,
	Rect(400, 100, 100, 50))
.states_([
	["Clear GradRect", Color.black, Color.white]
]
)
.action_({
	list_rect[0].do { |rect| rect.clear }; // 각 GradRect에 clear 메서드 호출
});
CmdPeriod.doOnce({w.close; wc.close});
)