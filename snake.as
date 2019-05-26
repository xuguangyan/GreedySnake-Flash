//---------------------------
//˵��:̰����Դ��
//����:��ʥ 2007-7-25
//---------------------------

onClipEvent(load){
	//��ʼ��
	var cur_score; //��ǰ����
	var cur_loop; //ѭ����־
	var intervalID; //�������ID
	var cur_row,cur_col; //��ǰ��ͷ����(��boxΪ��λ,���±�1,1��ʼ)
	var cur_num; //��ǰ��ͷ����
	var cur_food; //��ǰʳ������
	var cur_direction; //��ǰ���߷���
	var cur_snake=new Array(); //�߽ṹ
	
	//������Ϸ
	reset();
	
	//ͨ�������ȡbox����
	function getNum(row,col){
		return (row-1)*16+col;
	}
	//����߳�
	function addSnake(num){
		var cur_box=eval("_root.box"+num);
		setProperty(cur_box,_alpha,100);
		_root.head._x=cur_box._x;
		_root.head._y=cur_box._y;
		cur_snake.push(num);
	}
	//�ƶ�����
	function moveSnake(){
		var num=cur_snake.shift();
		setProperty(eval("_root.box"+num),_alpha,0);
		cur_num=getNum(cur_row,cur_col);
		addSnake(cur_num);
	}
	//ɾ������
	function delSnake(){
		while(cur_snake.length>0)
		{
			cur_snake.pop();
		}
	}
	//�ж�box�Ƿ�������
	function isBody(){
		var num=getNum(cur_row,cur_col);
		for(var i=0;i<cur_snake.length;i++)
		{
			if(cur_snake[i]==num)
				return true;
		}
		return false;
	}
	//�ж�box�Ƿ�Խǽ
	function isHit(){
		if(cur_row<1||cur_row>16||cur_col<1||cur_col>16)
			return true;
		else
			return false;
	}
	//�ж�box�Ƿ���ʳ��
	function isFood(){
		var num=getNum(cur_row,cur_col);
		if(cur_food==num)
			return true;
		else
			return false;
	}
	//����ʳ��
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
	//�Ե�ʳ��
	function eatFood(){
		var num=getNum(cur_row,cur_col);
		addSnake(num);
		setFood();
		cur_score++;
	}
	//�������
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
	//��������box
	function setAllHide(){
		for(var i=1;i<=256;i++)
		{
			setProperty("_root.box"+i,_alpha,"0");
		}
	}
	//��ʾ����box
	function setAllShow(){
		for(var i=1;i<=256;i++)
		{
			setProperty("_root.box"+i,_alpha,"100");
		}
	}
	//��ʾĳЩbox(������Ļ���)
	function setSomeShow(arr){
		for(var i=0;i<arr.length;i++)
		{
			setProperty("_root.box"+arr[i],_alpha,"100");
		}
	}
	//��Ϸ����
	function gameOver(){
		setAllHide();
		setProperty("_root.head",_alpha,"0");
		var arr=new Array(66,67,68,70,74,76,77,82,86,87,90,92,95,98,102,104,106,108,114,115,116,118,122,124,128,130,134,137,138,140,146,150,154,156,159,162,163,164,166,170,172,173);
		setSomeShow(arr);
		setProperty("_root.reset",_alpha,"100");
		_root.score.text="�ɼ�:"+cur_score+"��";
		if(cur_loop){
			clearInterval(intervalID);
			cur_loop=false;
		}
	}
	//������Ϸ
	function reset(){
		cur_score=0;
		cur_loop=false;
		_root.score.text="";
		setProperty("_root.head",_alpha,"100");
		setProperty("_root.reset",_alpha,"0");
		//���������ͷλ��
		cur_num=Math.ceil(Math.random()*256);
		cur_row=Math.floor(cur_num/16)+1;
		cur_col=cur_num-(cur_row-1)*16;
		//��������box
		setAllHide();
		//ɾ��ԭ��
		delSnake();
		//�����ͷ
		addSnake(cur_num);
		//����ʳ��
		setFood();
	}
	_root.reset.onRelease=reset;
}
//��ת
on(keyPress "<Left>"){
	cur_direction=1;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}
//��ת
on(keyPress "<Right>"){
	cur_direction=2;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}
//��ת
on(keyPress "<Up>"){
	cur_direction=3;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}
//��ת
on(keyPress "<Down>"){
	cur_direction=4;
	if(!cur_loop) intervalID=setInterval(directionSnake,200);
}