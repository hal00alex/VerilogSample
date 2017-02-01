//To Do: Death, Start/Pulse, Teleport
//Haley Tonight: Teleport equations 


module SinglePulser(button, pulsebutton, clk);

input clk, button;
reg state;
output reg pulsebutton;

initial
begin
state<=0;
end

always @(posedge clk)
begin
if (button==1 && state==0)
begin
state<=1;
pulsebutton<=1;
end

else if (button==1 && state==1) 
begin
state<=1;
pulsebutton<=0;
end

else 
begin
state<=0;
pulsebutton<=0;
end
end
endmodule


module Top (CLK, SW6, R1, G1, B1, Hs, Vs, PS2Clk, si); 
input CLK, SW6, PS2Clk, si;  
output Hs, Vs; 
output [3:0] R1, B1, G1; 
wire [4:0] counter; 
wire [21:0] Q;


shift S2(PS2Clk, si, Q, counter);
Master M(CLK, SW6, R1, G1, B1, Hs, Vs, PS2Clk, counter, Q); 


endmodule 


module shift (PS2Clk, si, Q, counter);
input PS2Clk,si;
output reg [21:0] Q;
output reg [4:0] counter;
always@(negedge PS2Clk)
	begin
	  Q[21]<=si;
	  Q[20:0]<=Q[21:1]; 
	  if(counter==11) counter=1;
	  else counter=counter+1;
	end
endmodule


module Master (CLK, SW6, R1, G1, B1, Hs, Vs, PS2Clk, counter, Q);
input CLK, SW6, PS2Clk;  
//input [7:0] key; 

reg singlepulser, singlepulserD, singlepulserU, singlepulserL,singlepulserR, singlepulserESC, ap1, ap2, ap3; 
wire singlepulser2, singlepulserD2, singlepulserU2, singlepulserL2, singlepulserR2; 
wire singlepulser2F, singlepulserDF, singlepulserUF, singlepulserLF, singlepulserRF, singlepulserESC2; 
reg [12:0] X1, Y1, X2, Y2; 
reg escFlag; 
//output pixel; 
input [21:0] Q; 
input [4:0] counter; 
output Hs, Vs; 
output [3:0] R1, B1, G1; 
reg [8:0] length; 
reg leftFlag, rightFlag, upFlag, downFlag, moveFlag, VFlag, HFlag, startFlag, deathFlag; 
complexDivider CLK1(CLK, slowCLK); 
complexDivider2 frame1(CLK, frame); 
MonitorB M(slowCLK, X1, X2, Y1, Y2, Hs, Vs, R1, G1, B1, SW6, startFlag, deathFlag, ap1, ap2, ap3, escFlag);  
SinglePulser S1(singlepulser, singlepulser2, CLK); 
SinglePulser S2(singlepulserD, singlepulserD2, CLK); 
SinglePulser S3(singlepulserU, singlepulserU2, CLK); 
SinglePulser S4(singlepulserL, singlepulserL2, CLK); 
SinglePulser S5(singlepulserR, singlepulserR2, CLK);

SinglePulser S10(singlepulser, singlepulser2F, frame);
SinglePulser S6(singlepulserD, singlepulserDF, frame);
SinglePulser S7(singlepulserU, singlepulserUF, frame);
SinglePulser S8(singlepulserL, singlepulserLF, frame);
SinglePulser S9(singlepulserR, singlepulserRF, frame);
SinglePulser S11(singlepulserESC, singlepulserESC2, frame); 

//starts black
initial 
begin
leftFlag <= 0; 
upFlag <= 0; 
downFlag <= 0; 
VFlag <= 0; 
startFlag <= 0; 
rightFlag <= 1; 
moveFlag <= 1;
HFlag <= 1;  
X1 <= 70; 
X2 <= 20;
Y1 <= 10; 
Y2 <= 20; 
length <= 50; 
ap1 <= 1; 
ap2 <= 0; 
ap3 <= 0; 
end
 
//always block for keys 
always @(posedge frame) 
begin 

//reading keys 
singlepulser = ((Q[19:12]==8'h1B) && (counter == 11) && (Q[8:1] == 8'hF0)); 
singlepulserD = ((Q[19:12]==8'h72) && (counter == 11) && (Q[8:1] == 8'hF0)); 
singlepulserU = ((Q[19:12]==8'h75) && (counter == 11) && (Q[8:1] == 8'hF0)); 
singlepulserL = ((Q[19:12]==8'h6B) && (counter == 11) && (Q[8:1] == 8'hF0)); 
singlepulserR = ((Q[19:12]==8'h74) && (counter == 11) && (Q[8:1] == 8'hF0)); 
singlepulserESC = ((Q[19:12]==8'h76) && (counter == 11) && (Q[8:1] == 8'hF0)) ; 

//X1 >= 290 || X1 <= 310 || X2 <= 290 || X2 <= 320 || Y1 >= 190 || Y1 <= 220 || Y2 >= 190 || Y2 <= 220
//apple1
if (ap1==1 && (((X1>=300 && X1<=310) && (rightFlag==1)) || ((X2>=300 && X2<=310) && (leftFlag==1))) && ((Y1>=200 && Y1<=210)))
begin
ap1<=0;
ap2<=1;
ap3<=0;
end

else if (ap1==1 && ((X1>=300 && X1<=310)) && (((Y1>=201 && Y1<=209) && (upFlag==1)) || ((Y2>=200 && Y2<=210) && (downFlag==1))))
//start
begin
ap1<=0;
ap2<=1;
ap3<=0;
end



//ap2 
else if (ap2==1 && (((X1>=600 && X1<=610) && (rightFlag==1)) || ((X2>=600 && X2<=610) && (leftFlag==1))) && ((Y1>=40 && Y1<=50)))
begin
ap1<=0;
ap2<=0;
ap3<=1;
end

else if (ap2==1 && ((X1>=600 && X1<=610)) && (((Y1>=40 && Y1<=50) && (upFlag==1)) || ((Y2>=40 && Y2<=50) && (downFlag==1))))
//start
begin
ap1<=0;
ap2<=0;
ap3<=1;
end


//ap3 
else if (ap3==1 && (((X1>=40 && X1<=50) && (rightFlag==1)) || ((X2>=40 && X2<=50) && (leftFlag==1))) && ((Y1>=400 && Y1<=410)))
begin
ap1<=1;
ap2<=0;
ap3<=0;
end

else if (ap3==1 && ((X1>=40 && X1<=50)) && (((Y1>=400 && Y1<=410) && (upFlag==1)) || ((Y2>=400 && Y2<=410) && (downFlag==1))))
//start
begin
ap1<=1;
ap2<=0;
ap3<=0;
end

if (singlepulser2F ==1)
	begin
	//set start flag 
	startFlag <= 1; 
	rightFlag <= 1; 
	HFlag <= 1; 
	moveFlag <= 1;
	downFlag <= 0; 
	upFlag <= 0; 
	escFlag <= 0; 
	leftFlag<=0;
		ap1<=1; 
		deathFlag<=0;
	//write snake's start position 
	end 
	
//if esc 
else if (singlepulserESC2 == 1) 
	begin
	startFlag <= 0;
	//rightFlag <= 1; 
	deathFlag <= 0; 
	HFlag <= 0; 
	//iffy here
	moveFlag <= 0;   
	upFlag<=0;
	downFlag<=0;
	rightFlag<=0;
	leftFlag<=0;
	escFlag <= 1; 
	ap1<=0;
	ap2<=0;
	ap3<=0;
	end 
	
//if up and on and horizontal flag on and not dead and move on 
else if (singlepulserUF == 1 && startFlag == 1 && HFlag == 1 && moveFlag == 1) 
	begin 
	VFlag <= 1; 
	HFlag <= 0;  
	upFlag <= 1; 
	leftFlag <= 0; 
	rightFlag <= 0; 
	downFlag <= 0; 
	end 

//if down and on horizontal flag on and not dead and move on
else if (singlepulserDF == 1 && startFlag == 1 && HFlag == 1 && moveFlag == 1) 
	begin 
	VFlag <= 1; 
	HFlag <= 0;  
	upFlag <= 0; 
	leftFlag <= 0; 
	rightFlag <= 0; 
	downFlag <= 1;
	end

//if left and on and vertical flag on and not dead and move on
else if (singlepulserLF == 1 && startFlag == 1 && VFlag == 1 && moveFlag == 1)
	begin 
	VFlag <= 0; 
	HFlag <= 1;  
	upFlag <= 0; 
	leftFlag <= 1; 
	rightFlag <= 0; 
	downFlag <= 0;
	end

//if right and on and vertical flag on and not dead  and move on 
else if (singlepulserRF == 1 && startFlag == 1 && VFlag == 1 && moveFlag == 1) 
	begin 
	VFlag <= 0; 
	HFlag <= 1;  
	upFlag <= 0; 
	leftFlag <= 0; 
	rightFlag <= 1; 
	downFlag <= 0; 
	end

//if R and on and not dead and paused 
else if (Q[19:12]==8'h2D && counter == 11 && Q[8:1] == 8'hF0  && startFlag == 1 && moveFlag == 0 && deathFlag==0)
	begin 
	moveFlag <= 1; 
	end 

//if pause 
else if (Q[19:12]==8'h4D && counter == 11 && Q[8:1] == 8'hF0 && startFlag == 1 && moveFlag == 1)
	begin 
	moveFlag <= 0; 
	end 
//death 
else if (X1 <= 0 || X2 <= 0 || X1 >= 640 || X2 >= 640 || Y1 <= 0  || Y2 <=  0  || Y1 >= 480 || Y2 >= 480) 
    begin
    moveFlag <= 0;
    //startFlag <= 1;  
    deathFlag<=1; 
    startFlag<=0;
    ap1<=0;
    ap2<=0;
    ap3<=0;
    end 
end 
////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
always @(posedge frame)
begin 
//start/restart
if (singlepulser2F == 1)
    begin 
    X1 <= 60; 
    X2 <= 10;
    Y1 <= 10; 
    Y2 <= 20; 
    //startFlag <= 1; 
    end 

//down teleport 
else if (singlepulserDF == 1 && moveFlag == 1 && rightFlag == 1 && downFlag != 1 && upFlag !=1)
    begin 
    X2 = X1; 
    X1 = X1 + 10; 
    Y1 = Y2; 
    Y2 = Y2 + 50; 
    end 


else if (singlepulserDF == 1 && moveFlag == 1 && leftFlag == 1 && downFlag !=1 && upFlag !=1) 
    begin 
    X1 = X2; 
    X2 = X2 - 10; 
    Y1 = Y2; 
    Y2 = Y2 + 50; 
    end
    
//up teleport 
else if (singlepulserUF == 1 && moveFlag == 1 && upFlag!=1 && downFlag!=1 && rightFlag == 1)
    begin
    X2 = X1; 
    X1 = X1 + 10;
    Y2 = Y1;  
    Y1 = Y1 - 50; 
    end   
    
else if (singlepulserUF == 1 && moveFlag == 1 && upFlag != 1 && downFlag != 1 && leftFlag == 1)
    begin 
    //X2 = X1; 
    X1 = X2 + 10; 
    //Y2 = Y1; 
    Y1 = Y2 - 50; 
    end 
    
//left teleport
else if (singlepulserLF == 1 && moveFlag == 1 && leftFlag!=1 && rightFlag!=1 && upFlag == 1) 
    begin
    X2 = X1 - 50; 
    //X1 = X1;  
    //Y1 = Y2; 
    Y2 = Y1 + 10; 
    end 

else if (singlepulserLF == 1 && moveFlag == 1 && leftFlag!=1 && rightFlag!=1 && downFlag == 1) 
    begin
    X2 = X1 - 50; 
    //X1 = X1;  
    //Y1 = Y2; 
    Y1 = Y2 - 10; 
    //Y2 = Y1 + 10; 
    end 
    
 //right teleport    
else if (singlepulserRF == 1 && moveFlag == 1 && rightFlag!=1 && leftFlag!=1 && downFlag == 1) 
    begin
    X2 = X1; 
    X1 = X1 + 50; 
    Y1 = Y2; 
    Y2 = Y1 + 10; 
    end 

else if (singlepulserRF == 1 && moveFlag == 1 && rightFlag!=1 && leftFlag!=1 && upFlag == 1) 
    begin
    //X2 = X1; 
    X1 = X2 + 50; 
    //Y1 = Y2; 
    Y2 = Y1 + 10; 
    end  
 
//incrementing 
else if (leftFlag == 1 && moveFlag == 1)
    begin
    X1 <= X1 - 10; 
    X2 <= X2 - 10; 
    end 
    
else if (rightFlag == 1 && moveFlag == 1 )
    begin
     X1 <= X1 + 10; 
     X2 <= X2 + 10; 
    end 
else if (upFlag == 1 && moveFlag == 1)
    begin
     Y1 <= Y1 - 10; 
     Y2 <= Y2 - 10; 
    end  
else if (downFlag == 1 && moveFlag == 1)
    begin
     Y1 <= Y1 + 10; 
     Y2 <= Y2 + 10; 
    end 
end  
endmodule 

module complexDivider(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock
  reg[27:0] counter;
  initial begin
    counter = 0;
    slowClk = 0;
  end
  always @ (posedge clk100Mhz)
  begin
    if(counter == 2) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule


module complexDivider2(clk100Mhz, slowClk);
  input clk100Mhz; //fast clock
  output reg slowClk; //slow clock
  reg[27:0] counter;
  initial begin
    counter = 0;
    slowClk = 0;
  end
  always @ (posedge clk100Mhz)
  begin
    if(counter == 12500000) begin
      counter <= 1;
      slowClk <= ~slowClk;
    end
    else begin
      counter <= counter + 1;
    end
  end
endmodule


module MonitorB(CLK, X1, X2, Y1, Y2, Hsynch, Vsynch, R, G, B, SW6, startFlag, deathFlag, ap1, ap2, ap3, escFlag);
input CLK, SW6, startFlag, deathFlag, escFlag; 
output reg [3:0] R, G, B;
input [12:0] X1, X2, Y1, Y2; 
reg [12:0] HCount, VCount; 
output reg Hsynch, Vsynch;  
input ap1, ap2, ap3;
//change to slow CLK
initial 
begin 
HCount <= 0; 
VCount <= 0; 
Hsynch <= 1; 
Vsynch <= 1; 
end 
always @(posedge CLK) 
begin 
//incrementing code/signal code 
//put all the values -be carefulof too many latches?   
//new row
//HCount <= HCount + 1; 
if (HCount >= 800)
	begin
	HCount <= 0;
	VCount <= VCount + 1; 
	end 
else
	begin 
	HCount <= HCount + 1; 
	VCount <= VCount; 
	end 

//high Hsynch 
if ((HCount >= 0 && HCount <= 659) || (HCount >= 755 && HCount <= 799))
	begin 
	Hsynch <= 1; 
	Vsynch <= Vsynch; 
	end

//low Hsynch
else if (HCount >= 659 && HCount <= 755) 
	begin 
	Hsynch <= 0; 
	Vsynch <= Vsynch;  
	end 

//high Vsynch 
else if ((VCount >= 0 && VCount <= 492) || (VCount >= 495 && VCount <= 524))
	begin 
	Hsynch <= Hsynch; 
	Vsynch <= 1; 
	end 
//low Vsynch 
else if (VCount == 493 || VCount <= 494)
	begin 
	Vsynch <= 0; 
	Hsynch <= Hsynch; 
	end 
//safety 
else
	begin 
	Hsynch <= Hsynch;  
	Vsynch <= Vsynch; 
	end 

//reset VCount for new coulmn  
if (VCount >= 525)
	begin 
	VCount <= 0;    
	end 

//color code 
//blanking 
if (HCount >= 640 || VCount >= 480)
	begin 
	R <= 4'h0; 
	G <= 4'h0; 
	B <= 4'h0; 
	end 

//red snake 
else if (escFlag==0 &&((startFlag == 1 || deathFlag == 1) && HCount <= X1 && HCount >= X2 && VCount >= Y1 && VCount <= Y2))
	begin 
	R <= 4'hF; 
	G <= 4'h0; 
	B <= 4'h0; 
	end 

else if (ap1 == 1 && HCount <= 312 && HCount >= 298 && VCount >= 198 && VCount <= 212 && startFlag == 1) 
    begin 
    R<=4'h0;
    G<=4'hF;
    B<=4'h0;
    end 

//??
else if (ap1 == 0 && HCount <= 312 && HCount >= 298 && VCount >= 198 && VCount <= 212 && startFlag == 1)
    begin 
    R <= 4'h0; 
    G <= 4'h0; 
    B <= 4'h0;
    end 
    
 //ap2
 else if (ap2 == 1 && HCount <= 611 && HCount >= 599 && VCount >= 39 && VCount <= 51 && startFlag == 1) 
     begin 
     R<=4'h0;
     G<=4'hF;
     B<=4'h0;
     end 
 
 //??
 else if (ap2 == 0 && HCount <= 611 && HCount >= 599 && VCount >= 39 && VCount <= 51 && startFlag == 1)
     begin 
     R <= 4'h0; 
     G <= 4'h0; 
     B <= 4'h0;
     end
      
 //ap3 
 else if (ap3 == 1 && HCount <= 51 && HCount >= 39 && VCount >= 399 && VCount <= 411 && startFlag == 1) 
     begin 
     R<=4'h0;
     G<=4'hF;
     B<=4'h0;
     end 
 
 //??
 else if (ap3 == 0 && HCount <= 51 && HCount >= 39 && VCount >= 399 && VCount <= 411 && startFlag == 1)
     begin 
     R <= 4'h0; 
     G <= 4'h0; 
     B <= 4'h0;
     end 
//safety check 
else if (SW6 == 1)
	begin 
	R <= 4'h0;
	G <= 4'hC;
	B <= 4'hC; 
	end 
	
else if (escFlag == 1)
begin 
R <= 4'h0; 
G <= 4'h0; 
B <= 4'h0; 
end 

else 
	begin 
	R <= 4'h0; 
	G <= 4'h0; 
	B <= 4'h0; 
	end  
end
endmodule 
