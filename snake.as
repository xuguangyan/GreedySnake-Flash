//---------------------------
//说明:贪吃蛇源码
//作者:大圣 2007-7-25
//---------------------------

onClipEvent(load){
	//初始化
	var cur_score; //当前分数
	var cur_loop; //循环标志
	var intervalID; //间隔函数ID
	var cur_row,cur_col; //当前蛇头坐标(以box为单位,从下标1,1开始)
	var cur_num; //当前蛇头索引
	var cur_food; //当前食物索引
	var cur_direction; //当前行走方向
	var cur_snake=new Array(); //蛇结构
	
	//重设游戏
	reset();
	
	//通过坐标获取box索引
	function getNum(row,col){
		return (row-1)*16+col;
	}
	//添加蛇长
	function addSnake(num){
		var cur_box=eval("_root.box"+num);
		setProperty(cur_box,_alpha,100);
		_root.head._x=cur_box._x;
		_root.head._y=cur_box._y;
		cur_snake.push(num);
	}
	//移动蛇身
	function moveSnake(){
		var num=cur_snake.shift();
		setProperty(eval("_root.box"+num),_alpha,0);
		cur_num=getNum(cur_row,cur_col);
		addSnake(cur_num);
	}
	//删除整蛇
	function delSnake(){
		while(cur_snake.length>0)
		{
			cur_snake.pop();
		}
	}
	//判断box是否是蛇身
	function isBody(){
		var num=getNum(cur_row,cur_col);
		for(var i=0;i<cur_snake.length;i++)
		{
			if(cur_snake[i]==num)
				return true;
		}
		return false;
	}
	//判断box是否越墙
	function isHit(){
		if(cur_row<1||cur_row>16||cur_col<1||cur_col>16)
			return true;
		else
			return false;
	}
	//判断box是否是食物
	function isFood(){
		var num=getNum(cur_row,cur_col);
		if(cur_food==num)
			return true;
		else
			return false;
	}
	//放置食物
	function setFood(){
		var flag=false;
		do{
			cur_food=Math.ceil(Math.random()*256);
			var box_obj=eval("_root.box"+cur_food);
			if(box_obj._alpha==0){
				flag=true;
				break;
			}
		}while(!flag);
		setProperty(box_obj,_alpha,100);
	}
	//吃掉食物
	function eatFood(){
		var num=getNum(cur_row,cur_col);
		addSnake(num);
		setFood();
		cur_score++;
	}
	//方向控制
	function directionSnake(){
		switch(cur_direction){
			case 1:{cur_col--;break;}
			case 2:{cur_col++;break;}
			case 3:{cur_row--;break;}
			case 4:{cur_row++;break;}
		}
		if(!isBody()&&!isHit()){
			if(isFood()){
				eatFood();
			}
			else{
				moveSnake();
			}
		}
		else{
			gameOver();
		}
		cur_loop=true;
	}
	//隐藏所有box
	function setAllHide(){
		for(var i=1;i<=256;i++)
		{
			setProperty("_root.box"+i,_alpha,"0");
		}
	}
	//显示所有box
	function setAllShow(){
		for(var i=1;i<=256;i++)
		{
			setProperty("_root.box"+i,_alpha,"100");
		}
	}
	//显示某些box(用于屏幕输出)
	function setSomeShow(arr){
		for(var i=0;i<arr.length;i++)
		{
			setProperty("_root.box"+arr[i],_alpha,"100");
		}
	}
	//游戏结束
	function gameOver(){
		setAllHide();
		setProperty("_root.head",_alpha,"0");
		var arr=new Array(66,67,68,70,74,76,77,82,86,87,90,92,95,98,102,104,106,108,114,115,116,118,122,124,128,130,134,137,138,140,146,150,154,156,159,162,163,164,166,170,172,173);
		setSomeShow(arr);
		setProperty("_root.reset",_alpha,"100");
		_root.score.text="成绩:"+cur_score+"分";
		if(cur_loop){
			clearInterval(intervalID);
			cur_loop=false;
		}
	}
	//重设游戏
	function reset(){
		cur_score=0;
		cur_loop=false;
		_root.score.text="";
		setProperty("_root.head",_alpha,"100");
		setProperty("_root.reset",_alpha,"0");
		//随机产生蛇头位置
		cur_num=Math.ceil(Math.random()*256);
		cur_row=Math.floor(cur_num/16)+1;
		cur_col=cur_num-(cur_row-1)*16;
		//擦除所有box
		setAllHide();
		//删除原蛇
		delSnake();
		//添加蛇头
		addSnake(cur_num);
		//设置食物
		setFood();
	}
	_root.reset.onRelease=reset;
}
//左转
on(keyPress "<Left>"){
	cur_direction=1;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}
//右转
on(keyPress "<Right>"){
	cur_direction=2;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}
//上转
on(keyPress "<Up>"){
	cur_direction=3;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}
//下转
on(keyPress "<Down>"){
	cur_direction=4;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}